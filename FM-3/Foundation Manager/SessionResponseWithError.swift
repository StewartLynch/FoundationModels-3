
 /*
  
  do {
      responseContent = try await session.respond(to: prompt).content
  } catch let error as LanguageModelSession.GenerationError {
      switch error {
      case .guardrailViolation(let context):
          responseContent = "Guardrail Violation: \(context.debugDescription)"
      case .decodingFailure(let context):
          responseContent = "Decoding Failure: \(context.debugDescription)"
      case .rateLimited(let context):
          responseContent = "Rate Limit exceeded: \(context.debugDescription)"
      default:
          responseContent = "Other error: \(error.localizedDescription)"
      }
      if let failureReason = error.failureReason {
          responseContent += "\n\(failureReason)"
      }
      if let recoverySuggestion = error.recoverySuggestion {
          responseContent += "\n\(recoverySuggestion)"
      }
  
  } catch {
      responseContent = error.localizedDescription
  }
  
  */

