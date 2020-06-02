import PlexKit

// Client identifier is required for most endpoints.
let info = Plex.ClientInfo(clientIdentifier: UUID().uuidString)

let client = Plex(sessionConfiguration: .default, clientInfo: info)

client.request(
    // plex.tv endpoints are namespaced under `Plex.ServiceRequest`.
    Plex.ServiceRequest.SimpleAuthentication(
        username: "USER",
        password: "PASS"
    )
) { result in
    switch result {
    case .success(let response):
        print("Hello, \(response.user.title)!")
        print("Your authentication token is \(response.user.authenticationToken)")
    case .failure(let error):
        print("An error occurred: \(error)")
    }
}
