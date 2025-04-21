import Foundation

@MainActor
class ReviewViewModel: ObservableObject {
    @Published var reviews: [Review] = []

    private let firebase = FirebaseManager()

    func loadReviews(for spotID: String) {
        firebase.fetchReviews(for: spotID) { [weak self] fetched in
            Task { @MainActor in
                self?.reviews = fetched
            }
        }
    }

    func addReview(for spotID: String, author: String, rating: Int, comment: String) {
        let newReview = Review(
            spotID: spotID,
            author: author,
            rating: rating,
            comment: comment,
            createdAt: Date()
        )
        firebase.addReview(newReview)
    }
}
