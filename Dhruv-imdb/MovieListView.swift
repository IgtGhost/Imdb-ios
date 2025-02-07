import SwiftUI

struct MovieListView: View {
    @StateObject private var movieService = MovieService()
    @StateObject private var movieManager = MovieManager()
    @State private var searchText: String = ""
    @State private var isLoading: Bool = false
    @State private var showingAddMovie = false
    @State private var movieToEdit: Movie?
    @State private var selectedTab: MovieTab = .localMovies // Default to Local Movies

    enum MovieTab {
        case localMovies, searchResults
    }

    var body: some View {
        NavigationView {
            VStack {
                // 🔍 Search Bar
                HStack {
                    TextField("Search for a movie...", text: $searchText, onCommit: fetchMovies)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(10)
                        .background(Color(.systemGray6).cornerRadius(10))
                        .padding(.horizontal)

                    if isLoading {
                        ProgressView()
                            .padding(.trailing, 15)
                    }
                }

                // 📌 Segmented Control for Switching Between Tabs
                Picker("Movie Type", selection: $selectedTab) {
                    Text("My Movies").tag(MovieTab.localMovies)
                    Text("Search Results").tag(MovieTab.searchResults)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                // 🎬 Movie List
                if selectedTab == .localMovies {
                    if movieManager.movies.isEmpty {
                        EmptyStateView(text: "No movies added")
                    } else {
                        List {
                            ForEach(movieManager.movies) { movie in
                                HStack {
                                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                                        MovieCard(movie: movie)
                                    }
                                    Spacer()

                                    // ⚙️ Three-dot menu for Edit/Delete
                                    Menu {
                                        Button(action: {
                                            movieToEdit = movie
                                            showingAddMovie = true
                                        }) {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        Button(role: .destructive, action: {
                                            withAnimation {
                                                movieManager.deleteMovie(movie)
                                            }
                                        }) {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .font(.title)
                                            .foregroundColor(.black) // ✅ Black for visibility
                                            .padding()
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                } else {
                    // 🔎 Search Results from API
                    if movieService.apiFetchedMovies.isEmpty {
                        EmptyStateView(text: "No search results")
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(movieService.apiFetchedMovies) { movie in
                                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                                        MovieCard(movie: movie)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                            .padding(.top, 10)
                        }
                    }
                }
            }
            .navigationTitle("🎬 Movie Library")
            .toolbar {
                // ➕ Add Movie Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        movieToEdit = nil // Reset editing state for new movie
                        showingAddMovie = true
                    }) {
                        Label("Add Movie", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddMovie) {
                MovieFormView(movieManager: movieManager, movieToEdit: movieToEdit)
            }
            .onAppear {
                movieManager.loadMovies() // ✅ Ensure movies load properly
            }
        }
    }

    private func fetchMovies() {
        guard !searchText.isEmpty else { return }
        isLoading = true
        movieService.fetchMovies(searchQuery: searchText)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
        }
    }
}

// 📌 Empty State View
struct EmptyStateView: View {
    let text: String
    var body: some View {
        VStack {
            Spacer()
            Text(text)
                .font(.headline)
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

#Preview {
    MovieListView()
}
