// ChatGPTNetworkManager.swift
import Foundation

class ChatGPTNetworkManager {
    
    static let shared = ChatGPTNetworkManager() // Singleton instance
    
    func fetchChatGPTResponse(userInput: String, completion: @escaping (String) -> Void) {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        request.httpMethod = "POST"
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization") // Securely replace with your actual API key
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": "gpt-3.5-turbo-0613", // gpt-3.5-turbo is newer (prolly cheaper)
            "messages": [
                ["role": "user", "content": userInput]
            ],
            "temperature": 0.7
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion("Error: \(error.localizedDescription)")
                }
                return
            }

            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let choices = json["choices"] as? [[String: Any]],
                       let firstChoice = choices.first,
                       let message = firstChoice["message"] as? [String: Any],
                       let content = message["content"] as? String {
                        DispatchQueue.main.async {
                            completion(content)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion("Unexpected data structure from API.")
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion("Decoding error: \(error.localizedDescription)")
                    }
                }
            }
        }
        task.resume()
    }
}
