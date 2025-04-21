import FirebaseFirestore

class FirebaseManager {
    private let db = Firestore.firestore()

    // Save a new review
    func addReview(_ review: Review) {
        do {
            _ = try db.collection("reviews").addDocument(from: review)
        } catch {
            print("❌ Error saving review: \(error)")
        }
    }

    // Fetch reviews for a specific parking spot
    func fetchReviews(for spotID: String, completion: @escaping ([Review]) -> Void) {
        db.collection("reviews")
            .whereField("spotID", isEqualTo: spotID)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let docs = snapshot?.documents else {
                    print("❌ Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                    completion([])
                    return
                }

                let reviews = docs.compactMap { try? $0.data(as: Review.self) }
                completion(reviews)
            }
    }
}
