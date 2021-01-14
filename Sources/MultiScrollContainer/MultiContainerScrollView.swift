//
//  MultiContainerScrollView.swift
//  MultiContainerScrollView
//
//  Created by iWw on 2021/1/14.
//

import UIKit

public protocol MultiScrollStateful: class {
    var scrollState: ScrollState { get set }
    var lastContentOffset: CGPoint { get set }
}

open class MultiContainerScrollView: UIScrollView, MultiScrollStateful {
    
    typealias MultiScrollView = UIScrollView & MultiScrollStateful
    
    /// if true, when did end drag will be auto scroll to top or define the position, default is true.
    open var snapbackEnabled = true
    
    public enum ScrollDirection {
        case pending
        case up
        case down
    }
    
    public static let observerKeyPath = "contentOffset"
    public static let observerOptions: NSKeyValueObservingOptions = [.old, .new]
    public var observerContext = 0
    
    public var scrollState: ScrollState = .pending
    public var lastContentOffset: CGPoint = .zero
    public var lastDirection: ScrollDirection = .pending
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public var isAtBottom: Bool {
        (frame.height + contentOffset.y) >= contentSize.height
    }
    
    private weak var observedScrollView: MultiScrollView?
    
    open func commonInit() {
        clipsToBounds = false
        scrollsToTop = false
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
        bounces = false
        delegate = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        panGestureRecognizer.cancelsTouchesInView = false
        isDirectionalLockEnabled = true
        
        addObserver(self, forKeyPath: Self.observerKeyPath, options: Self.observerOptions, context: &observerContext)
    }
    
    deinit {
        self.clearObservedViews()
        self.removeObserver(self, forKeyPath: Self.observerKeyPath, context: &observerContext)
    }
    
    private func addObserver(scrollView: MultiScrollView) {
        if let obScrollView = observedScrollView {
            if obScrollView == scrollView {
                return
            }
            obScrollView.removeObserver(self, forKeyPath: Self.observerKeyPath, context: &observerContext)
        }
        observedScrollView = scrollView
        scrollView.addObserver(self, forKeyPath: Self.observerKeyPath, options: Self.observerOptions, context: &observerContext)
    }
    private func clearObservedViews() {
        observedScrollView?.removeObserver(self, forKeyPath: Self.observerKeyPath, context: &observerContext)
        observedScrollView = nil
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let scrollView = object as? MultiScrollView,
              scrollView != self
        else {
            return
        }
        
        guard keyPath == Self.observerKeyPath,
              let newOffset = change?[.newKey] as? CGPoint,
              let oldOffset = change?[.oldKey] as? CGPoint
        else {
            return
        }
        
        guard oldOffset.y - newOffset.y != 0 else { return }
        
        // do other scrollView contentOffset change
        if self.scrollState == .scrolling {
            scrollView.contentOffset = scrollView.lastContentOffset
            scrollView.scrollState = .pending
            return
        }
        if scrollView.contentOffset.y + scrollView.contentInset.top <= 1.0 {
            scrollView.scrollState = .pending
        } else {
            scrollView.scrollState = .scrolling
        }
    }
}

extension MultiContainerScrollView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var forceInnerToScroll = false
        if observedScrollView?.scrollState == .scrolling {
            if scrollState == .pending {
                // vc在滑动，而容器的滑动位置仍为初始状态，切换vc后的不正常状态
                forceInnerToScroll = true
            } else {
                scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentSize.height - scrollView.frame.height)
            }
        }

        if forceInnerToScroll {
            scrollState = .scrolling
        } else if scrollView.contentOffset.y <= 1.0 {
            scrollState = .pending
        } else if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.height - 1.0) {
            scrollState = .ended
        } else {
            scrollState = .scrolling
        }

        observedScrollView?.lastContentOffset = observedScrollView?.contentOffset ?? .zero
        if scrollView.contentOffset.y > lastContentOffset.y {
            lastDirection = .up
        } else {
            lastDirection = .down
        }
        lastContentOffset = scrollView.contentOffset
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard snapbackEnabled == true else { return }
        
        if velocity.y <= .leastNormalMagnitude, scrollState == .scrolling {
            if lastDirection == .up {
                targetContentOffset.assign(repeating: CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.frame.height), count: 1)
            } else {
                targetContentOffset.assign(repeating: .zero, count: 1)
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard snapbackEnabled == true else { return }
        
        if scrollState == .scrolling {
            scrollView.setContentOffset(scrollView.contentOffset, animated: false)
            if lastDirection == .up {
                scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.frame.height), animated: true)
            } else {
                scrollView.setContentOffset(.zero, animated: true)
            }
        }
    }
}

extension MultiContainerScrollView: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard otherGestureRecognizer.view != self,
              let otherGestureRecognizer = otherGestureRecognizer as? UIPanGestureRecognizer,
              // Consider scroll view pan only
              let scrollView = otherGestureRecognizer.view as? MultiScrollView
        else {
            return false
        }
        
        let velocity = otherGestureRecognizer.velocity(in: self)
        if abs(velocity.x) > abs(velocity.y) {
            return false
        }
        
        self.addObserver(scrollView: scrollView)
        return true
    }
    
}
