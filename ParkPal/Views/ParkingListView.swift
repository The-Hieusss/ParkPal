import SwiftUI

struct ParkingListView: View {
    @ObservedObject var viewModel: ParkingListViewModel

    var body: some View {
        List(viewModel.filteredSpots) { spot in
            VStack(alignment: .leading) {
                Text(spot.name).font(.headline)
                Text("Available: \(spot.availableSpots)/\(spot.totalSpots)")
                Text(spot.address).font(.subheadline)
            }
        }
    }
}
