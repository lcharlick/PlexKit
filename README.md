
# PlexKit

PlexKit provides asynchronous, type-safe access to a small portion of the Plex API.

## Installation

### Swift Package Manager

Create a `Package.swift` file.

```swift
import PackageDescription

let package = Package(
    name: "SampleProject",
    dependencies: [
        .Package(url: "https://github.com/lcharlick/PlexKit.git" from: "1.0.0")
    ]
)
```

### [CocoaPods](https://cocoapods.org/)
````ruby
pod 'PlexKit'
````

## Requirements

- iOS 10.0+
- macOS 10.12+
- tvOS 10.0+

## Getting Started

### Authentication

Before accessing any resources, we need an authentication token:

````swift
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

````

### Finding a server

Once we have a token, we can hit every plex.tv endpoint, or access a server instance. To find a server (or "resource"), we can ask plex.tv:

````swift
client.request(
    Plex.ServiceRequest.Resources(),
    token: token
) { result in
    switch result {
    case .success(let response):
        print("Found \(response.count) resources")
        let servers = response.filter { $0.capabilities.contains(.server)}
        print("\(servers.count) of which are servers.")
    case .failure(let error):
        print("An error occurred: \(error)")
    }
}
````

### Accessing libraries

````swift
client.request(
    // Resource-related requests are namespaced under `Plex.Request`.
    Plex.Request.Libraries(),
    from: url,
    token: token
) { result in
    switch result {
    case .success(let response):
        let libraries = response.mediaContainer.directory
        print("Found \(libraries.count) libraries")
        let musicLibraries = libraries.filter { $0.type == .artist }
        print("\(musicLibraries.count) are music libraries")
    case .failure(let error):
        print("An error occurred: \(error)")
    }
}
````

## Notes

- Check the `Plex.Request` and `Plex.ServiceRequest` namespaces for available endpoints.

- PlexKit models map directly to data returned by Plex API. Where possible I've cleaned these up for Swift, though more work can be done here.

- As it was originally written for [Prism](https://prism-music.app) and [Prologue](https://prologue-app.com), PlexKit mainly concentrates on the audio component of Plex, though other media types work, too.

## License

PlexKit is available under the MIT license. See the LICENSE file for more info.
