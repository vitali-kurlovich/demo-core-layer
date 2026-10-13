//
//  MocValue.swift
//  demo-core-layer
//
//  Created by Kurlovich Vitali on 10/13/26.
//

import CoreLayer

actor MocValue<Value: Sendable> {
    var storage: Value?
    init(
        storage: Value? = nil
    ) {
        self.storage = storage
    }
}

extension MocValue: ValueStorageReader<Value, Never> {
    func readValue() async -> Value? {
        storage
    }
}

extension MocValue: ValueStorageWriter<Value, Never> {
    func write(value: Value?) async {
        storage = value
    }
}
