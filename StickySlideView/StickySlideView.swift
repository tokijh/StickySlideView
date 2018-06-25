//
//  StickySlideView.swift
//  StickySlideView
//
//  Created by  Joonghyun-Yoon on 2018. 6. 20..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import UIKit

@IBDesignable
open class StickySlideView: UIView {
    
    @IBOutlet weak open private(set) var containerView: UIScrollView! {
        willSet {
            self.containerView?.panGestureRecognizer.removeTarget(self, action: #selector(self.detectScrollPanGesture(_:)))
            self.scrollOffsetObserver?.invalidate()
            self.scrollOffsetObserver = nil
        }
    }
    
    private lazy var defaultContainerView: UIScrollView = UIScrollView()
    
    @IBInspectable open var handlerHeight: CGFloat = 32 {
        willSet {
            if newValue < 0 {
                fatalError("handlerHeight must be a positive number")
            }
        }
        didSet {
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }
    @IBInspectable open var maxHeight: CGFloat = 400 {
        willSet {
            if newValue < 0 {
                fatalError("maxHeight must be a positive number")
            }
            if newValue - self.handlerHeight < 0 {
                fatalError("maxHeight can not be smaller then handlerHeight")
            }
        }
        didSet {
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }
    @IBInspectable open var isOpen: Bool = false {
        didSet {
            setNeedsLayout()
            invalidateIntrinsicContentSize()
            if oldValue != self.isOpen {
                self.delegate?.stickySlideView(self, didChangeOpenStatus: self.isOpen)
            }
            self.blockDidSetHeight = true
            self.progress = self.isOpen ? 1.0 : 0.0
        }
    }
    @IBInspectable open var sensitive: CGFloat = 8 {
        didSet {
            if self.sensitive < 1 {
                self.sensitive = 0
            }
        }
    }
    @IBInspectable open var animationSpeed: Double = 0.2 {
        willSet {
            if newValue < 0 {
                fatalError("animationSpeed must be a positive number")
            }
        }
    }
    public var progress: CGFloat {
        get {
            if self.height >= self.maxHeight {
                return 1.0
            } else if self.height <= self.handlerHeight {
                return 0.0
            }
            return self.height / self.maxHeight
        }
        set {
            if newValue <= 0 {
                self.height = self.handlerHeight
            } else {
                let newHeight = ((self.maxHeight - self.handlerHeight) * newValue) + self.handlerHeight
                self.height = newHeight > self.maxHeight ? self.maxHeight : newHeight
            }
        }
    }
    open private(set) var height: CGFloat = 0 {
        didSet {
            if !self.blockDidSetHeight {
                if self.height >= 0 {
                    self.heightConstraint = self.height
                }
            }
            self.blockDidSetHeight = false
            if !self.blockDelegateHeight/*, oldValue != height */{
                self.delegate?.stickySlideView(self, didChangeHeight: self.height)
                self.delegate?.stickySlideView(self, didChangeProgress: self.progress)
            }
            self.blockDelegateHeight = false
        }
    }
    
    public weak var delegate: StickySlideViewDelegate?
    
    private var tapGesture: UITapGestureRecognizer!
    private var panGesture: UIPanGestureRecognizer!
    private var scrollOffsetObserver: NSKeyValueObservation?
    
    private var blockDidSetHeight: Bool = false
    private var blockDelegateHeight: Bool = false
    
    private var heightConstraint: CGFloat {
        get {
            return self.heightLayoutConstraint.constant
        }
        set {
            self.blockDidSetHeight = true
            self.heightLayoutConstraint.constant = newValue
            self.height = newValue
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
    
    public init() {
        super.init(frame: CGRect.zero)
        setupFromCode(containerView: self.defaultContainerView)
    }
    
    public init(containerView: UIScrollView, maxHeight: CGFloat? = nil) {
        super.init(frame: CGRect.zero)
        setupFromCode(containerView: containerView, handlerHeight: self.handlerHeight, maxHeight: maxHeight)
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
                self.containerView = self.defaultContainerView
                constraint(containerView: self.defaultContainerView)
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
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.detactPanGesture(_:)))
        
        self.addGestureRecognizer(self.tapGesture)
        self.addGestureRecognizer(self.panGesture)
        
        UIView.setAnimationDelegate(self)
    }
    
    private func setupScroll() {
        self.scrollOffsetObserver = self.containerView
            .observe(\.contentOffset, options: [.new, .old]) { [weak self] (scrollView, change) in
                guard let newValue = change.newValue, let oldValue = change.oldValue else { return }
                self?.detectScroll(scrollView: scrollView, newOffset: newValue, oldOffset: oldValue)
            }
        self.containerView.panGestureRecognizer.addTarget(self, action: #selector(self.detectScrollPanGesture(_:)))
    }
    
    private func detectScroll(scrollView: UIScrollView, newOffset: CGPoint, oldOffset: CGPoint) {
        if newOffset.y < 0 { // Bounce up
            if scrollView.panGestureRecognizer.velocity(in: scrollView).y > 0 {
                let changedHeight = self.heightConstraint - (oldOffset.y - newOffset.y)
                if changedHeight > self.handlerHeight {
                    self.heightConstraint = changedHeight
                }
            }
        } else if newOffset.y - oldOffset.y > 0 { // Scroll down
            if newOffset.y > 0, self.heightConstraint < self.maxHeight { // Bounce로 확장 후 다시 아래로 스크롤 한 경우
                scrollView.setContentOffset(CGPoint.zero, animated: false)
                let distance = oldOffset.y - newOffset.y
                if distance != 0 {
                    self.heightConstraint = self.heightConstraint - distance
                }
            }
        }
    }
    
    @objc private func detectTapGesture(_ recognizer: UITapGestureRecognizer) {
        toggle()
    }
    
    @objc private func detactPanGesture(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            let transliation = recognizer.translation(in: self)
            let newHeight = self.heightConstraint - transliation.y
            if newHeight > self.handlerHeight, newHeight < self.maxHeight {
                self.heightConstraint = newHeight
            }
            recognizer.setTranslation(CGPoint.zero, in: self)
        case .ended:
            updateStatus()
        default: break
        }
    }
    
    @objc private func detectScrollPanGesture(_ recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .ended {
            updateStatus()
        }
    }
    
    private func updateStatus() {
        if self.heightConstraint > self.maxHeight {
            open()
        } else if self.heightConstraint != self.maxHeight, self.heightConstraint != self.handlerHeight {
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
    
    public func open() {
        self.openTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.detectOpenAnimationTime), userInfo: nil, repeats: true)
        self.blockDelegateHeight = true
        self.heightConstraint = self.maxHeight
        UIView.animate(
            withDuration: self.animationSpeed,
            animations: {
                self.superview?.layoutIfNeeded()
            },
            completion: { success in
                if success {
                    self.openTimer = nil
                    self.isOpen = true
                }
            })
    }
    
    public func close() {
        self.containerView.setContentOffset(CGPoint.zero, animated: true)
        
        self.closeTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.detectCloseAnimationTime), userInfo: nil, repeats: true)
        self.blockDelegateHeight = true
        self.heightConstraint = self.handlerHeight
        UIView.animate(
            withDuration: self.animationSpeed,
            animations: {
                self.superview?.layoutIfNeeded()
            }, completion: { success in
                if success {
                    self.closeTimer = nil
                    self.isOpen = false
                }
            })
    }
    
    public func toggle() {
        if self.isOpen {
            close()
        } else {
            open()
        }
    }
    
    private var preOpenProgress: CGFloat = 0.0
    private var openAnimationProgress: CGFloat = 0.0
    private var openTimer: Timer? {
        didSet {
            oldValue?.invalidate()
            self.preOpenProgress = self.progress
            self.openAnimationProgress = 0.0
        }
    }
    private var preCloseProgress: CGFloat = 0.0
    private var closeAnimationProgress: CGFloat = 0.0
    private var closeTimer: Timer? {
        didSet {
            oldValue?.invalidate()
            self.preCloseProgress = self.progress
            self.closeAnimationProgress = 0.0
        }
    }
    
    @objc private func detectOpenAnimationTime() {
        self.closeTimer = nil
        self.openAnimationProgress += 1
        var timerProgress = self.openAnimationProgress / CGFloat(self.animationSpeed * 1000)
        if timerProgress > 1.0 {
            timerProgress = 1.0
        }
        self.blockDidSetHeight = true
        self.progress = preOpenProgress + (1.0 - preOpenProgress) * timerProgress
    }
    
    @objc private func detectCloseAnimationTime() {
        self.openTimer = nil
        self.closeAnimationProgress += 1
        let timerProgress = self.closeAnimationProgress / CGFloat(self.animationSpeed * 1000)
        self.blockDidSetHeight = true
        self.progress = preCloseProgress - (preCloseProgress) * timerProgress
    }
}
