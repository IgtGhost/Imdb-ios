import SwiftUI

struct MovieFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var movieManager: MovieManager
    var movieToEdit: Movie?

    @State private var title: String = ""
    @State private var year: String = ""
    @State private var rating: Double = 3.0
    @State private var description: String = ""
    @State private var posterURL: String = ""
    @State private var errorMessage: String?

    var isEditing: Bool {
        return movieToEdit != nil
    }

    init(movieManager: MovieManager, movieToEdit: Movie? = nil) {
        self.movieManager = movieManager
        if let movie = movieToEdit {
            _title = State(initialValue: movie.title)
            _year = State(initialValue: movie.year)
            _rating = State(initialValue: movie.rating)
            _description = State(initialValue: movie.description)
            _posterURL = State(initialValue: movie.posterURL ?? "")
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Movie Details")) {
                    TextField("Title", text: $title)
                    TextField("Year", text: $year)
                        .keyboardType(.numberPad)

                    Slider(value: $rating, in: 0...5, step: 0.1) {
                        Text("Rating")
                    }
                    Text("⭐ \(rating, specifier: "%.1f")")

                    TextEditor(text: $description)
                        .frame(height: 100)
                }

                Section(header: Text("Movie Poster")) {
                    TextField("Poster URL", text: $posterURL)
                }

                // Show error message if validation fails
                if let errorMessage = errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }

                Section {
                    Button(action: saveMovie) {
                        Text(isEditing ? "Update Movie" : "Add Movie")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!isValidMovie()) // ✅ Disable button if inputs are invalid
                }
            }
            .navigationTitle(isEditing ? "Edit Movie" : "Add Movie")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }

    /// ✅ Validates inputs before saving the movie
    private func isValidMovie() -> Bool {
        return !title.isEmpty && !year.isEmpty && !description.isEmpty && !posterURL.isEmpty
    }

    /// ✅ Saves the movie only if inputs are valid
    private func saveMovie() {
        guard isValidMovie() else {
            errorMessage = "All fields are required!"
            return
        }

        if let existingMovie = movieToEdit {
            // ✅ Ensure correct parameter label is used when editing
            let updatedMovie = Movie(
                id: existingMovie.id, // ✅ Keeps the same ID
                title: title,
                year: year,
                rating: rating,
                description: description,
                posterURL: posterURL
            )
            movieManager.editMovie(updatedMovie: updatedMovie) // ✅ Label added
        } else {
            // ✅ Add a new movie only if it's NOT an edit
            let newMovie = Movie(
                title: title,
                year: year,
                rating: rating,
                description: description,
                posterURL: posterURL
            )
            movieManager.addMovie(newMovie)
        }

        presentationMode.wrappedValue.dismiss()
    }
}
