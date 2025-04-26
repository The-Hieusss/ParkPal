import SwiftUI

struct StarRatingDisplayView: View {
    let rating: Double
    let maxRating: Int = 5

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<maxRating, id: \.self) { index in
                let filled = Double(index) < rating
                let halfFilled = (rating - Double(index)) >= 0.5 && (rating - Double(index)) < 1

                Image(systemName: filled
                        ? (halfFilled ? "star.leadinghalf.filled" : "star.fill")
                        : "star")
                    .foregroundColor(filled ? .yellow : .gray)
            }
        }
    }
}
