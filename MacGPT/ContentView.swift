// ContentView.swift
import SwiftUI


struct ContentView: View {
    @State public var userInput: String = ""
    @State public var chatGPTResponse: String = "Your ChatGPT responses will appear here."

    var body: some View {
        VStack {

            HStack {
                TextField("Type your message here...", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Send") {
                    ChatGPTNetworkManager.shared.fetchChatGPTResponse(userInput: userInput) { response in
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


