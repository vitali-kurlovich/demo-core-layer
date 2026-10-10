//
//  Created by Kurlovich Vitali on 10/8/26.
//

public protocol KeyValueStorageReader<Key, Value, Failed> {
    associatedtype Key
    associatedtype Value
    associatedtype Failed: Error

    func readValue(by key: Key) async throws(Failed) -> Value?
}
