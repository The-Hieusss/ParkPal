import Foundation
import SwiftData

@Model
class FavoriteSpot: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var spotID: String
    var notes: String?
    var address: String?
    
    init(id: UUID = UUID(), name: String, spotID: String, notes: String?, address: String?) {
            self.id = id
            self.name = name
            self.spotID = spotID
            self.notes = notes
            self.address = address
        }
}
