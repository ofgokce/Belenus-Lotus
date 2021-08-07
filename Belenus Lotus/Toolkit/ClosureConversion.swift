//
//  ClosureConversion.swift
//  Belenus Lotus
//
//  Created by Ömer Faruk Gökce on 7.08.2021.
//

import Foundation

struct ClosureConverter {
    static func convert<FromParameterType, FromReturnType, ToParameterType, ToReturnType>
    (from block: (FromParameterType) -> FromReturnType) -> ((ToParameterType) -> ToReturnType) {
        
    }
}
