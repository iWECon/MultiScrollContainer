//
//  ViewController.swift
//  MultiScrollContainer
//
//  Created by iWw on 2021/1/13.
//

import UIKit
import SegmentedController
import Segmenter

class ViewController: MultiScrollContainer, SegmentedControllerable {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let v = UIView()
        v.backgroundColor = .red
        v.frame.size = .init(width: UIScreen.main.bounds.width, height: 300)
        headerView = v
        
        view.backgroundColor = .white
        
        func makeVC() -> TableViewController {
            let vc = TableViewController(style: .plain)
            return vc
        }
        
        pages = [
            .init(title: "今天", controller: makeVC()),
            .init(title: "明天", controller: makeVC()),
        ]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //segmentedControllerableDidLayoutSubviews()
//        let headerViewHeight: CGFloat = 200
//        headerView?.frame.size = .init(width: UIScreen.main.bounds.width, height: headerViewHeight)
//        segmenter.frame = .init(x: 0, y: headerViewHeight, width: UIScreen.main.bounds.width, height: Segmenter.Height)
//        pager.view.frame = .init(x: 0, y: headerViewHeight + Segmenter.Height, width: segmenter.frame.width, height: UIScreen.main.bounds.height - segmenter.frame.height - 44)
//        scrollView.frame = UIScreen.main.bounds
//        scrollView.contentSize = .init(width: segmenter.frame.width, height: UIScreen.main.bounds.height + headerViewHeight - 44)
    }
}

