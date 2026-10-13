//
//  ValueWriterTest.swift
//  demo-core-layer
//
//  Created by Kurlovich Vitali on 10/13/26.
//

import CoreLayer
import Testing

@Suite("ValueWriter")
struct ValueWriterTest {
    @Test
    func write() async {
        let storage = MocValue<String>()
        #expect(await storage.storage == nil)

        await storage.write(value: "1")

        #expect(await storage.storage == "1")

        await storage.remove()

        #expect(await storage.storage == nil)
    }

    @Test
    func writeThrows() async throws {
        let storage = MocThrowsValue<String>(storage: "1", error: nil)
        #expect(await storage.storage == "1")

        try await storage.write(value: "2")

        #expect(await storage.storage == "2")

        try await storage.remove()

        #expect(await storage.storage == nil)
    }

    @Test
    func writeToCacheWithError() async throws {
        let storage = MocThrowsValue<String>(storage: "1", error: .writeFailed)

        await #expect(throws: MocValueError.writeFailed) {
            try await storage.write(value: "2")
        }

        #expect(await storage.storage == "1")
    }
}
