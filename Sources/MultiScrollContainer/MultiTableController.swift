//
//  MultiTableController.swift
//  MultiScrollContainer
//
//  Created by iWw on 2021/1/13.
//

import UIKit
import SegmentedController

open class MultiTableController: SegmentedTableController {
    
    convenience public init() {
        self.init(style: .plain)
    }
    
    override public init(style: UITableView.Style) {
        super.init(style: style)
        commonInit()
    }
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    open func commonInit() {
        let t = MultiScrollTableView(frame: tableView.bounds, style: tableView.style)
        tableView = t
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        if #available(iOS 13.0, *) {
            tableView.automaticallyAdjustsScrollIndicatorInsets = false
        }
    }
}
