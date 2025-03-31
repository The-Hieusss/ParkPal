import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var searchQuery = ""

    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            HStack {
                TextField("Search for location...", text: $searchQuery)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                Button(action: {
                    viewModel.searchLocation(searchQuery)
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                }
            }
            .padding()

            // Map + Floating List
            ZStack(alignment: .bottom) {
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.parkingSpots) { spot in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude)) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                    }
                }

                // Floating Card List
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(viewModel.parkingSpots, id: \.id) { spot in
                            ParkingCardView(spot: spot)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
                .frame(maxHeight: 300) // or whatever height you want
            }
        }
    }
}
