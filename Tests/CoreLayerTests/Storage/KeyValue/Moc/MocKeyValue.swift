//
//  Created by Kurlovich Vitali on 10/9/26.
//

import CoreLayer

enum MocKeyValueError: Error {
    case writeFailed
    case readFailed
}

actor MocKeyValue<Key: Hashable & Sendable, Value: Sendable> {
    var error: MocKeyValueError?
    var storage: [Key: Value] = [:]
    init(
        storage: [Key: Value] = [:],
        error: MocKeyValueError? = nil
    ) {
        self.storage = storage
        self.error = error
    }
}

extension MocKeyValue: KeyValueStorageReader<Key, Value, MocKeyValueError> {
    func readValue(by key: Key) async throws(Failed) -> Value? {
        if let error, error == .readFailed {
            throw error
        }

        return storage[key]
    }
}

extension MocKeyValue: KeyValueStorageWriter<Key, Value, MocKeyValueError> {
    func write(by key: Key, value: Value?) async throws(MocKeyValueError) {
        if let error, error == .writeFailed {
            throw error
        }
        storage[key] = value
    }
}
