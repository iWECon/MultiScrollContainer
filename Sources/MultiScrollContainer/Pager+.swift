//
//  Pager+.swift
//  MultiScrollContainer
//
//  Created by iWw on 2021/1/13.
//

import UIKit
import SegmentedController
import Segmenter

public extension SegmentedController {
    
    @discardableResult func moveTo(_ viewController: MultiScrollContainer) -> Self {
        willMove(toParent: viewController)
        viewController.addChild(self)
        viewController.scrollView.addSubview(view)
        didMove(toParent: viewController)
        
        if let segmentedable = viewController as? Segmentedable {
            self.segmenter = segmentedable.segmenter
            segmentedable.segmenter.isShadowHidden = true
            viewController.scrollView.addSubview(segmentedable.segmenter)
            if let segmenterDelgate = segmentedable.segmenter.delegate {
                //self.segmenterDelgate = segmenterDelgate
                setValue(segmenterDelgate, forKey: "segmenterDelegate")
                self.segmenter?.delegate = self
            } else {
                self.segmenter?.delegate = self
            }
        }
        return self
    }
    
}
