//
//  Created by Kurlovich Vitali on 10/13/26.
//

import CoreLayer

enum MocValueError: Error {
    case writeFailed
    case readFailed
}

actor MocThrowsValue<Value: Sendable> {
    var error: MocValueError?
    var storage: Value?
    init(
        storage: Value? = nil,
        error: MocValueError? = nil
    ) {
        self.storage = storage
        self.error = error
    }
}

extension MocThrowsValue: ValueStorageReader<Value, MocValueError> {
    func readValue() async throws(Failed) -> Value? {
        if let error, error == .readFailed {
            throw error
        }

        return storage
    }
}

extension MocThrowsValue: ValueStorageWriter<Value, MocValueError> {
    func write(value: Value?) async throws(MocValueError) {
        if let error, error == .writeFailed {
            throw error
        }
        storage = value
    }
}
