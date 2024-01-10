import SwiftUI
import AppKit

struct ContentView: View {
    @State private var prompt: String = ""
    @State private var imageUrls: [String] = []
    @State private var nsImages: [NSImage] = []

    var body: some View {
        VStack {
            TextField("Enter your prompt here...", text: $prompt)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Generate Image") {
                DALLENetworkManager.shared.generateImage(prompt: prompt) { urls in
                    imageUrls = urls
                    downloadImages(from: urls)
                }
            }
            .padding()

            // Display images
            ForEach(nsImages, id: \.self) { nsImage in
                Image(nsImages as! CGImage, scale: 1.0, label: Text("Generated Image"))
                    .resizable()
                    .scaledToFit()
            }
        }
        .padding()
    }

    // Download images from URLs and update nsImages
    func downloadImages(from urls: [String]) {
        nsImages = urls.compactMap { url in
            guard let imageUrl = URL(string: url),
                  
                  let imageData = try? Data(contentsOf: imageUrl),
                  let nsImage = NSImage(data: imageData) else {
                return nil
            }
            return nsImage
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

