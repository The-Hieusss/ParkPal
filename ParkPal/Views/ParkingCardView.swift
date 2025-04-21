import SwiftUI
import SwiftData

struct ParkingCardView: View {
    let spot: ParkingSpot

    @Environment(\.modelContext) private var context
    @Query private var favorites: [FavoriteSpot] // Auto-updating query

    @State private var isSaved = false
    @State private var showReviewSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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
                    toggleFavorite()
                }) {
                    Image(systemName: isSaved ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
            }

            Button {
                showReviewSheet = true
            } label: {
                HStack {
                    Image(systemName: "text.bubble")
                    Text("Reviews")
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            .sheet(isPresented: $showReviewSheet) {
                ReviewView(spot: spot)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 4)
        .onAppear {
            checkIfSaved()
        }
    }

    private func checkIfSaved() {
        isSaved = favorites.contains(where: { $0.spotID == spot.id })
    }

    private func toggleFavorite() {
        if isSaved {
            // Remove favorite
            if let existing = favorites.first(where: { $0.spotID == spot.id }) {
                context.delete(existing)
                try? context.save()
                isSaved = false
            }
        } else {
            // Save favorite
            let favorite = FavoriteSpot(name: spot.name, spotID: spot.id, notes: nil)
            context.insert(favorite)
            try? context.save()
            isSaved = true
        }
    }
}
