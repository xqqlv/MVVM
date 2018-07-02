//
//  NoDataTracker.swift
//  Calculator
//
//  Created by 徐强强 on 2018/6/28.
//  Copyright © 2018年 heyongjian. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import ObjectMapper

final class NoDataTracker: SharedSequenceConvertibleType {
    
    public typealias E = Bool
    typealias SharingStrategy = DriverSharingStrategy
    
    private let subject = PublishSubject<E>()
    private let noData: SharedSequence<SharingStrategy, Bool>
    
    public init() {
        noData = subject.asDriver(onErrorJustReturn: false)
    }
    
    fileprivate func trackNoDataOfObservable<O: ObservableConvertibleType, T: SectionModelType>(_ source: O, _ type: T.Type) -> Observable<O.E> {
        return source.asObservable()
            .do(onNext: { (value) in
                print(value)
                if let value = value as? [T] {
                    self.sendCompleted(!value.isEmpty)
                }
            }, onSubscribe: subscribed)
    }
    
    private func subscribed() {
        subject.onNext(true)
    }
    
    private func sendCompleted(_ isNoData: Bool) {
        subject.onNext(isNoData)
    }
    
    public func asSharedSequence() -> SharedSequence<SharingStrategy, E> {
        return noData
    }
}

extension ObservableConvertibleType {
    func trackNoData<T: SectionModelType>(_ noDataTracker: NoDataTracker, _ type: T.Type) -> Observable<E> {
        return noDataTracker.trackNoDataOfObservable(self, type)
    }
}
