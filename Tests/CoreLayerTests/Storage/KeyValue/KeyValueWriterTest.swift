//
//  Created by Kurlovich Vitali on 10/9/26.
//

import CoreLayer
import Testing

@Suite("KeyValueWriter")
struct KeyValueWriterTest {
    @Test
    func write() async {
        let keyValue = MocKeyValue<Int, String>()
        #expect(await keyValue.storage.isEmpty)

        await keyValue.write(by: 1, value: "1")

        #expect(await keyValue.storage.count == 1)
        #expect(await keyValue.storage[1] == "1")

        await keyValue.remove(by: 1)

        #expect(await keyValue.storage.isEmpty)
    }

    @Test
    func writeThrows() async throws {
        let keyValue = MocThrowsKeyValue<Int, String>()
        #expect(await keyValue.storage.isEmpty)

        try await keyValue.write(by: 1, value: "1")

        #expect(await keyValue.storage.count == 1)
        #expect(await keyValue.storage[1] == "1")

        try await keyValue.remove(by: 1)

        #expect(await keyValue.storage.isEmpty)
    }

    @Test
    func writeToCacheWithError() async throws {
        let keyValue = MocThrowsKeyValue<Int, String>(error: .writeFailed)

        await #expect(throws: MocKeyValueError.writeFailed) {
            try await keyValue.write(by: 2, value: "2")
        }

        #expect(await keyValue.storage.isEmpty)
    }
}
