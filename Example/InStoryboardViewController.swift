//
//  InStoryboardViewController.swift
//  Example
//
//  Created by  Joonghyun-Yoon on 2018. 6. 20..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import UIKit
import StickySlideView

class InStoryboardViewController: UIViewController {
    lazy var label: UILabel = {
        let label = UILabel()
        label.text =
        """
        fads
        f
        as
        fasd
        f
        asdfadsfsadf
        asdfas
        fasfsad
        fasdf
        sadf
        asdf
        a
        gdsfsad
        fad
        sfanjdi
        """
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
