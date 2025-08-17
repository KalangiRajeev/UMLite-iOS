import UIKit
import SwiftUI

class ImageSaver: NSObject, ObservableObject {
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""

    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // Set alert for failure
            alertTitle = "Save Error"
            alertMessage = error.localizedDescription
        } else {
            // Set alert for success
            alertTitle = "Saved Successfully!"
            alertMessage = "Your image has been saved to your photo library."
        }
        showAlert = true // Show the alert
    }
}
