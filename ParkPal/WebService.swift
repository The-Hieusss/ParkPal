import Foundation
import CoreLocation

class WebService {
    func fetchAllSpots(completion: @escaping ([ParkingSpot]) -> Void) {
        guard let url = URL(string: "https://api.mocki.io/v2/tyfcnuah") else {
            print("Invalid URL")
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("API error: \(error)")
                completion([])
                return
            }

            guard let data = data else {
                print("No data returned")
                completion([])
                return
            }

            do {
                let decodedDTOs = try JSONDecoder().decode([ParkingSpotDTO].self, from: data)
                let converted = decodedDTOs.map { ParkingSpot(from: $0) }
                DispatchQueue.main.async {
                    completion(converted)
                }
            } catch {
                print("JSON decoding failed: \(error)")
                completion([])
            }
        }.resume()
    }
}
