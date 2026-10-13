//
//  Created by Kurlovich Vitali on 10/13/26.
//

public protocol ValueStorageWriter<Value, Failed> {
    associatedtype Value
    associatedtype Failed: Error

    func write(value: Value?) async throws(Failed)
}

public extension ValueStorageWriter {
    func remove() async throws(Failed) {
        try await write(value: nil)
    }
}
