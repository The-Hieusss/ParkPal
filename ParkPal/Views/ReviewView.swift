import SwiftUI

struct ReviewView: View {
    @StateObject var viewModel = ReviewViewModel()
    @State private var comment: String = ""
    @State private var rating: Int = 5
    let spot: ParkingSpot

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Reviews for \(spot.name)").font(.title2).bold()

            // Review Form
            VStack(alignment: .leading) {
                Text("Write a Review").font(.headline)
                Stepper("Rating: \(rating)", value: $rating, in: 1...5)
                TextField("Comment...", text: $comment)
                    .textFieldStyle(.roundedBorder)
                Button("Submit") {
                    viewModel.addReview(for: spot.id, author: "Guest", rating: rating, comment: comment)
                    comment = ""
                    rating = 5
                }
                .disabled(comment.isEmpty)
                .buttonStyle(.borderedProminent)
            }

            Divider()

            // List of reviews
            if viewModel.reviews.isEmpty {
                Text("No reviews yet.").italic().padding()
            } else {
                List {
                    ForEach(viewModel.reviews) { review in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(review.author).bold()
                                Spacer()
                                Text("⭐️ \(review.rating)")
                            }
                            Text(review.comment)
                            Text(review.createdAt, style: .date)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                    }
                   
                }
                .listStyle(.inset)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.loadReviews(for: spot.id)
        }
    }

   
}
