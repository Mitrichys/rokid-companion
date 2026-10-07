import Foundation

struct OpenAIService {
    let apiKey: String
    var model = "gpt-5.6-luna"

    func ask(text: String, jpegImageData: Data? = nil) async throws -> String {
        var content: [[String: Any]] = [["type": "input_text", "text": text]]
        if let jpegImageData {
            content.append(["type": "input_image", "image_url": "data:image/jpeg;base64,\(jpegImageData.base64EncodedString())"])
        }
        let body: [String: Any] = [
            "model": model,
            "instructions": "You are a concise assistant for smart glasses. Reply in the user's language. Prefer short, glanceable answers.",
            "input": [["role": "user", "content": content]]
        ]
        var request = URLRequest(url: URL(string: "https://api.openai.com/v1/responses")!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else { throw OpenAIError.requestFailed }
        let decoded = try JSONDecoder().decode(ResponseEnvelope.self, from: data)
        guard let result = decoded.output.flatMap({ $0.content ?? [] }).first(where: { $0.type == "output_text" })?.text else { throw OpenAIError.missingOutput }
        return result
    }
}

private struct ResponseEnvelope: Decodable { let output: [OutputItem] }
private struct OutputItem: Decodable { let content: [OutputContent]? }
private struct OutputContent: Decodable { let type: String; let text: String? }
enum OpenAIError: Error { case requestFailed, missingOutput }
