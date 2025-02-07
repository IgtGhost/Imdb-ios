import Foundation

class MovieService: ObservableObject {
    @Published var apiFetchedMovies: [Movie] = [] // Store fetched movies

    private let apiKey = "188976ea"

    /// ✅ Fetch movies by search query
    func fetchMovies(searchQuery: String) {
        guard !searchQuery.isEmpty else { return }

        let urlString = "https://www.omdbapi.com/?apikey=\(apiKey)&s=\(searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"

        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Error fetching movies: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    print("❌ No data received")
                    return
                }

                do {
                    let decodedResponse = try JSONDecoder().decode(MovieSearchResponse.self, from: data)

                    if let searchResults = decodedResponse.Search {
                        self.apiFetchedMovies = [] // ✅ Clear previous results
                        for movie in searchResults {
                            self.fetchMovieDetails(imdbID: movie.imdbID, movieInfo: movie) // ✅ Fetch full details
                        }
                    } else {
                        print("❌ No movies found")
                        self.apiFetchedMovies = []
                    }
                } catch {
                    print("❌ Failed to decode movies: \(error)")
                    self.apiFetchedMovies = []
                }
            }
        }.resume()
    }

    /// ✅ Fetch full movie details using IMDb ID
    func fetchMovieDetails(imdbID: String, movieInfo: MovieSearchResult) {
        let urlString = "https://www.omdbapi.com/?apikey=\(apiKey)&i=\(imdbID)&plot=full"

        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL for movie details")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Error fetching movie details: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    print("❌ No data received for details")
                    return
                }

                do {
                    var detailedMovie = try JSONDecoder().decode(Movie.self, from: data)

                    // ✅ Assign missing values from the search result if needed
                    detailedMovie.id = UUID() // ✅ Assign a unique ID
                    detailedMovie.title = movieInfo.Title
                    detailedMovie.year = movieInfo.Year
                    detailedMovie.posterURL = movieInfo.Poster

                    self.apiFetchedMovies.append(detailedMovie) // ✅ Add detailed movie
                } catch {
                    print("❌ Failed to decode movie details: \(error)")
                }
            }
        }.resume()
    }
}

// Model for search response
struct MovieSearchResponse: Codable {
    let Search: [MovieSearchResult]?
}

// Model for search results
struct MovieSearchResult: Codable {
    let imdbID: String
    let Title: String
    let Year: String
    let Poster: String?
}
