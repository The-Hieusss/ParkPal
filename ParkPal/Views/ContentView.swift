import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MapView()
                .tabItem {
                    Label("Find Parking", systemImage: "map")
                }

//            ParkingListView(viewModel: ParkingListViewModel())
//                .tabItem {
//                    Label("Spots List", systemImage: "list.bullet")
//                }

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
        }
    }
}
#Preview {
    ContentView()
}
