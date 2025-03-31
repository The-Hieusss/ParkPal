import SwiftUI
import SwiftData


struct ParkingCardView: View {
    let spot: ParkingSpot
    @Environment(\.modelContext) private var context
    @State private var isSaved = false

    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue.opacity(0.2))
                .frame(width: 60, height: 60)
                .overlay(Image(systemName: "car.fill").foregroundColor(.blue))

            VStack(alignment: .leading, spacing: 4) {
                Text(spot.name).font(.headline)
                Text("Available: \(spot.availableSpots)/\(spot.totalSpots)")
                Text(spot.address).font(.subheadline).foregroundColor(.gray)
            }

            Spacer()

            Button(action: {
                saveToFavorites()
            }) {
                Image(systemName: isSaved ? "heart.fill" : "heart")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 4)
    }

    private func saveToFavorites() {
           let favorite = FavoriteSpot(name: spot.name, spotID: spot.id, notes: nil)
           context.insert(favorite)
           isSaved = true
       }



}
