import SwiftUI

struct FavoritesView: View {
    @Environment(\.modelContext) private var context
    @StateObject var viewModel = FavoritesViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.favorites) { fav in
                    FavoriteCardRow(favorite: fav)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                .onDelete(perform: deleteFavorite)
            }
            .listStyle(.plain)
            .navigationTitle("Favorites")
            .onAppear {
                viewModel.loadFavorites(context: context)
            }
        }
    }

    private func deleteFavorite(at offsets: IndexSet) {
        for index in offsets {
            let fav = viewModel.favorites[index]
            context.delete(fav)
        }
        viewModel.loadFavorites(context: context)
    }
}
struct FavoriteCardRow: View {
    let favorite: FavoriteSpot
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(favorite.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .rotationEffect(.degrees(isExpanded ? 90 : 0))
                    .foregroundColor(.gray)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.easeInOut) {
                    isExpanded.toggle()
                }
            }

            if isExpanded {
                VStack(alignment: .leading, spacing: 6) {
                    if let notes = favorite.notes, !notes.isEmpty {
                        Text(notes)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    // 👉 Show address if expanded
                    if let address = favorite.address {
                        Text("📍 \(address)")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.top, 4)
                .transition(.opacity)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
