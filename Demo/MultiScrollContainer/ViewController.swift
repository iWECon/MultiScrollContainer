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
        headerView = v
        
        view.backgroundColor = .white
        
        func makeVC() -> TableViewController {
            let vc = TableViewController(style: .plain)
            return vc
        }
        
        scrollView.delegate = self
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
        
        // 计算方式
        // headerView?.height ?? 0
        // segmenter.y = header.height
        //
        // pager.view.y = segmenter.frame.maxY
        // pager.view.height = view.frame.height - segmenter.height - (statusBarHeight/navigationBarHeight or other top spacing) ?? 0
        //
        // scrollView.frame = view.bounds
        // scrollView.contentSize.height = view.frame.height + (headerView?.height ?? 0) - (statusBarHeight/navigationBarHeight or other top spacing) ?? 0
        
        //segmentedControllerableDidLayoutSubviews()
        let headerViewHeight: CGFloat = 200
        headerView?.frame.size = .init(width: view.frame.width, height: headerViewHeight)
        segmenter.frame = .init(x: 0, y: headerViewHeight, width: view.frame.width, height: Segmenter.Height)
        pager.view.frame = .init(x: 0, y: segmenter.frame.maxY, width: view.frame.width, height: view.frame.height - segmenter.frame.height - UIApplication.shared.statusBarFrame.height)
        scrollView.frame = UIScreen.main.bounds
        scrollView.contentSize = .init(width: view.frame.width, height: view.frame.height + headerViewHeight - UIApplication.shared.statusBarFrame.height)
    }
}


extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("\(Date().timeIntervalSince1970): did scroll view")
    }
}
