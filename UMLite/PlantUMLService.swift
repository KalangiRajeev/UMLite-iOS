import Foundation

class PlantUMLService {
    func fetchDiagramImage(from source: String) async throws -> Data {
        guard let encoded = PlantUMLEncoder.encode(source),
              let url = URL(string: "https://www.plantuml.com/plantuml/png/\(encoded)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return data
    }
}
