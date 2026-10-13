//
//  Created by Kurlovich Vitali on 10/13/26.
//

import CoreLayer
import Testing

@Suite("MapValueWriter")
struct MapValueWriterTest {
    @Test
    func map() async throws {
        let storage = MocThrowsValue<String>()

        let transformed = storage.map(Int.self) {
            String("\($0)$")
        }

        try await transformed.write(value: 1)

        #expect(
            try await storage.readValue() == "1$"
        )

        try await transformed.remove()

        #expect(
            try await storage.readValue() == nil
        )
    }
}
