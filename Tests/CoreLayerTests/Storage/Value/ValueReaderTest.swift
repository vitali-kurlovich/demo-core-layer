//
//  ValueReaderTest.swift
//  demo-core-layer
//
//  Created by Kurlovich Vitali on 10/13/26.
//

import CoreLayer
import Testing

@Suite("ValueReader")
struct ValueReaderTest {
    @Test
    func read() async {
        var storage = MocValue<String>()
        #expect(await storage.readValue() == nil)
        storage = MocValue<String>(storage: "1")
        #expect(await storage.readValue() == "1")
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
