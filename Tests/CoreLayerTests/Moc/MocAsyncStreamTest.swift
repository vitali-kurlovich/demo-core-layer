//
//  Created by Kurlovich Vitali on 10/12/26.
//

import AsyncAlgorithms
import Testing

struct MocAsyncStreamTest {
    @Test
    func stream() async {
        let values = [1, 2, 3]

        let stream = MocAsyncStream<Int, Never>(values, period: .seconds(1))

        let result = await Array(stream.values)

        #expect(result == values)
    }

    @Test
    func streamThrows() async throws {
        let values = [1, 2, 3]
        let stream = MocAsyncStream<Int, MocAsyncStreamError>(
            values,
            period: .seconds(1)
        )

        let valuesStream = stream.values {
            if $0 == 2 {
                throw MocAsyncStreamError.streamError
            }
        }

        await #expect(throws: MocAsyncStreamError.streamError) {
            _ = try await Array(valuesStream)
        }
    }
}
