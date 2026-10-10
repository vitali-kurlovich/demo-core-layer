//
//  Created by Kurlovich Vitali on 10/8/26.
//

public protocol KeyValueStorageWriter<Key, Value, Failed> {
    associatedtype Key
    associatedtype Value
    associatedtype Failed: Error

    func write(by key: Key, value: Value?) async throws(Failed)
}

public extension KeyValueStorageWriter {
    func remove(by key: Key) async throws(Failed) {
        try await write(by: key, value: nil)
    }
}
