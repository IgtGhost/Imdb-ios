import SwiftUI

struct MovieDetailView: View {
    let movie: Movie

    var body: some View {
        ZStack {
            // Background Blur Effect with Poster
            AsyncImage(url: URL(string: movie.posterURL ?? "")) { image in
                image.resizable()
                    .scaledToFill()
                    .blur(radius: 30) // Blurred background effect
                    .opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
            } placeholder: {
                Color.black.opacity(0.5)
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Movie Poster
                    AsyncImage(url: URL(string: movie.posterURL ?? "")) { image in
                        image.resizable()
                            .scaledToFit()
                            .transition(.opacity) // Smooth fade-in effect
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 180, height: 250) // Resized to fit better
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .padding(.top, 20)

                    // Movie Title
                    Text(movie.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .lineLimit(2) // Prevents long titles from overflowing

                    // Movie Rating & Year
                    HStack {
                        Text("⭐ \(movie.rating, specifier: "%.1f")")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)

                        Spacer()

                        Text("📅 \(movie.year)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .frame(maxWidth: 250) // Keeps the layout compact
                    .padding(.horizontal)

                    // Movie Description
                    Text(movie.description)
                        .font(.footnote) // Smaller font for better fit
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: 300, alignment: .leading) // Ensures text wraps
                        .lineLimit(nil) // Allows full description without overflow

                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.black.opacity(0.7)) // Dark translucent background
                        .shadow(radius: 10)
                        .padding()
                )
                .padding(.top, 10)
            }
        }
        .navigationTitle("Movie Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MovieDetailView(movie: Movie(
        title: "Inception",
        year: "2010",
        rating: 4.8,
        description: "A thief who enters the dreams of others to steal secrets. This is a test description to see how the text behaves when it's long.",
        posterURL: "https://image.tmdb.org/t/p/w500/qmDpIHrmpJINaRKAfWQfftjCdyi.jpg"
    ))
}
