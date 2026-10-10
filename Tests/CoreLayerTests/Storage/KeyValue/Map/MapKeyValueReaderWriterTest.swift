//
//  Created by Kurlovich Vitali on 10/9/26.
//

import CoreLayer
import Testing

@Suite("MapKeyValueReaderWriter")
struct MapKeyValueReaderWriterTest {
    @Test
    func `map`() async throws {
        let keyValue = MocKeyValue<Int, Int>()

        let mapped = keyValue.map {
            "\($0 + 1)"
        } write: { string in
            Int(string)
        }

        try await mapped.write(by: 1, value: "1")
        try await mapped.write(by: 2, value: "2")

        #expect(
            try await mapped.readValue(by: 1) == "2"
        )

        #expect(
            try await mapped.readValue(by: 2) == "3"
        )

        try await mapped.write(by: 1, value: "aaa")

        #expect(
            try await mapped.readValue(by: 1) == nil
        )

        try await mapped.write(by: 2, value: nil)

        #expect(
            try await mapped.readValue(by: 2) == nil
        )
    }
}
