//
//  Extensino.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/2/20.
//

// MARK: - String Extension
extension Optional where Wrapped == String {
    
    var isNilOrEmpty: Bool {
        self == nil || self == ""
    }
    
}
