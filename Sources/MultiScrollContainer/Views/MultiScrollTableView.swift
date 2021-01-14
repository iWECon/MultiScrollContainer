//
//  MultiScrollTableView.swift
//  MultiScrollContainer
//
//  Created by iWw on 2021/1/13.
//

import UIKit

open class MultiScrollTableView: UITableView, MultiScrollStateful {
    
    public var scrollState: ScrollState = .pending
    public var lastContentOffset: CGPoint = .zero
    
}
