import Foundation

protocol RokidService: AnyObject {
    var onUserRequest: ((RokidRequest) -> Void)? { get set }
    func connect() async throws
    func disconnect()
    func send(answer: String) async throws
}

struct RokidRequest: Sendable {
    let text: String
    let jpegImageData: Data?
}

final class MockRokidService: RokidService {
    var onUserRequest: ((RokidRequest) -> Void)?
    func connect() async throws {}
    func disconnect() {}
    func send(answer: String) async throws { print("ROKID ← \(answer)") }
}
