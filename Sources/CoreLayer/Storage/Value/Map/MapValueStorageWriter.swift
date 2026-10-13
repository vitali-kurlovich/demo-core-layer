//
//  Created by Kurlovich Vitali on 10/13/26.
//

public struct MapValueStorageWriter<Writer: ValueStorageWriter, MapValue> {
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

extension MapValueStorageWriter: ValueStorageWriter<MapValue, Writer.Failed> {
    @inlinable
    public func write(value: MapValue?) async throws(
        Writer.Failed
    ) {
        if let value {
            try await writer.write(value: transform(value))
        } else {
            try await writer.write(value: nil)
        }
    }
}

extension MapValueStorageWriter: Sendable where Writer: Sendable {}

public extension ValueStorageWriter {
    @inlinable
    func map<MapValue>(_: MapValue.Type, writeTransform: @escaping @Sendable (MapValue) -> Self.Value) -> some ValueStorageWriter<MapValue, Self.Failed> {
        MapValueStorageWriter(writer: self, transform: writeTransform)
    }
}
