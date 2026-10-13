//
//  Created by Kurlovich Vitali on 10/13/26.
//

public struct MapValueStorageReaderWriter<Reader: ValueStorageReader, Writer: ValueStorageWriter, MapValue, Failed: Error>
    where
    Reader.Failed == Failed, Writer.Failed == Failed
{
    public typealias ReadTransform = @Sendable (Reader.Value) -> MapValue
    public typealias WriteTransform = @Sendable (MapValue) -> Writer.Value?

    @usableFromInline
    let reader: Reader

    @usableFromInline
    let readTransform: ReadTransform

    @usableFromInline
    let writer: Writer

    @usableFromInline
    let writeTransform: WriteTransform

    @inlinable
    public init(
        _ reader: Reader,
        _ writer: Writer,
        readTransform: @escaping ReadTransform,
        writeTransform: @escaping WriteTransform
    ) {
        self.reader = reader
        self.readTransform = readTransform
        self.writer = writer
        self.writeTransform = writeTransform
    }
}

extension MapValueStorageReaderWriter: Sendable where Reader: Sendable, Writer: Sendable {}

extension MapValueStorageReaderWriter: ValueStorageReader<MapValue, Failed> {
    @inlinable
    public func readValue() async throws(Failed) -> MapValue? {
        if let value = try await reader.readValue() {
            return readTransform(value)
        }
        return nil
    }
}

extension MapValueStorageReaderWriter: ValueStorageWriter<MapValue, Failed> {
    @inlinable
    public func write(value: MapValue?) async throws(Failed) {
        if let value {
            try await writer.write(value: writeTransform(value))
        } else {
            try await writer.write(value: nil)
        }
    }
}

public extension ValueStorageReader where Self: ValueStorageWriter {
    @inlinable
    func map<MapValue>(_ readTransform: @escaping @Sendable (Value) -> MapValue,
                       write writeTransform: @escaping @Sendable (MapValue) -> Value?) ->

        some ValueStorageReader<MapValue, Self.Failed> & ValueStorageWriter<MapValue, Self.Failed> & Sendable where Self: Sendable
    {
        MapValueStorageReaderWriter(self, self, readTransform: readTransform, writeTransform: writeTransform)
    }
}
