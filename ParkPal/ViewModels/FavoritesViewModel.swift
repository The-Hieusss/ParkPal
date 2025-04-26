import Foundation
import SwiftData

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favorites: [FavoriteSpot] = []

    func loadFavorites(context: ModelContext) {
        do {
            favorites = try context.fetch(FetchDescriptor<FavoriteSpot>())
        } catch {
            print("Failed to load favorites: \(error)")
        }
    }

    func saveFavorite(spot: ParkingSpot, note: String?, context: ModelContext) {
        let fav = FavoriteSpot(
            name: spot.name,
            spotID: spot.id,
            notes: note,
            address: spot.address // 🆕 Save address from the ParkingSpot
        )
        context.insert(fav)
        try? context.save() // 🛟 Save context immediately if needed
    }
}
