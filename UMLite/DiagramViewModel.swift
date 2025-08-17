import SwiftUI

@MainActor
class DiagramViewModel: ObservableObject {
    @Published var source: String = "@startuml\nAlice -> Bob: Hello\n@enduml"
    @Published var diagramImage: UIImage?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let service = PlantUMLService()

    func renderDiagram() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let imageData = try await service.fetchDiagramImage(from: source)
                if let image = UIImage(data: imageData) {
                    diagramImage = image
                } else {
                    errorMessage = "Failed to decode image"
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
