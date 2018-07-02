//
// Created by heyongjian on 2018/4/24.
// Copyright (c) 2018 heyongjian. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

class NewsLatestController: UIViewController {

    var viewModel: NewsLatestViewModel!
    private let disposeBag: DisposeBag = DisposeBag()
    private var data: NewsLatest?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray

        setUpView()
        setUpBinding()
        
    }

    private func setUpView() {
        self.view.addSubview(button)
        self.view.addSubview(tableView)
        tableView.addSubview(noDataView)
        tableView.addSubview(noNetView)

        button.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(-30)
            maker.height.equalTo(30)
        }

        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.bottom.equalTo(self.button.snp.top)
        }
        
        tableView.refreshControl = UIRefreshControl()

    }

    private func setUpBinding() {
        let fetching = tableView.refreshControl!.rx.controlEvent(.valueChanged).asDriver()
        let input = NewsLatestViewModel.Input(buttonClick: button.rx.tap.asDriver(), fetching: Driver.merge(Driver<Void>.just(()), fetching, noNetView.reloadButtonTap.asDriver()), selection: tableView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input: input)

        output.newsList.drive(self.tableView.rx.items(dataSource: self.dataSource())).disposed(by: disposeBag)
        output.isRefreshing.drive(tableView.refreshControl!.rx.isRefreshing).disposed(by: disposeBag)
        output.loading.drive(rx.isShowLoading).disposed(by: disposeBag)
        output.noData.drive(noDataView.rx.isHidden).disposed(by: disposeBag)
        output.error.drive(rx.errorType).disposed(by: disposeBag)
        output.selectedCell.drive(onNext: { (model) in
            print(model.title)
        }).disposed(by: disposeBag)
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
//        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
//        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(NewsLatestCell.self)

        return tableView
    }()

    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("click", for: .normal)
        button.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return button
    }()
    
    lazy var loading: LoadingView = {
        return LoadingView(text: "加载中", delay: 0, superView: self.view)
    }()
    
    lazy var noDataView: NoDataView = {
        let noDataView = NoDataView()
        noDataView.image = UIImage(named: "order_no_data_icon")
        noDataView.text = "这里什么都没有"
        noDataView.imageViewTopMargin = 82
        noDataView.backgroundColor =  UIColor.white
        noDataView.frame = self.view.bounds
        noDataView.isHidden = true
        
        return noDataView
    }()
    
    lazy var noNetView: NoNetView = {
        let noNetView = NoNetView()
        noNetView.imageViewTopMargin = 82
        noNetView.backgroundColor = UIColor.white
        noNetView.frame = self.view.bounds
        noNetView.isHidden = true
        
        return noNetView
    }()

    @objc func btnClick() {
        print("-----hello")
    }
}

extension NewsLatestController {
    private func dataSourceAnimated() -> RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, NewsInfo>> {
        return RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, NewsInfo>>(
                configureCell: { (data, table, indexPath, item) in
                    let cell: NewsLatestCell = table.dequeueReusableCell(NewsLatestCell.self)
                    cell.data = item.title
                    return cell
                })
    }
    
    private func dataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<String, NewsInfo>> {
        return RxTableViewSectionedReloadDataSource<SectionModel<String, NewsInfo>>(
            configureCell: { (data, table, indexPath, item) in
                let cell: NewsLatestCell = table.dequeueReusableCell(NewsLatestCell.self)
                cell.data = item.title
                return cell
        })
    }
}

extension NewsLatestController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension Reactive where Base: NewsLatestController {
    var isShowLoading: Binder<Bool> {
        return Binder(base, binding: { (vc, result) in
            if result {
                vc.loading.show()
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    vc.loading.hide()
                })
            }
        })
    }
    
    var errorType: Binder<Error> {
        return Binder(base, binding: { (vc, result) in
            if let error = result as? MoyaErrorType, error == .unReachable, vc.viewModel.newsList.isEmpty {
                vc.noNetView.isHidden = false
            } else {
                vc.noNetView.isHidden = true
            }
        })
    }
    
}

public extension UITableView {
    /**
     Reusable Cell
     - parameter aClass:    class
     - returns: cell
     */
    func dequeueReusableCell<T: UITableViewCell>(_ aClass: T.Type) -> T! {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: name) as? T else {
            fatalError("\(name) is not registered")
        }
        return cell
    }

    /**
     Register cell class
     - parameter aClass: class
     */

    func register<T: UITableViewCell>(_ aClass: T.Type) -> Void {
        let name = String(describing: aClass)
        self.register(aClass, forCellReuseIdentifier: name)
    }
}
