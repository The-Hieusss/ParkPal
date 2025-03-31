import Foundation

@MainActor
class ParkingListViewModel: ObservableObject {
    @Published var filteredSpots: [ParkingSpot] = []

    init() {
        // Match mock data with MapViewModel
        filteredSpots = [
            ParkingSpot(
                id: UUID().uuidString,
                name: "Mock Garage A",
                address: "123 Mock St",
                latitude: 37.7749,
                longitude: -122.4194,
                availableSpots: 12,
                totalSpots: 30,
                isCovered: true,
                hasSecurity: false
            ),
            ParkingSpot(
                id: UUID().uuidString,
                name: "Mock Lot B",
                address: "456 Test Ave",
                latitude: 37.7755,
                longitude: -122.4170,
                availableSpots: 5,
                totalSpots: 20,
                isCovered: false,
                hasSecurity: true
            )
        ]
    }
}
