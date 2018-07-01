//
//  ModelIdentifiableType.swift
//  Calculator
//
//  Created by 徐强强 on 2018/6/26.
//  Copyright © 2018年 heyongjian. All rights reserved.
//

import Foundation
import RxDataSources

protocol ModelIdentifiableType: IdentifiableType, Equatable {
    
}

extension ModelIdentifiableType {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identity == rhs.identity
    }
}
