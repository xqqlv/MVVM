//
//  TypealiasName.swift
//  takeaway
//
//  Created by 徐强强 on 2018/1/15.
//  Copyright © 2018年 zaihui. All rights reserved.
//

import Foundation

public typealias VoidBlock = () -> Void
public typealias BoolBlock = (Bool) -> Void
public typealias IntBlock = (Int) -> Void
public typealias DoubleBlock = (Double) -> Void
public typealias FloatBlock = (Float) -> Void
public typealias StringBlock = (String) -> Void
public typealias ArrayBlock<T> = (Array<T>) -> Void
public typealias ObjectBlock<T> = (T) -> Void
public typealias URLBlock<T> = (URL) -> Void

