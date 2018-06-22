//
//  InCodeViewController.swift
//  Example
//
//  Created by  Joonghyun-Yoon on 2018. 6. 20..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import UIKit
import StickySlideView

class InCodeViewController: UIViewController {
    lazy var stickySlideView: StickySlideView = { [unowned self] in
        let stickySlideView = StickySlideView(containerView: self.tableView, handlerHeight: 42, maxHeight: 500)
        return stickySlideView
        }()
    lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView()
        tableView.dataSource = self
        return tableView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        self.view.addSubview(self.stickySlideView)
        self.stickySlideView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.stickySlideView,
                           attribute: NSLayoutAttribute.left,
                           relatedBy: NSLayoutRelation.equal,
                           toItem: self.view,
                           attribute: NSLayoutAttribute.left,
                           multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: self.stickySlideView,
                           attribute: NSLayoutAttribute.right,
                           relatedBy: NSLayoutRelation.equal,
                           toItem: self.view,
                           attribute: NSLayoutAttribute.right,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        let bottomToItem: Any
        if #available(iOS 11.0, *) {
            bottomToItem = self.view.safeAreaLayoutGuide
        } else {
            bottomToItem = self.view
        }
        NSLayoutConstraint(item: self.stickySlideView,
                           attribute: NSLayoutAttribute.bottom,
                           relatedBy: NSLayoutRelation.equal,
                           toItem: bottomToItem,
                           attribute: NSLayoutAttribute.bottom,
                           multiplier: 1,
                           constant: 0).isActive = true
    }
}

extension InCodeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = indexPath.section == 0 ? "Handler" : "\(indexPath.row)"
        cell.textLabel?.textAlignment = .center
        return cell
    }
}
