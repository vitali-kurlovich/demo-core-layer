//
//  Created by Kurlovich Vitali on 10/9/26.
//

public struct MapKeyValueStorageWriter<Writer: KeyValueStorageWriter, MapValue> {
    public typealias Transform = @Sendable (MapValue) -> Writer.Value?

    @usableFromInline
    let writer: Writer
    @usableFromInline
    let transform: Transform

    @inlinable
    public init(writer: Writer, transform: @escaping Transform) {
        self.writer = writer
        self.transform = transform
    }
}

extension MapKeyValueStorageWriter: KeyValueStorageWriter<Writer.Key, MapValue, Writer.Failed> {
    @inlinable
    public func write(by key: Writer.Key, value: MapValue?) async throws(
        Writer.Failed
    ) {
        if let value {
            try await writer.write(by: key, value: transform(value))
        } else {
            try await writer.write(by: key, value: nil)
        }
    }
}

public extension KeyValueStorageWriter {
    @inlinable
    func map<MapValue>(_: MapValue.Type, writeTransform: @escaping @Sendable (MapValue) -> Self.Value) -> some KeyValueStorageWriter<Self.Key, MapValue, Self.Failed> & Sendable where Self: Sendable {
        MapKeyValueStorageWriter(writer: self, transform: writeTransform)
    }
}

extension MapKeyValueStorageWriter: Sendable where Writer: Sendable {}
