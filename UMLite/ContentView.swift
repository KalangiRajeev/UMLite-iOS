import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = DiagramViewModel()
    @ObservedObject private var imageSaver = ImageSaver()
    
    @State private var showWebView : Bool = false
    @State private var showConfirmation = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Group {
                    TextEditor(text: $viewModel.source)
                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                        .padding()
                    if viewModel.isLoading {
                        ProgressView("Rendering...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    }
                    HStack {
                        Button("Clear") {
                            viewModel.source = ""
                        }.buttonStyle(.bordered)
                            .padding()
                        Spacer()
                        Button("Submit") {
                            showWebView = true
                            viewModel.renderDiagram()
                        }.buttonStyle(.borderedProminent)
                            .padding()
                    }
                }
            }
            .navigationTitle("UMLite")
            .sheet(isPresented: $showWebView, onDismiss: {
                viewModel.diagramImage = nil
                viewModel.isLoading = false
            }) {
                if let image = viewModel.diagramImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                    Button {
                        imageSaver.writeToPhotoAlbum(image: image)
                    } label: {
                        Label("Download Image", systemImage: "square.and.arrow.down")
                    }.buttonStyle(.bordered)
                        .padding(.top, 8)
                    
                    if showConfirmation {
                        Text("✅ Saved to Photos")
                            .foregroundColor(.green)
                            .transition(.opacity)
                    }
                }
            }
        }.alert(imageSaver.alertTitle, isPresented: $imageSaver.showAlert) {
            Button("OK") { } // Default "OK" button to dismiss
        } message: {
            Text(imageSaver.alertMessage) // Display the message
        }
    }
}


#Preview {
    ContentView()
}
