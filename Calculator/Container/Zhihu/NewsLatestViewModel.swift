//
// Created by heyongjian on 2018/5/17.
// Copyright (c) 2018 heyongjian. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
import Differentiator

class NewsLatestViewModel: ViewModelType {
    
    private let navigator: NewsLatestNavigatorProtocol
    
    var newsList: [SectionModel<String, NewsInfo>] = []
    
    init(navigator: NewsLatestNavigatorProtocol) {
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {
        
        let activityIndicator = ActivityIndicator()
        let loadingTracker = LoadingTracker()
        let noDataTracker = NoDataTracker()
        let errorTracker = ErrorTracker()
    
        let newsList = Driver.merge(input.buttonClick.map({ return true }), input.fetching.map({ return false }))
            .flatMapLatest { [unowned self] (isLoadMore) -> Driver<[SectionModel<String, NewsInfo>]> in
                if isLoadMore {
                    return self.getMoreList().trackError(errorTracker)
                        .asDriver(onErrorJustReturn: self.newsList)
                } else {
                    return self.getNewsList().trackError(errorTracker)
                        .asDriver(onErrorJustReturn: self.newsList)
                }
        }
            .trackActivity(activityIndicator)
            .trackNoData(noDataTracker, SectionModel<String, NewsInfo>.self)
            .asDriverOnErrorJustComplete()
        
        let selectedCell = input.selection.trackLoading(loadingTracker, true)
            .map({ return self.newsList[$0.section].items[$0.row] })
            .trackLoading(loadingTracker, false)
            .asDriverOnErrorJustComplete()
        
        let isRefreshing = activityIndicator.asDriver()
        let loading = loadingTracker.asDriver()
        let noData = noDataTracker.asDriver()
        let error = errorTracker.asDriver()

        return Output(newsList: newsList, selectedCell: selectedCell, isRefreshing: isRefreshing, loading: loading, noData: noData, error: error)
    }

    private func getNewsList() -> Single<[SectionModel<String, NewsInfo>]> {
        return APIProvider.rx.request(.getNewsLatest)
            .mapToObject(type: NewsLatest.self)
            .map({ (news) -> [SectionModel<String, NewsInfo>] in
                    var newsSection = SectionModel<String, NewsInfo>(model: "NewsLatest", items: [])
                    news.stories.forEach({ (info) in
                        newsSection.items.append(info)
                    })
                    self.newsList = [newsSection]
                    return [newsSection]
            })
    }
    
    private func getMoreList() -> Single<[SectionModel<String, NewsInfo>]> {
        return APIProvider.rx.request(.getNewsLatest)
            .mapToObject(type: NewsLatest.self)
            .map({ (news) -> [SectionModel<String, NewsInfo>] in
                var newsSection = self.newsList[0]
                news.stories.forEach({ (info) in
                    newsSection.items.append(info)
                })
                self.newsList = [newsSection]
                return [newsSection]
            })
    }

}


extension NewsLatestViewModel {
    struct Input {
        let buttonClick: Driver<Void>
        let fetching: Driver<Void>
        let selection: Driver<IndexPath>
    }

    struct Output {
        let newsList: Driver<[SectionModel<String, NewsInfo>]>
        let selectedCell: Driver<NewsInfo>
        let isRefreshing: Driver<Bool>
        let loading: Driver<Bool>
        let noData: Driver<Bool>
        let error: Driver<Error>
    }
}
