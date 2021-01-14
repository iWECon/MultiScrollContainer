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
        let topMargin: CGFloat = 300
        segmenter.frame = .init(x: 0, y: topMargin, width: UIScreen.main.bounds.width, height: Segmenter.Height)
        pager.view.frame = .init(x: 0, y: topMargin + Segmenter.Height, width: segmenter.frame.width, height: UIScreen.main.bounds.height - segmenter.frame.height)
        scrollView.frame = UIScreen.main.bounds
        scrollView.contentSize = .init(width: segmenter.frame.width, height: UIScreen.main.bounds.height + topMargin - 44)
    }
}

