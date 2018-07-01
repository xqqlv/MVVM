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

final class NoDataTracker: SharedSequenceConvertibleType {
    
    public typealias E = Bool
    typealias SharingStrategy = DriverSharingStrategy
    
    private let subject = PublishSubject<E>()
    private let noData: SharedSequence<SharingStrategy, Bool>
    private var isNoData: Bool = true
    
    public init() {
        noData = subject.asDriver(onErrorJustReturn: false)
    }
    
    fileprivate func trackNoDataOfObservable<O: ObservableConvertibleType>(_ source: O, _ isNoData: Bool) -> Observable<O.E> {
        self.isNoData = isNoData
        return source.asObservable()
            .do(onNext: { _ in
                self.sendCompleted()
            }, onError: { _ in
                self.sendCompleted()
            }, onCompleted: {
                self.sendCompleted()
            }, onSubscribe: subscribed)
    }
    
    private func subscribed() {
        subject.onNext(isNoData)
    }
    
    private func sendCompleted() {
        subject.onNext(isNoData)
    }
    
    public func asSharedSequence() -> SharedSequence<SharingStrategy, E> {
        return noData
    }
}

extension ObservableConvertibleType {
    func trackNoData(_ noDataTracker: NoDataTracker, _ isNoData: Bool) -> Observable<E> {
        print(isNoData)
        return noDataTracker.trackNoDataOfObservable(self, isNoData)
    }
}
