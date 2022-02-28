//: [Previous](@previous)

import PlexKit

let token = "my_token"
let url = URL(string: "http://my_server")!

let info = Plex.ClientInfo(
    clientIdentifier: UUID().uuidString
)
let client = Plex(sessionConfiguration: .default, clientInfo: info)

client.request(
    // Resource-related requests are namespaced under `Plex.Request`.
    Plex.Request.Libraries(),
    from: url,
    token: token
) { result in
    switch result {
    case let .success(response):
        let libraries = response.mediaContainer.directory
        print("Found \(libraries.count) libraries")
        let musicLibraries = libraries.filter { $0.type == .artist }
        print("\(musicLibraries.count) are music libraries")
    case let .failure(error):
        print("An error occurred: \(error)")
    }
}

//: [Next](@next)
