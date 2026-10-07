# Architecture

## Components
- RokidService: normalized glasses transport.
- AssistantCoordinator: one interaction from request to answer.
- OpenAIService: OpenAI Responses API client.

## First end-to-end milestone
1. Connect RV101.
2. Receive a command/request.
3. Receive/capture a JPEG frame when requested.
4. Send prompt + optional image to OpenAI.
5. Parse output text.
6. Display/speak the answer through Rokid.

## Production security
Direct API calls from iOS are for local prototyping only. Production should use an authenticated backend that owns the OpenAI credential.
