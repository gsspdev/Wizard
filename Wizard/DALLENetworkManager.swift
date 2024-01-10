//    // DALLENetworkManager.swift
//    import Foundation
//
//    class DALLENetworkManager {
//        
//        static let shared = DALLENetworkManager()
//        
//        func generateImage(prompt: String, completion: @escaping (Data?) -> Void) {
//            let url = URL(string: "https://api.openai.com/v1/images/generations")!
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//            let body: [String: Any] = [
//                "prompt": prompt,
//                // Add additional parameters as needed
//            ]
//
//            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
//
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                guard let data = data, error == nil else {
//                    completion(nil)
//                    return
//                }
//
//                do {
//                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                       let dataArray = json["data"] as? [[String: Any]] {
//                        let imageUrls = dataArray.compactMap { $0["url"] as? String }
//                        DispatchQueue.main.async {
//                            completion(imageUrls).self
//                        }
//                    } else {
//                        DispatchQueue.main.async {
//                            completion([])
//                        }
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        completion([])
//                    }
//                }
//            }
//            
//            task.resume()
//        }
//    }


    // DALLENetworkManager.swift
    import Foundation

    class DALLENetworkManager {
        
        static let shared = DALLENetworkManager()
        
        func generateImage(prompt: String, completion: @escaping ([String]) -> Void) {
            let url = URL(string: "https://api.openai.com/v1/images/generations")!

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer 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", forHTTPHeaderField: "Authorization") // Securely replace with your actual API key
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: Any] = [
                "prompt": prompt
                // Add additional parameters as needed
            ]

            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                        completion([])
                    }
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let dataArray = json["data"] as? [[String: Any]] {
                        let imageUrls = dataArray.compactMap { $0["url"] as? String }
                        DispatchQueue.main.async {
                            completion(imageUrls)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion([])
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion([])
                    }
                }
            }
            task.resume()
        }
    }
