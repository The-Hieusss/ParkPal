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

    private let webService = WebService()
    private var allSpots: [ParkingSpot] = []

    func searchLocation(_ query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query

        MKLocalSearch(request: request).start { [weak self] response, _ in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else {
                print("📍 Location not found")
                return
            }

            Task { @MainActor in
                self?.mapRegion.center = coordinate
                self?.fetchAndFilter(for: coordinate)
            }
        }
    }

    func fetchAndFilter(for coordinate: CLLocationCoordinate2D) {
        webService.fetchAllSpots { [weak self] spots in
            guard let self = self else { return }

            self.allSpots = spots

            let targetLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

            self.parkingSpots = spots.filter { spot in
                let spotLocation = CLLocation(latitude: spot.latitude, longitude: spot.longitude)
                return spotLocation.distance(from: targetLocation) <= 10000 // 1 km radius
            }
        }
    }
}
