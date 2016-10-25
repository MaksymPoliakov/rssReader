//
//  SideBar.swift
//  rssReader
//
//  Created by Maksym Poliakov on 23.10.16.
//  Copyright © 2016 Maksym Poliakov. All rights reserved.
//

import UIKit


@objc protocol SideBarDelegate {
    func sideBarDidSelectMenuButtonAtIndex(index:Int)
}

private let barWidth: CGFloat = 150.0
private let sideBarTableViewTopInset: CGFloat = 64.0


class SideBar: NSObject, SideBarControllerDelegate {

    let sideBarContainerView = UIView()
    var sideBarController: SideBarController!
    var isSideBarOpen: Bool = false
    var delegate: SideBarDelegate?
    var animator: UIDynamicAnimator?
    var origionView: UIView?
    
    
    override init() {
        super.init()
    }
    
    init(sourceView: UIView, delegate: SideBarDelegate, menuItems: [String]) {
        super.init()
        
        sideBarController = SideBarController()
        
        origionView = sourceView
        sideBarController.tableData = menuItems
        self.delegate = delegate
        
        setupSideBar()

        animator = UIDynamicAnimator(referenceView: origionView!)
        
        let showGestureRecognizer:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        showGestureRecognizer.direction = .right
        origionView!.addGestureRecognizer(showGestureRecognizer)
        
        let hideGestureRecognizer:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        hideGestureRecognizer.direction = .left
        
        origionView!.addGestureRecognizer(hideGestureRecognizer)
        
    }

    
    func setupSideBar() {
        
        sideBarContainerView.frame = CGRect(x: -barWidth-1, y: origionView!.frame.origin.y, width: barWidth, height: origionView!.frame.size.height)
        sideBarContainerView.backgroundColor = .clear
        sideBarContainerView.clipsToBounds = false
        
        origionView?.addSubview(sideBarContainerView)
        
        let blurView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.extraLight))
        blurView.frame = sideBarContainerView.bounds
        sideBarContainerView.addSubview(blurView)
        
        sideBarController.delegate = self
        sideBarController.tableView!.frame = sideBarContainerView.bounds
        sideBarController.tableView!.clipsToBounds = false
        sideBarController.tableView!.backgroundColor = .clear
        sideBarController.tableView!.scrollsToTop = false
        sideBarController.tableView!.contentInset = UIEdgeInsetsMake(sideBarTableViewTopInset, 0, 0, 0)
        
        sideBarController.tableView!.reloadData()
        
        sideBarContainerView.addSubview(sideBarController.tableView!)
    }

    func handleSwipe(recognizer:UISwipeGestureRecognizer){
        sideBarController.tableView!.reloadData()
        
        if recognizer.direction == UISwipeGestureRecognizerDirection.left{
            showSideBar(shouldOpen: false)
        }else{
            showSideBar(shouldOpen: true)
        }
    }
    
    func showSideBar(shouldOpen:Bool){
        animator?.removeAllBehaviors()
        isSideBarOpen = shouldOpen
        
        let gravityX: CGFloat = (shouldOpen) ? 1 : -1
        let magnitude: CGFloat = (shouldOpen) ? 50 : -50
        let boundaryX: CGFloat = (shouldOpen) ? barWidth : -barWidth - 1.0
        
        let gravityBehavior: UIGravityBehavior = UIGravityBehavior(items: [sideBarContainerView])
        gravityBehavior.gravityDirection = CGVector(dx: gravityX, dy: 0)
        animator?.addBehavior(gravityBehavior)
        
        
        let collisionBehavior: UICollisionBehavior = UICollisionBehavior(items: [sideBarContainerView])
        collisionBehavior.addBoundary(withIdentifier: "menuBoundary" as NSCopying, from: CGPoint(x: boundaryX, y: 20.0), to: CGPoint(x: boundaryX, y: origionView!.frame.size.height))
        animator?.addBehavior(collisionBehavior)
        
        
        let pushBehavior: UIPushBehavior = UIPushBehavior(items: [sideBarContainerView], mode: UIPushBehaviorMode.instantaneous)
        pushBehavior.magnitude = magnitude
        animator?.addBehavior(pushBehavior)
        
        let sideBarBehavior: UIDynamicItemBehavior = UIDynamicItemBehavior(items: [sideBarContainerView])
        sideBarBehavior.elasticity = 0.0
        animator?.addBehavior(sideBarBehavior)
        
    }
    
    func sideBarControllerDidSelectRow(index: Int) {
        delegate?.sideBarDidSelectMenuButtonAtIndex(index: index)
        showSideBar(shouldOpen: false)
    }

}
