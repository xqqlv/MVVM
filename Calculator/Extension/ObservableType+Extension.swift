//
//  Observable+Extension.swift
//  Calculator
//
//  Created by 徐强强 on 2018/6/27.
//  Copyright © 2018年 heyongjian. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType {
    
    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { error in
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
    func mapToBool(_ bool: Bool) -> Observable<Bool> {
        return map({ (_) -> Bool in
            return bool
        })
    }
}
