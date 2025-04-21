import Foundation

struct ParkingSpotDTO: Decodable {
    var id: String
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    var availableSpots: Int
    var totalSpots: Int
    var isCovered: Bool
    var hasSecurity: Bool
}
