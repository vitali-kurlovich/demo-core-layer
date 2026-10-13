//
//  Created by Kurlovich Vitali on 10/13/26.
//

public struct MapValueStorageReader<Reader: ValueStorageReader, MapValue>: ValueStorageReader<MapValue, Reader.Failed> {
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
    public func readValue() async throws(Reader.Failed) -> MapValue? {
        if let value = try await reader.readValue() {
            return transform(value)
        }
        return nil
    }
}

public extension ValueStorageReader {
    @inlinable
    func map<MapValue>(_ transform: @escaping @Sendable (Self.Value) -> MapValue) -> some ValueStorageReader<MapValue, Self.Failed> & Sendable where Self: Sendable {
        MapValueStorageReader(reader: self, transform: transform)
    }
}

extension MapValueStorageReader: Sendable where Reader: Sendable {}
