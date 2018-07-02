//
//  LoadingTracker.swift
//  Calculator
//
//  Created by 徐强强 on 2018/6/28.
//  Copyright © 2018年 heyongjian. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class LoadingTracker: SharedSequenceConvertibleType {
    
    public typealias E = Bool
    typealias SharingStrategy = DriverSharingStrategy
    
    private let subject = PublishSubject<E>()
    private let loading: SharedSequence<SharingStrategy, Bool>
    
    public init() {
        loading = subject.asDriver(onErrorJustReturn: false)
    }
    
    fileprivate func trackLoadingOfObservable<O: ObservableConvertibleType>(_ source: O, _ isShowLoading: Bool) -> Observable<O.E> {
        return source.asObservable()
            .do(onNext: { _ in
                self.sendShowLoading(isShowLoading)
            }, onError: { _ in
                self.sendShowLoading(isShowLoading)
            }, onCompleted: {
                self.sendShowLoading(isShowLoading)
            }, onSubscribe: subscribed)
    }
    
    private func subscribed() {
        subject.onNext(false)
    }
    
    private func sendShowLoading(_ isShowLoading: Bool) {
        subject.onNext(isShowLoading)
    }
    
    public func asSharedSequence() -> SharedSequence<SharingStrategy, E> {
        return loading
    }
}

extension ObservableConvertibleType {
    func trackLoading(_ loadingTracker: LoadingTracker, _  isShowLoading: Bool) -> Observable<E> {
        return loadingTracker.trackLoadingOfObservable(self, isShowLoading)
    }
}

