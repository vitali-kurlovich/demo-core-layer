//
//  Created by Kurlovich Vitali on 10/12/26.
//

enum MocAsyncStreamError: Error {
    case streamError
}

struct MocAsyncStream<Value: Sendable, Failure: Error & Sendable> {
    let storage: [Value]
    let period: Duration

    init(
        _ storage: [Value],
        period: Duration = .milliseconds(1)

    ) {
        self.storage = storage
        self.period = period
    }
}

extension MocAsyncStream where Failure == Never {
    var values: AsyncStream<Value> {
        .init(bufferingPolicy: .bufferingNewest(0)) { continuation in
            let task = Task {

                for value in storage {
                    try? await Task.sleep(for: period)
                    continuation.yield(value)
                }
                continuation.finish()
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}

extension MocAsyncStream {
    func values(_ throwForValue: @Sendable @escaping (Value) throws -> Void) -> AsyncThrowingStream<Value, any Error> {
        AsyncThrowingStream<Value, any Error>(
            bufferingPolicy: .bufferingNewest(0)
        ) { continuation in
            let task = Task {

                for value in storage {
                    do {
                        try throwForValue(value)
                    } catch {
                        continuation.finish(throwing: error)
                    }

                    try? await Task.sleep(for: period)

                    continuation.yield(value)
                }
                continuation.finish()
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}
