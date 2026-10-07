# Rokid Companion

Rokid Glasses ↔ iPhone ↔ ChatGPT companion.

## v0.1 goal
Voice/text requests from Rokid, optional camera input, OpenAI Responses API, and short answers returned to the glasses.

## Architecture
Rokid Glasses ↔ RokidService (iOS) ↔ AssistantCoordinator ↔ OpenAIService ↔ OpenAI Responses API

The Rokid SDK adapter is isolated because the exact CXR mobile integration package/signatures must be wired against the SDK available for the target RV101 firmware.

## Security
Never commit an OpenAI API key. Production should use an authenticated backend so the key is not shipped inside the iOS app.

## Roadmap
- v0.1 architecture + OpenAI text/vision client + mock Rokid transport
- v0.2 RV101 connection and command round-trip
- v0.3 glasses camera frame → vision request
- v0.4 voice + TTS/display
- v0.5 persistent conversational context
