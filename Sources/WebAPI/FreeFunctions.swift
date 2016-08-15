import Foundation
import Common

/**
 Builds a complete url to a webapi endpoint
 
 NOTE: will fatalError if a complete/valid `URL` can't be built
 
 - parameter pathSegments: `String` path segments
 - returns: A complete `URL`
 */
public func WebAPIURL(_ pathSegments: String...) -> URL {
    let urlString = "https://slack.com/api/" + pathSegments.joined(separator: "/")
    guard let url = URL(string: urlString) else { fatalError("Invalid URL: \(urlString)") }
    return url
}
