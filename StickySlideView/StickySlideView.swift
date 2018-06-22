//
//  StickySlideView.swift
//  StickySlideView
//
//  Created by  Joonghyun-Yoon on 2018. 6. 20..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import Foundation

@IBDesignable
open class StickySlideView: UIView {
    
    @IBOutlet weak open private(set) var containerView: UIScrollView! {
        willSet {
            self.containerView?.panGestureRecognizer.removeTarget(self, action: #selector(self.detectScrollPangesture(_:)))
            self.scrollOffsetObserver?.invalidate()
            self.scrollOffsetObserver = nil
        }
    }
    
    private lazy var defaultContainerView: UIScrollView = UIScrollView()
    
    @IBInspectable open var handlerHeight: CGFloat = 32 {
        didSet {
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }
    @IBInspectable open var maxHeight: CGFloat = 400 {
        didSet {
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }
    @IBInspectable open var isOpen: Bool = false {
        didSet {
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }
    @IBInspectable open var sensitive: CGFloat = 8 {
        didSet {
            if self.sensitive < 1 {
                self.sensitive = 0
            }
        }
    }
    
    private var tapGesture: UITapGestureRecognizer!
    private var panGesture: UIPanGestureRecognizer!
    private var scrollOffsetObserver: NSKeyValueObservation?
    
    private var heightConstraint: CGFloat {
        get {
            return self.heightLayoutConstraint.constant
        }
        set {
            self.heightLayoutConstraint.constant = newValue
        }
    }
    
    private lazy var heightLayoutConstraint: NSLayoutConstraint = { [unowned self] in
        let constraint = self.heightAnchor.constraint(equalToConstant: self.isOpen ? self.maxHeight : self.handlerHeight)
        constraint.isActive = true
        return constraint
    }()
    
    open override var intrinsicContentSize: CGSize {
        if self.isOpen {
            return CGSize(width: 200, height: self.maxHeight + self.handlerHeight)
        } else {
            return CGSize(width: 200, height: self.handlerHeight)
        }
    }
    
    deinit {
        print("StickySlideView is deinited!")
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        setupFromCode(containerView: defaultContainerView)
    }
    
    public init(containerView: UIScrollView, maxHeight: CGFloat? = nil) {
        super.init(frame: CGRect.zero)
        setupFromCode(containerView: containerView, handlerHeight: handlerHeight, maxHeight: maxHeight)
    }
    
    public init(containerView: UIScrollView, handlerHeight: CGFloat? = nil, maxHeight: CGFloat? = nil) {
        super.init(frame: CGRect.zero)
        setupFromCode(containerView: containerView, handlerHeight: handlerHeight, maxHeight: maxHeight)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromCode()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        setup(containerView: self.containerView)
    }
    
    private func setupFromCode(containerView: UIScrollView? = nil, handlerHeight: CGFloat? = nil, maxHeight: CGFloat? = nil) {
        self.backgroundColor = UIColor.white
        setup(containerView: containerView, handlerHeight: handlerHeight, maxHeight: maxHeight)
    }
    
    private func setup(containerView: UIScrollView? = nil, handlerHeight: CGFloat? = nil, maxHeight: CGFloat? = nil) {
        if self.containerView == nil || self.containerView != containerView {
            if let containerView = containerView {
                self.containerView = containerView
                constraint(containerView: containerView)
            } else {
                self.containerView = defaultContainerView
                constraint(containerView: defaultContainerView)
            }
        }
        if let handlerHeight = handlerHeight {
            self.handlerHeight = handlerHeight
        }
        if let maxHeight = maxHeight {
            self.maxHeight = maxHeight
        }
        setupHandler()
        setupScroll()
    }
    
    private func constraint(containerView: UIScrollView) {
        containerView.removeFromSuperview()
        self.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func setupHandler() {
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.detectTapGesture(_:)))
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.detactPangesture(_:)))
        
        self.addGestureRecognizer(self.tapGesture)
        self.addGestureRecognizer(self.panGesture)
    }
    
    private func setupScroll() {
        self.scrollOffsetObserver = self.containerView
            .observe(\.contentOffset, options: [.new, .old]) { [weak self] (scrollView, change) in
                guard let newValue = change.newValue, let oldValue = change.oldValue else { return }
                self?.detectScroll(scrollView: scrollView, newOffset: newValue, oldOffset: oldValue)
            }
        self.containerView.panGestureRecognizer.addTarget(self, action: #selector(self.detectScrollPangesture(_:)))
    }
    
    private func detectScroll(scrollView: UIScrollView, newOffset: CGPoint, oldOffset: CGPoint) {
        if newOffset.y < 0 { // Bounce up
            let changedHeight = self.heightConstraint - (oldOffset.y - newOffset.y)
            if changedHeight > self.handlerHeight {
                self.heightConstraint = changedHeight
            }
            return
        }
        if newOffset.y - oldOffset.y > 0 {
            if newOffset.y > 0, self.heightConstraint < self.maxHeight { // Bounce로 확장 후 다시 아래로 스크롤 했을 경우
                scrollView.setContentOffset(CGPoint.zero, animated: false)
                self.heightConstraint = self.heightConstraint - (oldOffset.y - newOffset.y)
            }
        }
    }
    
    @objc private func detectScrollPangesture(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .ended {
            if self.heightConstraint > self.maxHeight {
                open()
            } else {
                if self.isOpen {
                    if self.heightConstraint > self.maxHeight / self.sensitive * (self.sensitive - 1) {
                        open()
                    } else {
                        close()
                    }
                } else {
                    if self.heightConstraint > self.maxHeight / self.sensitive {
                        open()
                    } else {
                        close()
                    }
                }
            }
        }
    }
    
    @objc private func detectTapGesture(_ recognizer: UITapGestureRecognizer) {
        toggle()
    }
    
    @objc private func detactPangesture(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            break
        case .changed:
            let transliation = recognizer.translation(in: self)
            let newHeight = self.heightConstraint - transliation.y
            if newHeight > self.handlerHeight, newHeight < self.maxHeight {
                self.heightConstraint = newHeight
            }
            recognizer.setTranslation(CGPoint.zero, in: self)
            break
        case .ended:
            // Velocity
            if abs(recognizer.velocity(in: self).y) > 0 {
                toggle()
                return
            }
            
            if self.heightConstraint > self.maxHeight {
                open()
            } else {
                if self.isOpen {
                    if self.heightConstraint > self.maxHeight / self.sensitive * (self.sensitive - 1) {
                        open()
                    } else {
                        close()
                    }
                } else {
                    if self.heightConstraint > self.maxHeight / self.sensitive {
                        open()
                    } else {
                        close()
                    }
                }
            }
            break
        default: break
        }
    }
    
    public func open() {
        self.heightConstraint = self.maxHeight
        self.isOpen = true
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.superview?.layoutIfNeeded()
        })
    }
    
    public func close() {
        self.heightConstraint = self.handlerHeight
        self.isOpen = false
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.superview?.layoutIfNeeded()
        })
    }
    
    public func toggle() {
        if self.isOpen {
            close()
        } else {
            open()
        }
    }
}
