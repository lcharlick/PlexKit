//: [Previous](@previous)

import PlexKit

let token = "my_token"

let info = Plex.ClientInfo(
    clientIdentifier: UUID().uuidString
    // Either initialize `Plex` instances with a token value to authenticate
    // the entire session...
    // , token: token
)
let client = Plex(sessionConfiguration: .default, clientInfo: info)

client.request(
    Plex.ServiceRequest.Resources(),
    // ...or pass it manually per request.
    token: token
) { result in
    switch result {
    case let .success(response):
        print("Found \(response.count) resources")
        let servers = response.filter { $0.capabilities.contains(.server) }
        print("\(servers.count) of which are servers.")
    case let .failure(error):
        print("An error occurred: \(error)")
    }
}

//: [Next](@next)
