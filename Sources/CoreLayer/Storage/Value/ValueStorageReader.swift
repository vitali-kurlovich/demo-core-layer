//
//  Created by Kurlovich Vitali on 10/13/26.
//

public protocol ValueStorageReader<Value, Failed> {
    associatedtype Value
    associatedtype Failed: Error

    func readValue() async throws(Failed) -> Value?
}
