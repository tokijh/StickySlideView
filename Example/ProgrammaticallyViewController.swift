//
//  ProgrammaticallyViewController.swift
//  Example
//
//  Created by  Joonghyun-Yoon on 2018. 6. 20..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import UIKit
import StickySlideView

class ProgrammaticallyViewController: UIViewController {
    
    let tableViewCellIdentifier = "TableViewCell"
    
    lazy var rightBarItemButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.onClickRightBarItem(_:)))
    
    lazy var stickySlideView: StickySlideView = { [unowned self] in
        let stickySlideView = StickySlideView(containerView: self.tableView, handlerHeight: 42, maxHeight: 500)
        return stickySlideView
        }()
    lazy var stickyBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        view.alpha = 0.0
        return view
    }()
    lazy var tableView: UITableView = UITableView()
    
    var rows: [String] = ["0", "1", "2", "3", "4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setupTableView()
        setupStickSlideView()
    }
    
    private func initView() {
        self.navigationItem.rightBarButtonItem = rightBarItemButton
        
        self.view.addSubview(self.stickySlideView)
        self.stickySlideView.translatesAutoresizingMaskIntoConstraints = false
        self.stickySlideView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.stickySlideView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        let bottomAnchor: NSLayoutAnchor<NSLayoutYAxisAnchor>
        if #available(iOS 11.0, *) {
            bottomAnchor = self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            bottomAnchor = self.view.bottomAnchor
        }
        self.stickySlideView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
        self.view.addSubview(self.stickyBackgroundView)
        self.stickyBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.stickyBackgroundView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.stickyBackgroundView.leadingAnchor.constraint(equalTo: self.stickySlideView.leadingAnchor).isActive = true
        self.stickyBackgroundView.trailingAnchor.constraint(equalTo: self.stickySlideView.trailingAnchor).isActive = true
        self.stickyBackgroundView.bottomAnchor.constraint(equalTo: self.stickySlideView.topAnchor).isActive = true
    }
    
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellIdentifier)
    }
    
    private func setupStickSlideView() {
        self.stickySlideView.delegate = self
    }
    
    @objc private func onClickRightBarItem(_ sender: UIBarButtonItem) {
        self.rows.append("\(self.rows.count)")
        self.tableView.reloadData()
        self.stickySlideView.update()
    }
}

extension ProgrammaticallyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tableViewCellIdentifier, for: indexPath)
        cell.textLabel?.text = self.rows[indexPath.row]
        return cell
    }
}

extension ProgrammaticallyViewController: StickySlideViewDelegate {
    func stickySlideView(_ stickySlideView: StickySlideView, didChangeHeight height: CGFloat) {
        print("height : \(height)")
    }
    
    func stickySlideView(_ stickySlideView: StickySlideView, didChangeOpenStatus isOpen: Bool) {
        print("isOpen : \(isOpen)")
    }
    
    func stickySlideView(_ stickySlideView: StickySlideView, didChangeProgress progress: CGFloat) {
        print("progress : \(progress)")
        self.stickyBackgroundView.alpha = progress
    }
}
