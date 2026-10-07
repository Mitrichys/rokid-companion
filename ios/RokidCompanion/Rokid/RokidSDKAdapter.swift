import Foundation

/// Boundary for the official Rokid mobile SDK.
/// Wire image/audio/display/command callbacks here once the RV101 iOS SDK package is added.
final class RokidSDKAdapter: RokidService {
    var onUserRequest: ((RokidRequest) -> Void)?
    func connect() async throws { throw RokidAdapterError.sdkNotIntegrated }
    func disconnect() {}
    func send(answer: String) async throws { throw RokidAdapterError.sdkNotIntegrated }
}

enum RokidAdapterError: Error { case sdkNotIntegrated }
