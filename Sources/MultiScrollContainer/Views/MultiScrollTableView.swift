//
//  MultiScrollTableView.swift
//  MultiScrollContainer
//
//  Created by iWw on 2021/1/13.
//

import UIKit

open class MultiScrollTableView: UITableView, UIGestureRecognizerDelegate {
    
    open weak var panDelegate: UIGestureRecognizerDelegate?
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let result = panDelegate?.gestureRecognizer?(gestureRecognizer, shouldRecognizeSimultaneouslyWith: otherGestureRecognizer) {
            return result
        }
        return false
    }
    
}
