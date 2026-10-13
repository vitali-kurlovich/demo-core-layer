//
//  Created by Kurlovich Vitali on 10/13/26.
//

import CoreLayer
import Testing

@Suite("MapValueReader")
struct MapValueReaderTest {
    @Test
    func `map`() async throws {
        let storage = MocThrowsValue(storage: "1")

        let result = storage.map {
            "\($0)$"
        }

        #expect(
            try await result.readValue() == "1$"
        )
    }
}
