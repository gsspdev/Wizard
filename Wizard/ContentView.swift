import SwiftUI
import AppKit

struct ContentView: View {
    @State public var prompt: String = ""
    @State public var imageUrls: [String] = []
    @State public var nsImages: [NSImage] = []
    
    var body: some View {
        VStack {
            TextField("Enter your prompt here...", text: $prompt)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Generate Image") {
                Task {
                    await downloadImages(from: imageUrls)
                }
            }
            .padding()
            
            HStack {
                    // Display images
                ForEach(nsImages, id: \.self) { nsImage in
                    Image(nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil)!, scale: 1.0, label: Text("Generated Image"))
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        .padding()
    }
    
    // Mark the function with @MainActor to ensure UI updates are performed on the main thread.
    @MainActor
    func downloadImages(from urls: [String]) async {
        var results = [NSImage]()
        
        await withTaskGroup(of: NSImage?.self) { group in
            for url in urls {
                group.addTask {
                    guard let imageUrl = URL(string: url) else { return nil }
                    do {
                        let (imageData, _) = try await URLSession.shared.data(from: imageUrl)
                        return NSImage(data: imageData)
                    } catch {
                        return nil
                    }
                }
            }
            
            // Collecting task results
            for await result in group {
                if let image = result {
                    results.append(image)
                }
            }
        }
        
        // Update the UI on the main thread with the fetched images.
        self.nsImages = results
    }
}
