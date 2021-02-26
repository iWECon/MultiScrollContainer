//
//  File.swift
//  
//
//  Created by iWw on 2021/2/26.
//

import UIKit

// from: https://gist.github.com/matt-curtis/65eb4bd7e98e6ace2d220c3067df7fc7
//class DelegateForwarder<T: NSObjectProtocol>: NSObject {
//
//    //    MARK: - Properties
//
//    weak var internalDelegate: T?
//
//    weak var externalDelegate: T?
//
//
//    var asConforming: T {
//        return unsafeBitCast(self, to: T.self)
//    }
//
//
//    //    MARK: - Init
//
//    init(internalDelegate: T? = nil, externalDelegate: T? = nil) {
//        self.internalDelegate = internalDelegate
//        self.externalDelegate = externalDelegate
//    }
//
//
//    //    MARK: - Forwarding
//
//    override func responds(to sel: Selector!) -> Bool {
//        return
//            self.internalDelegate?.responds(to: sel) ?? false ||
//            self.externalDelegate?.responds(to: sel) ?? false
//    }
//
//    override func forwardingTarget(for sel: Selector!) -> Any? {
//        if self.internalDelegate?.responds(to: sel) == true {
//            return self.internalDelegate
//        }
//
//        return self.externalDelegate
//    }
//
//}


class MultiScrollViewDelegater: NSObject, UIScrollViewDelegate {
    
    var internalDelegate: UIScrollViewDelegate?
    var externalDelegate: UIScrollViewDelegate?
    
    override func responds(to sel: Selector!) -> Bool {
        internalDelegate?.responds(to: sel) ?? false || externalDelegate?.responds(to: sel) ?? false
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if internalDelegate?.responds(to: aSelector) == true {
            return self.internalDelegate
        }
        return self.externalDelegate
    }
    
    required init(internal: UIScrollViewDelegate?, external: UIScrollViewDelegate?) {
        self.internalDelegate = `internal`
        self.externalDelegate = external
    }
}
