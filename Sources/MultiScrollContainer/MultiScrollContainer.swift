import UIKit
import Segmenter
import Pager
import SegmentedController

public enum ScrollState: Int {
    case pending, scrolling, ended
}

open class MultiScrollContainer: UIViewController {
    
    public var scrollView = MultiContainerScrollView()
    
    private var oldOffset: CGPoint = .zero
    
    open var headerView: UIView? {
        get { scrollView.headerView }
        set { scrollView.headerView = newValue }
    }
    
    /// rest cotnentInset, contentOffset to .zero after layout
    open var resetAfterLayout = true
    
    /// if true, when did end drag will be auto scroll to top or define the position, default is true.
    open var snapbackEnabled: Bool {
        get { scrollView.snapbackEnabled }
        set { scrollView.snapbackEnabled = newValue }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.oldOffset = scrollView.contentOffset
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        view.addSubview(scrollView)
        
        // move pager.view and segmenter to scrollView
        if let segmentedControllerable = self as? SegmentedControllerable {
            scrollView.addSubview(segmentedControllerable.pager.view)
            scrollView.addSubview(segmentedControllerable.segmenter)
        }
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        guard resetAfterLayout else {
            scrollView.contentOffset = self.oldOffset
            return
        }
        scrollView.contentInset = .zero
        scrollView.contentOffset = .zero
    }
}
