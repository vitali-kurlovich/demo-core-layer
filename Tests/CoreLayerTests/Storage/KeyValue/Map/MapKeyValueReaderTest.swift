//
//  Created by Kurlovich Vitali on 10/9/26.
//

import CoreLayer
import Testing

@Suite("MapKeyValueReader")
struct MapKeyValueReaderTest {
    @Test
    func `map`() async throws {
        let keyValue = MocKeyValue<Int, String>(storage: [1: "1"])

        let mapKeyValue = keyValue.map {
            "\($0)$"
        }

        #expect(
            try await mapKeyValue.readValue(by: 1) == "1$"
        )

        #expect(
            try await mapKeyValue.readValue(by: 2) == nil
        )
    }
}
