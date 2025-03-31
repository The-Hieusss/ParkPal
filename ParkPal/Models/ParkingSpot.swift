import Foundation
import SwiftData

@Model
class ParkingSpot: Identifiable {
    @Attribute(.unique) var id: String
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    var availableSpots: Int
    var totalSpots: Int
    var isCovered: Bool
    var hasSecurity: Bool
    
    init(id: String, name: String, address: String, latitude: Double, longitude: Double, availableSpots: Int, totalSpots: Int, isCovered: Bool, hasSecurity: Bool) {
           self.id = id
           self.name = name
           self.address = address
           self.latitude = latitude
           self.longitude = longitude
           self.availableSpots = availableSpots
           self.totalSpots = totalSpots
           self.isCovered = isCovered
           self.hasSecurity = hasSecurity
       }
    
}
