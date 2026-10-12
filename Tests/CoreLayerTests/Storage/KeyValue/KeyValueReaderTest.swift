//
//  Created by Kurlovich Vitali on 10/9/26.
//

import CoreLayer
import Testing

@Suite("KeyValueReader")
struct KeyValueReaderTest {
    @Test
    func read() async {
        let keyValue = MocKeyValue<Int, String>()
        #expect(await keyValue.storage.isEmpty)

        await keyValue.write(by: 1, value: "1")

        #expect(await keyValue.readValue(by: 1) == "1")
        #expect(await keyValue.readValue(by: 2) == nil)
    }

    @Test
    func readThrows() async throws {
        let keyValue = MocThrowsKeyValue<Int, String>()
        #expect(await keyValue.storage.isEmpty)

        try await keyValue.write(by: 1, value: "1")

        #expect(try await keyValue.readValue(by: 1) == "1")
        #expect(try await keyValue.readValue(by: 2) == nil)
    }

    @Test
    func readThrowsWithError() async throws {
        let keyValue = MocThrowsKeyValue<Int, String>(error: .readFailed)

        await #expect(throws: MocKeyValueError.readFailed) {
            try await keyValue.readValue(by: 1)
        }
    }
}
