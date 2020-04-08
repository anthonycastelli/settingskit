//
//  AnyOptional.swift
//  
//
//  Created by Anthony Castelli on 3/29/20.
//

import Foundation

protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool {
        return self == nil
    }
}
