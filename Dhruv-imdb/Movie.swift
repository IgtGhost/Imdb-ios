import Foundation

struct Movie: Identifiable, Codable {
    var id: UUID
    var title: String
    var year: String
    var rating: Double
    var description: String
    var posterURL: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rating = "imdbRating"
        case description = "Plot"
        case posterURL = "Poster"
    }

    // ✅ Custom Decoding to Handle String `imdbRating`
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID() // ✅ Ensure each movie has a unique ID
        title = try container.decode(String.self, forKey: .title)
        year = try container.decode(String.self, forKey: .year)
        description = try container.decode(String.self, forKey: .description)
        posterURL = try? container.decode(String.self, forKey: .posterURL)

        // ✅ Convert `imdbRating` safely from String to Double
        if let ratingString = try? container.decode(String.self, forKey: .rating),
           let ratingValue = Double(ratingString) {
            rating = ratingValue
        } else {
            rating = 0.0 // Default value if rating is missing
        }
    }

    // ✅ Default Initializer for New Movies
    init(title: String, year: String, rating: Double, description: String, posterURL: String?) {
        self.id = UUID() // ✅ Assign a new ID
        self.title = title
        self.year = year
        self.rating = rating
        self.description = description
        self.posterURL = posterURL
    }

    // ✅ Custom Initializer for Editing an Existing Movie
    init(id: UUID, title: String, year: String, rating: Double, description: String, posterURL: String?) {
        self.id = id // ✅ Preserve ID when editing
        self.title = title
        self.year = year
        self.rating = rating
        self.description = description
        self.posterURL = posterURL
    }
}
