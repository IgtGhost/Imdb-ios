import SwiftUI

@main
struct MovieLibraryApp: App {
    var body: some Scene {
        WindowGroup {
            MovieListView() // Make sure this points to your main screen
        }
    }
}
