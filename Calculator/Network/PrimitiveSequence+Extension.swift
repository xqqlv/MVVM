//
//  PrimitiveSequence+Extension.swift
//  Calculator
//
//  Created by heyongjian on 2018/5/19.
//  Copyright © 2018年 heyongjian. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {

    // MARK: - object

    func mapToObject<T: Mappable>(type: T.Type) -> Single<T> {
        return mapToResponse()
                .map {
                    guard let result = $0, let dict = result as? [String: Any], !dict.isEmpty else {
                        throw MoyaErrorType.notValidData
                    }

                    guard let obj = Mapper<T>().map(JSON: dict) else {
                        throw MoyaErrorType.mappable
                    }

                    return obj
            }
            .catchError({ (error) in
                throw MoyaErrorType.unReachable
            })

    }

    // MARK: - array

    func mapToArray<T: Mappable>(type: T.Type) -> Single<[T]> {
        return mapToResponse()
                .map {
                    guard let response = $0 as? [Any], let dicts = response as? [[String: Any]] else {
                        throw MoyaErrorType.notValidData
                    }

                    let array = Mapper<T>().mapArray(JSONArray: dicts)
                    return array
            }
            .catchError({ (error) in
                throw MoyaErrorType.unReachable
            })
    }

    // MARK: - response

    func mapToResponse() -> Single<Any?> {
        return asObservable().map { response in
            guard let json = try? JSONSerialization.jsonObject(with: response.data, options: .allowFragments) else {
                throw MoyaErrorType.json
            }
            guard (200 == response.statusCode) else {
                throw MoyaErrorType.fail(errorCode: response.statusCode, errorMessage: "")
            }
            return json
        }.asSingle()
    }
}

/*
 错误定义
 */
public enum MoyaErrorType: Equatable {
    case none
    case json
    case mappable
    case notValidData
    case fail(errorCode: Int, errorMessage: String)
    case unReachable
}

extension MoyaErrorType: Error {
    
    var description: String {
        switch self {
        case .json:
            return "json解析异常"
        case .mappable:
            return "Mapper解析异常"
        case .notValidData:
            return "内容无效"
        case .fail:
            return "失败"
        case .unReachable:
            return "网络异常"
        default:
            return ""
        }
    }
}
