import Foundation

@MainActor
final class AssistantCoordinator {
    private let rokid: RokidService
    private let openAI: OpenAIService

    init(rokid: RokidService, openAI: OpenAIService) {
        self.rokid = rokid
        self.openAI = openAI
        self.rokid.onUserRequest = { [weak self] request in
            Task { @MainActor in await self?.handle(request) }
        }
    }

    func start() async throws { try await rokid.connect() }

    private func handle(_ request: RokidRequest) async {
        do {
            let answer = try await openAI.ask(text: request.text, jpegImageData: request.jpegImageData)
            try await rokid.send(answer: answer)
        } catch {
            try? await rokid.send(answer: "Не удалось получить ответ. Попробуйте ещё раз.")
        }
    }
}
