import Foundation
import SwiftData

@Model
class UserPreference: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var lastSearchLocation: String?
    var preferredView: String // "map" or "list"
    
    init(id: UUID = UUID(), lastSearchLocation: String?, preferredView: String) {
            self.id = id
            self.lastSearchLocation = lastSearchLocation
            self.preferredView = preferredView
        }
}
