//
//  Created by Kurlovich Vitali on 10/9/26.
//

public struct MapKeyValueStorageReader<Reader: KeyValueStorageReader, MapValue>: KeyValueStorageReader<Reader.Key, MapValue, Reader.Failed> {
    public typealias Transform = @Sendable (Reader.Value) -> MapValue

    @usableFromInline
    let reader: Reader

    @usableFromInline
    let transform: Transform

    @inlinable
    public init(reader: Reader, transform: @escaping @Sendable (Reader.Value) -> MapValue) {
        self.reader = reader
        self.transform = transform
    }

    @inlinable
    public func readValue(by key: Reader.Key) async throws(Reader.Failed) -> MapValue? {
        if let value = try await reader.readValue(by: key) {
            return transform(value)
        }
        return nil
    }
}

public extension KeyValueStorageReader {
    @inlinable
    func map<MapValue>(_ transform: @escaping @Sendable (Self.Value) -> MapValue) -> some KeyValueStorageReader<Self.Key, MapValue, Self.Failed> {
        MapKeyValueStorageReader(reader: self, transform: transform)
    }
}

extension MapKeyValueStorageReader: Sendable where Reader: Sendable {}
