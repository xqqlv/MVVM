//
//  ActivityIndicator.swift
//  Calculator
//
//  Created by 徐强强 on 2018/6/19.
//  Copyright © 2018年 heyongjian. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public class ActivityIndicator: SharedSequenceConvertibleType {
    public typealias E = Bool
    public typealias SharingStrategy = DriverSharingStrategy
    
    private let subject = PublishSubject<E>()
    private let loading: SharedSequence<SharingStrategy, Bool>
    
    public init() {
        loading = subject.asDriver(onErrorJustReturn: false)
            .distinctUntilChanged()
    }
    
    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.E> {
        return source.asObservable()
            .do(onNext: { _ in
                self.sendStopLoading()
            }, onError: { _ in
                self.sendStopLoading()
            }, onCompleted: {
                self.sendStopLoading()
            }, onSubscribe: subscribed)
    }
    
    private func subscribed() {
        subject.onNext(true)
    }
    
    private func sendStopLoading() {
        subject.onNext(false)
    }
    
    public func asSharedSequence() -> SharedSequence<SharingStrategy, E> {
        return loading
    }
}

extension ObservableConvertibleType {
    public func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<E> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}

