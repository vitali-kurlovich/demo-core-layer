//
//  Created by Kurlovich Vitali on 10/13/26.
//

import CoreLayer
import Testing

@Suite("MapValueReaderWriter")
struct MapValueReaderWriterTest {
    @Test
    func `map`() async throws {
        let storage = MocThrowsValue<Int>()

        let mapped = storage.map {
            "\($0 + 1)"
        } write: { string in
            Int(string)
        }

        try await mapped.write(value: "1")

        #expect(
            try await storage.readValue() == 1
        )

        #expect(
            try await mapped.readValue() == "2"
        )

        try await storage.write(value: 5)

        #expect(
            try await storage.readValue() == 5
        )

        #expect(
            try await mapped.readValue() == "6"
        )
    }
}
