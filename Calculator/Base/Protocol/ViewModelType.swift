//
// Created by heyongjian on 2018/4/24.
// Copyright (c) 2018 heyongjian. All rights reserved.
//

import Foundation
import  RxSwift
import RxCocoa

protocol OutputProtocol {
    var fetching: Driver<Bool> { get }
    var noNetTracker: Driver<Bool> { get }
    var noDataTracker: Driver<Bool> { get }
}

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
