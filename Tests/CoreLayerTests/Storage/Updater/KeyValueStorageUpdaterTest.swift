//
//  Created by Kurlovich Vitali on 10/12/26.
//

import CoreLayer
import Testing

struct KeyValueStorageUpdaterTest {
    @Test
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    func update() async {
        let keyValue = MocKeyValue<String, Int>()

        let values = [1, 2, 3]

        let stream = MocAsyncStream<Int, Never>(values, period: .milliseconds(100))

        let updater = KeyValueStorageUpdater(keyValue) { value in
            "\(value)"
        }

        await updater.watch(stream.values)

        #expect(await keyValue.readValue(by: "1") == 1)
        #expect(await keyValue.readValue(by: "2") == 2)
        #expect(await keyValue.readValue(by: "3") == 3)
        #expect(await keyValue.readValue(by: "4") == nil)
    }

    @Test
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    func streamError() async throws {
        let keyValue = MocKeyValue<String, Int>()

        let values = [1, 2, 3]

        let stream = MocAsyncStream<Int, MocKeyValueError>(values, period: .milliseconds(100))

        let updater = KeyValueStorageUpdater(
            keyValue
        ) { value in
            "\(value)"
        }

        let streamValues = stream.values { value in
            if value == 2 {
                throw MocAsyncStreamError.streamError
            }
        }

        await #expect(throws: MocAsyncStreamError.streamError) {
            try await updater.watch(streamValues)
        }

        #expect(try await keyValue.readValue(by: "1") == 1)
        #expect(try await keyValue.readValue(by: "2") == nil)
        #expect(try await keyValue.readValue(by: "3") == nil)
        #expect(try await keyValue.readValue(by: "4") == nil)
    }

    @Test
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    func writeError() async {
        let keyValue = MocThrowsKeyValue<String, Int>(error: .writeFailed)

        let values = [1, 2, 3]

        let stream = MocAsyncStream<Int, Never>(
            values,
            period: .milliseconds(100)
        )

        await confirmation(
            "handleError is called",
            expectedCount: 3
        ) { confirm in
            let updater = KeyValueStorageUpdater(
                keyValue,
                handleError: { error in
                    #expect(error == .writeFailed)
                    confirm()
                }
            ) { value in
                "\(value)"
            }

            let streamValues = stream.values

            await updater.watch(streamValues)
        }
    }
}
