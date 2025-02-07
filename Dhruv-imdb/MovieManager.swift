import Foundation

class MovieManager: ObservableObject {
    @Published var movies: [Movie] = []

    init() {
        loadMovies()
    }

    // ✅ Add a new movie
    func addMovie(_ movie: Movie) {
        movies.append(movie)
        saveMovies()
    }

    // ✅ Properly edit an existing movie instead of adding a new one
    func editMovie(updatedMovie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == updatedMovie.id }) {
            movies[index] = updatedMovie // ✅ Replace existing movie
            saveMovies()
        }
    }

    // ✅ Delete a movie
    func deleteMovie(_ movie: Movie) {
        movies.removeAll { $0.id == movie.id }
        saveMovies()
    }

    // ✅ Save movies
    private func saveMovies() {
        if let encodedData = try? JSONEncoder().encode(movies) {
            UserDefaults.standard.set(encodedData, forKey: "savedMovies")
        }
    }

    // ✅ Load movies
    func loadMovies() {
        if let savedData = UserDefaults.standard.data(forKey: "savedMovies"),
           let decodedMovies = try? JSONDecoder().decode([Movie].self, from: savedData) {
            movies = decodedMovies
        }
    }
}
