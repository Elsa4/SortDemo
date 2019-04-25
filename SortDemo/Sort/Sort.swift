//
//  Sort.swift
//  SortDemo
//
//  Created by Cuicui You 尤翠翠 on 2019/1/25.
//  Copyright © 2019年 Cuicui You 尤翠翠. All rights reserved.
//

import UIKit

class Sort: NSObject {

}

protocol SortType {
    func sort(items: Array<Int>) -> Array<Int>
    func setEveryStepClosure(everyStepClosure: @escaping SortResultClosure,
                             sortSuccessClosure: @escaping SortSuccessClosure) -> Void
}
