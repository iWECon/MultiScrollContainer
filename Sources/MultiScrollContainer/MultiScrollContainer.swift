import UIKit

public protocol ScrollProvider {
    var scrollView: UIScrollView? { get }
}
public extension ScrollProvider {
    var scrollView: UIScrollView? { nil }
}


public enum ScrollState: Int {
    case pending, scrolling, ended
}
public protocol ScrollStateful: class {
    var scrollView: UIScrollView { get }
    var scrollState: ScrollState { get }
    var lastContentOffset: CGPoint { get set }
}

public protocol ScrollDelegateProvider {
    var scrollDelegate: UIScrollViewDelegate? { get }
}


open class MultiScrollContainer: UIViewController, ScrollStateful {
    
    public enum ScrollDirection {
        case pending
        case up
        case down
    }
    
    public enum ViewPortState: Int {
        case begin, middle, end
    }
    
    var isAtBottom: Bool {
        (scrollView.frame.height + scrollView.contentOffset.y) >= scrollView.contentSize.height
    }
    
    /// needs to be override, return current viewController from your business
    open var currentController: ScrollStateful? {
        nil
    }
    
    public var scrollState: ScrollState = .pending
    public let scrollView = UIScrollView()
    public var lastContentOffset: CGPoint = .zero
    private var lastDirection: ScrollDirection = .pending
    
    open var resetAfterLayout = true
    open var snapbackEnabled = true
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.clipsToBounds = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        guard resetAfterLayout else { return }
        scrollView.contentInset = .zero
        scrollView.contentOffset = .zero
    }
}

extension MultiScrollContainer: UIScrollViewDelegate {
    
    private func getScrollView(from vc: UIViewController) -> UIScrollView? {
        if let scrollProvider = vc as? ScrollProvider, let scrollView = scrollProvider.scrollView {
            return scrollView
        }
        return Mirror(reflecting: vc).children.first(where: { $0.value is UIScrollView })?.value as? UIScrollView
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView,
              let vc = currentController
        else {
            return
        }
        
        var forceInnerToScroll = false
        if vc.scrollState == .scrolling {
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
        
        vc.lastContentOffset = vc.scrollView.contentOffset
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
