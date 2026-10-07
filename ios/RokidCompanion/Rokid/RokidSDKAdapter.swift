import Foundation
import RokidSDK

/// RV101 transport backed by the official Rokid iOS Mobile SDK.
/// Credentials are supplied from a local, git-ignored RokidCredentials.swift.
final class RokidSDKAdapter: NSObject, RokidService {
    var onUserRequest: ((RokidRequest) -> Void)?

    private var activeDevice: RKDevice?
    private var continuation: CheckedContinuation<Void, Error>?

    override init() {
        super.init()
        RokidMobileSDK.binder.addObserver(observer: self)
    }

    func connect() async throws {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            RokidMobileSDK.shared.initSDK(
                appKey: RokidCredentials.appKey,
                appSecret: RokidCredentials.appSecret,
                accessKey: RokidCredentials.accessKey
            ) { [weak self] error in
                guard let self else { return }
                if let error {
                    self.finishConnection(.failure(RokidAdapterError.sdkInitialization(String(describing: error))))
                    return
                }
                self.loadPairedDevices()
            }
        }
    }

    private func loadPairedDevices() {
        RokidMobileSDK.device.queryDeviceList { [weak self] _, devices in
            guard let self else { return }
            guard let device = devices?.first else {
                self.finishConnection(.failure(RokidAdapterError.noPairedDevice))
                return
            }
            self.activeDevice = device
            self.finishConnection(.success(()))
        }
    }

    private func finishConnection(_ result: Result<Void, Error>) {
        guard let continuation else { return }
        self.continuation = nil
        switch result {
        case .success: continuation.resume()
        case .failure(let error): continuation.resume(throwing: error)
        }
    }

    func disconnect() {
        activeDevice = nil
    }

    func send(answer: String) async throws {
        guard let device = activeDevice else { throw RokidAdapterError.notConnected }
        RokidMobileSDK.vui.sendMessage(topic: "message", text: answer, to: device)
    }
}

extension RokidSDKAdapter: SDKBinderObserver {
    func onAsrResult(_ asr: String, device: RKDevice) {
        let text = asr.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        onUserRequest?(RokidRequest(text: text, jpegImageData: nil))
    }
}

enum RokidAdapterError: Error {
    case sdkInitialization(String)
    case noPairedDevice
    case notConnected
}
