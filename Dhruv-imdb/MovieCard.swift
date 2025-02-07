import SwiftUI

struct MovieCard: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 12) {
            // ✅ Movie Poster with Placeholder
            AsyncImage(url: URL(string: movie.posterURL ?? "")) { image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 120)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            } placeholder: {
                Color.gray.frame(width: 80, height: 120)
                    .cornerRadius(10)
            }

            // ✅ Movie Info
            VStack(alignment: .leading, spacing: 5) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)

                Text(movie.year)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("\(movie.rating, specifier: "%.1f")")
                        .font(.headline)
                        .foregroundColor(.yellow)
                }
            }
            .padding(.leading, 5)

            Spacer()

            // ✅ Three-dot Menu (Black)
            Image(systemName: "ellipsis")
                .foregroundColor(.black) // ✅ Black for better visibility
                .padding()
        }
        .padding()
        .background(Color.black.opacity(0.9)) // ✅ Darker for better contrast
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

#Preview {
    MovieCard(movie: Movie(title: "Inception", year: "2010", rating: 4.8, description: "A mind-bending thriller", posterURL: "https://image.tmdb.org/t/p/w500/qmDpIHrmpJINaRKAfWQfftjCdyi.jpg"))
}
