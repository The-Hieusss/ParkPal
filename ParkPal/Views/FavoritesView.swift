import SwiftUI

struct FavoritesView: View {
    @Environment(\.modelContext) private var context
    @StateObject var viewModel = FavoritesViewModel()

    var body: some View {
        List {
            ForEach(viewModel.favorites) { fav in
                VStack(alignment: .leading) {
                    Text(fav.name).bold()
                    Text(fav.notes ?? "")
                }
            }
            .onDelete(perform: deleteFavorite)
        }
        .onAppear {
            viewModel.loadFavorites(context: context)
        }
    }

    private func deleteFavorite(at offsets: IndexSet) {
        for index in offsets {
            let fav = viewModel.favorites[index]
            context.delete(fav)
        }

        // Reload after deletion
        viewModel.loadFavorites(context: context)
    }
}
