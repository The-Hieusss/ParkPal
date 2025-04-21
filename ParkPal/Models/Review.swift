import Foundation
import FirebaseFirestore

struct Review: Codable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    var spotID: String
    var author: String
    var rating: Int
    var comment: String
    var createdAt: Date
}
