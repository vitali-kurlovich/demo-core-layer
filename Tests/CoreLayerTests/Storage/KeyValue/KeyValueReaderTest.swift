//
//  Created by Kurlovich Vitali on 10/9/26.
//

import CoreLayer
import Testing

@Suite("KeyValueReader")
struct KeyValueReaderTest {
    @Test
    func read() async {
        var storage = MocKeyValue<Int, String>()
        #expect(await storage.storage.isEmpty)

        storage = MocKeyValue<Int, String>(storage: [1: "1"])

        #expect(await storage.readValue(by: 1) == "1")
        #expect(await storage.readValue(by: 2) == nil)
    }

    @Test
    func readThrows() async throws {
        let storage = MocThrowsKeyValue<Int, String>(
            storage: [1: "1"],
            error: nil
        )

        #expect(try await storage.readValue(by: 1) == "1")
        #expect(try await storage.readValue(by: 2) == nil)
    }

    @Test
    func readThrowsWithError() async throws {
        let storage = MocThrowsKeyValue<Int, String>(
            storage: [1: "1"],
            error: .readFailed
        )

        await #expect(throws: MocKeyValueError.readFailed) {
            try await storage.readValue(by: 1)
        }
    }
}
