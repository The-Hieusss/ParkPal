import SwiftUI
import SwiftData
import  MapKit
struct ParkingCardView: View {
    let spot: ParkingSpot

    @Environment(\.modelContext) private var context
    @Query private var favorites: [FavoriteSpot] 

    @State private var isSaved = false
    @State private var showReviewSheet = false
    @State private var localAvailableSpots: Int
    @State private var showReserveToast = false
    @StateObject private var reviewViewModel = ReviewViewModel()



    init(spot: ParkingSpot) {
           self.spot = spot
           _localAvailableSpots = State(initialValue: spot.availableSpots) 
       }
    
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .overlay(Image(systemName: "car.fill").foregroundColor(.blue))

                VStack(alignment: .leading, spacing: 4) {
                    Text(spot.name).font(.headline)
                    Text("Available: \(localAvailableSpots)/\(spot.totalSpots)")
                    Text(spot.address).font(.subheadline).foregroundColor(.gray)
                    HStack(spacing: 4) {
                            StarRatingDisplayView(rating: averageRating)
                            Text(String(format: "%.1f", averageRating))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
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
                    reserveSpot()
                        } label: {
                            Text(localAvailableSpots > 0 ? "Reserve Spot" : "No Spots Available")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(localAvailableSpots > 0 ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(localAvailableSpots == 0)
            
            Button {
                getDirections()
            } label: {
                HStack {
                    Image(systemName: "map")
                    Text("Get Directions")
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            .padding(.top, 4)
            
            
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
        .overlay(
            Group {
                if showReserveToast {
                    Text("✅ Spot Reserved!")
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.bottom, 30)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut, value: showReserveToast)
                }
            },
            alignment: .bottom
        )
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 4)
        .onAppear {
            checkIfSaved()
            reviewViewModel.loadReviews(for: spot.id)
        }
    }

    private func checkIfSaved() {
        isSaved = favorites.contains(where: { $0.spotID == spot.id })
    }

    private func reserveSpot() {
            if localAvailableSpots > 0 {
                localAvailableSpots -= 1
                showReserveToast = true
                       
                       // Hide toast after 2 seconds
                       DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                           showReserveToast = false
                       }
            }
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
            let favorite = FavoriteSpot(name: spot.name, spotID: spot.id, notes: nil, address: spot.address)
            context.insert(favorite)
            try? context.save()
            isSaved = true
        }
    }
    
    private var averageRating: Double {
        guard !reviewViewModel.reviews.isEmpty else { return 0.0 }
        let total = reviewViewModel.reviews.reduce(0) { $0 + $1.rating }
        return Double(total) / Double(reviewViewModel.reviews.count)
    }

    private func getDirections() {
        let coordinate = CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = spot.name
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }

}
