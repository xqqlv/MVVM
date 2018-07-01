//
//  NewsLatest.swift
//  Calculator
//
//  Created by heyongjian on 2018/5/19.
//  Copyright © 2018年 heyongjian. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift
import RxDataSources

struct NewsLatest: Mappable {
    
    var date: String!
    var stories: [NewsInfo] = []

    init?(map: Map) {

    }

    init() {

    }

    mutating func mapping(map: Map) {
        date <- map["date"]
        stories <- map["stories"]
    }
}
