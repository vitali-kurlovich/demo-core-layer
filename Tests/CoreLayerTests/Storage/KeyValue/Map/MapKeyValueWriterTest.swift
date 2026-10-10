//
//  Created by Kurlovich Vitali on 10/9/26.
//

import CoreLayer
import Testing

@Suite("MapKeyValueWriter")
struct MapKeyValueWriterTest {
    @Test
    func map() async throws {
        let keyValue = MocKeyValue<Int, String>()

        let transformed = keyValue.map(Int.self) {
            String("\($0)$")
        }

        try await transformed.write(by: 1, value: 1)

        #expect(
            try await keyValue.readValue(by: 1) == "1$"
        )

        try await transformed.remove(by: 1)

        #expect(
            try await keyValue.readValue(by: 1) == nil
        )
    }
}
