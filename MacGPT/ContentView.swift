import SwiftUI
import Foundation

func fetchChatGPTResponse(userInput: String, completion: @escaping (String) -> Void) {
    let url = URL(string: "https://api.openai.com/v1/chat/completions")!

    var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.addValue("Bearer API_KEY_GOES_HERE", forHTTPHeaderField: "Authorization") // Replace with your actual API key securely
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    // Corrected JSON body structure
    let body: [String: Any] = [
        "model": "gpt-3.5-turbo",
        "messages": [
            ["role": "user", "content": userInput]
        ],
        "temperature": 0.7
    ]

    // Convert body dictionary into JSON data
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion("Error: \(error.localizedDescription)")
            return
        }

        if let data = data {
            do {
                // Correctly parse the JSON response structure
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]], // 'choices' instead of 'messages'
                   let firstChoice = choices.first, // Extract the first choice
                   let message = firstChoice["message"] as? [String: Any], // Extract the message object
                   let content = message["content"] as? String { // Extract the content from the message
                    DispatchQueue.main.async {
                        completion(content)
                    }
                } else {
                    completion("Unexpected data structure from API.")
                }
            } catch {
                completion("Decoding error: \(error.localizedDescription)")
            }
        }
    }

    task.resume()
}

struct ContentView: View {
    @State public var userInput: String = ""
    @State public var chatGPTResponse: String = "Your ChatGPT responses will appear here."

    var body: some View {
        VStack {
            Text("ChatGPT Wrapper").font(.largeTitle)

            HStack {
                TextField("Type your message here...", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Send") {
                    fetchChatGPTResponse(userInput: userInput) { response in
                        chatGPTResponse = response
                    }
                }
                .padding()
            }

            ScrollView {
                Text(chatGPTResponse).padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .border(Color.gray, width: 1)
            .padding()
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
