//
//  Created by Kurlovich Vitali on 10/9/26.
//

public struct MapKeyValueStorageReaderWriter<Key, Reader: KeyValueStorageReader, Writer: KeyValueStorageWriter, MapValue, Failed: Error>
    where Reader.Key == Key, Writer.Key == Key,
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

extension MapKeyValueStorageReaderWriter: Sendable where Reader: Sendable, Writer: Sendable {}

extension MapKeyValueStorageReaderWriter: KeyValueStorageReader<Key, MapValue, Failed> {
    @inlinable
    public func readValue(by key: Key) async throws(Failed) -> MapValue? {
        if let value = try await reader.readValue(by: key) {
            return readTransform(value)
        }
        return nil
    }
}

extension MapKeyValueStorageReaderWriter: KeyValueStorageWriter<Key, MapValue, Failed> {
    @inlinable
    public func write(by key: Key, value: MapValue?) async throws(Failed) {
        if let value {
            try await writer.write(by: key, value: writeTransform(value))
        } else {
            try await writer.write(by: key, value: nil)
        }
    }
}

public extension KeyValueStorageReader where Self: KeyValueStorageWriter {
    @inlinable
    func map<MapValue>(_ readTransform: @escaping @Sendable (Value) -> MapValue,
                       write writeTransform: @escaping @Sendable (MapValue) -> Value?) ->

        some KeyValueStorageReader<Self.Key, MapValue, Self.Failed> & KeyValueStorageWriter<Self.Key, MapValue, Self.Failed>
    {
        MapKeyValueStorageReaderWriter(self, self, readTransform: readTransform, writeTransform: writeTransform)
    }
}
