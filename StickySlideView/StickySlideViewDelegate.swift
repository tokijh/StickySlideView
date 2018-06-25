//
//  StickySlideViewDelegate.swift
//  StickySlideView
//
//  Created by 윤중현 on 2018. 6. 23..
//  Copyright © 2018년 tokijh. All rights reserved.
//

public protocol StickySlideViewDelegate: class {
    func stickySlideView(_ stickySlideView: StickySlideView, didChangeOpenStatus isOpen: Bool)
    func stickySlideView(_ stickySlideView: StickySlideView, didChangeProgress progress: CGFloat)
    func stickySlideView(_ stickySlideView: StickySlideView, didChangeHeight height: CGFloat)
}

public extension StickySlideViewDelegate {
    func stickySlideView(_ stickySlideView: StickySlideView, didChangeOpenStatus isOpen: Bool) { }
    func stickySlideView(_ stickySlideView: StickySlideView, didChangeProgress progress: CGFloat) { }
    func stickySlideView(_ stickySlideView: StickySlideView, didChangeHeight height: CGFloat) { }
}
