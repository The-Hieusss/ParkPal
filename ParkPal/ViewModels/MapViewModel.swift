import Foundation
import MapKit
import CoreLocation

@MainActor
class MapViewModel: ObservableObject {
    @Published var parkingSpots: [ParkingSpot] = []
    @Published var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    // Full list of all mock spots (unfiltered)
    private var allSpots: [ParkingSpot] = [
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

    init() {
        parkingSpots = allSpots // Show all by default
    }

    func searchLocation(_ query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query

        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else {
                print("Location not found: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            DispatchQueue.main.async {
                self?.mapRegion.center = coordinate
                self?.filterSpots(near: coordinate)
            }
        }
    }

    private func filterSpots(near coordinate: CLLocationCoordinate2D, radius: Double = 1000) {
        let targetLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        parkingSpots = allSpots.filter { spot in
            let spotLocation = CLLocation(latitude: spot.latitude, longitude: spot.longitude)
            let distance = spotLocation.distance(from: targetLocation)
            return distance <= radius
        }
    }
}
