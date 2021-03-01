//
//  File.swift
//  
//
//  Created by iWw on 2021/2/26.
//

import UIKit

class MultiScrollViewDelegater: NSObject, UIScrollViewDelegate {
    
    var internalDelegate: UIScrollViewDelegate?
    var externalDelegate: UIScrollViewDelegate?
    
    override func responds(to aSelector: Selector!) -> Bool {
        internalDelegate?.responds(to: aSelector) ?? false || externalDelegate?.responds(to: aSelector) ?? false
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if responds(to: aSelector) == true {
            return self.internalDelegate
        }
        return self.externalDelegate
    }
    
    required init(internal: UIScrollViewDelegate?, external: UIScrollViewDelegate?) {
        self.internalDelegate = `internal`
        self.externalDelegate = external
    }
}
