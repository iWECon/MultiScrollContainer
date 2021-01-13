//
//  MultiTableController.swift
//  MultiScrollContainer
//
//  Created by iWw on 2021/1/13.
//

import UIKit
import SegmentedController

open class MultiTableController: SegmentedTableController, ScrollStateful, ScrollDelegateProvider {
    
    public weak var multiScrollContainer: MultiScrollContainer?
    
    open weak var scrollDelegate: UIScrollViewDelegate?
    open var scrollView: UIScrollView {
        tableView
    }
    open var scrollState: ScrollState = .pending
    open var lastContentOffset: CGPoint = .zero
    
    private weak var proxyScrollDelegate: UIScrollViewDelegate?
    
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
        t.panDelegate = self
        tableView = t
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        if #available(iOS 13.0, *) {
            tableView.automaticallyAdjustsScrollIndicatorInsets = false
        }
        scrollDelegate = self
    }
    
    private var isMultiScrollChecked = false
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard !isMultiScrollChecked else { return }
        isMultiScrollChecked = true
        
        var p = self.parent
        while p != nil, !(p is MultiScrollContainer) {
            p = p?.parent
        }
        if let p = p as? MultiScrollContainer {
            self.multiScrollContainer = p
        }
    }
    
    open override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let container = self.multiScrollContainer else { return }
        if container.scrollState == .scrolling {
            scrollView.contentOffset = self.lastContentOffset
            self.scrollState = .pending
            return
        }
        super.scrollViewDidScroll(scrollView)
        if scrollView.contentOffset.y + scrollView.contentInset.top <= 1.0 {
            self.scrollState = .pending
        } else {
            self.scrollState = .scrolling
        }
    }
}

extension MultiTableController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if multiScrollContainer?.scrollView.panGestureRecognizer == otherGestureRecognizer {
            return true
        }
        return false
    }
}
