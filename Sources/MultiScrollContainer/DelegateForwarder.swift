//
//  File.swift
//  
//
//  Created by iWw on 2021/2/26.
//

import UIKit

class MultiScrollViewDelegater: NSObject, UIScrollViewDelegate {
    
    weak var internalDelegate: UIScrollViewDelegate?
    weak var externalDelegate: UIScrollViewDelegate?
    
    deinit {
        cleanup()
    }
    
    func cleanup() {
        internalDelegate = nil
        externalDelegate = nil
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        // 优先走内部，内部有事件需要处理
        // 内部实现的地方手动转发出去到外部去
        if internalDelegate?.responds(to: aSelector) == true || externalDelegate?.responds(to: aSelector) == true {
            return true
        }
        return false
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if internalDelegate?.responds(to: aSelector) == true {
            return internalDelegate
        }
        if externalDelegate?.responds(to: aSelector) == true {
            return externalDelegate
        }
        return nil
    }
}
