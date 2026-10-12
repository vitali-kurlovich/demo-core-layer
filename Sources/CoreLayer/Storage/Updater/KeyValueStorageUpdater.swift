//
//  Created by Kurlovich Vitali on 10/11/26.
//

public nonisolated struct KeyValueStorageUpdater<Writer: KeyValueStorageWriter & Sendable> {
    private let writer: Writer
    private let handleError: @Sendable (Writer.Failed) -> Void
    private let transform: @Sendable (Writer.Value) -> Writer.Key

    public init(
        _ writer: Writer,
        handleError: @Sendable @escaping (Writer.Failed) -> Void,
        transform: @Sendable @escaping (Writer.Value) -> Writer.Key
    ) {
        self.writer = writer
        self.handleError = handleError
        self.transform = transform
    }
}

public extension KeyValueStorageUpdater {
    init(
        _ writer: Writer,
        transform: @Sendable @escaping (Writer.Value) -> Writer.Key
    ) where Writer.Failed == Never {
        self.init(writer, handleError: { _ in }, transform: transform)
    }
}

public extension KeyValueStorageUpdater {
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    func watch<Stream: AsyncSequence & Sendable>(_ stream: Stream) async throws(Stream.Failure)
        where
        Stream.Element == Writer.Value,
        Stream.AsyncIterator: SendableMetatype
    {
        for try await value in stream {
            do {
                try await writer.write(by: transform(value), value: value)
            } catch {
                handleError(error)
            }
        }
    }
}
