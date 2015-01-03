//
//  MenuTransitionManager.swift
//  Menu
//
//  Created by Mathew Sanders on 9/7/14.
//  Copyright (c) 2014 Mat. All rights reserved.
//

import UIKit

class MenuTransitionManager2: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
    private var presenting = false
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    // animate a change from one viewcontroller to another
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView()
        
        // create a tuple of our screens
        let screens : (from:UIViewController, to:UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        
        // assign references to our menu view controller and the 'bottom' view controller from the tuple
        // remember that our menuViewController will alternate between the from and to view controller depending if we're presenting or dismissing
        let menuViewController2 = !self.presenting ? screens.from as MenuViewController2 : screens.to as MenuViewController2
        
        let bottomViewController = !self.presenting ? screens.to as UIViewController : screens.from as UIViewController
        
        let menuView = menuViewController2.view
        let bottomView = bottomViewController.view
        
        // prepare menu items to slide in
        if (self.presenting){
            self.offStageMenuController(menuViewController2)
        }
        
        // add the both views to our view controller
        container.addSubview(bottomView)
        container.addSubview(menuView)
        
        let duration = self.transitionDuration(transitionContext)
        
        // perform the animation!
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: nil, animations: {
            
            if (self.presenting){
                self.onStageMenuController(menuViewController2) // onstage items: slide in
            }
                else {
                    self.offStageMenuController(menuViewController2) // offstage items: slide out
                }

            }, completion: { finished in
                
                // tell our transitionContext object that we've finished animating
                transitionContext.completeTransition(true)
                
                // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
                UIApplication.sharedApplication().keyWindow!.addSubview(screens.to.view)
                
        })
        
    }
    
    func offStage(amount: CGFloat) -> CGAffineTransform {
        return CGAffineTransformMakeTranslation(amount, 0)
    }
    
    func offStageMenuController(menuViewController: MenuViewController2){
        
        menuViewController.view.alpha = 0
        
        // setup paramaters for 2D transitions for animations
        let topRowOffset  :CGFloat = 111
        let middle1RowOffset :CGFloat = 223
        let middle2RowOffset :CGFloat = 334
        let bottomRowOffset  :CGFloat = 446
        
        menuViewController.bitcoinIcon2.transform = self.offStage(bottomRowOffset)
        menuViewController.bitcoinLabel2.transform = self.offStage(bottomRowOffset)
        
        menuViewController.litecoinIcon2.transform = self.offStage(bottomRowOffset)
        menuViewController.litecoinLabel2.transform = self.offStage(bottomRowOffset)
        
        menuViewController.dogecoinIcon2.transform = self.offStage(middle2RowOffset)
        menuViewController.dogecoinLabel2.transform = self.offStage(middle2RowOffset)
        
//        menuViewController.darcoinIcon2.transform = self.offStage(-middle2RowOffset)
//        menuViewController.darkcoinLabel2.transform = self.offStage(-middle2RowOffset)
//        
//        menuViewController.feathercoinIcon2.transform = self.offStage(-middle1RowOffset)
//        menuViewController.feathercoinLabel2.transform = self.offStage(-middle1RowOffset)
//        
//        menuViewController.namecoinIcon2.transform = self.offStage(middle1RowOffset)
//        menuViewController.namecoinLabel2.transform = self.offStage(middle1RowOffset)
//        
//        menuViewController.peercoinIcon2.transform = self.offStage(-topRowOffset)
//        menuViewController.peercoinLabel2.transform = self.offStage(-topRowOffset)
//        
//        menuViewController.blackcoinIcon2.transform = self.offStage(topRowOffset)
//        menuViewController.blackcoinLabel2.transform = self.offStage(topRowOffset)
       
        
        
    }
    
    func onStageMenuController(menuViewController: MenuViewController2){
        
        // prepare menu to fade in
        menuViewController.view.alpha = 1
        
        menuViewController.bitcoinIcon2.transform = CGAffineTransformIdentity
        menuViewController.bitcoinLabel2.transform = CGAffineTransformIdentity
        
        menuViewController.litecoinIcon2.transform = CGAffineTransformIdentity
        menuViewController.litecoinLabel2.transform = CGAffineTransformIdentity
        
        menuViewController.dogecoinIcon2.transform = CGAffineTransformIdentity
        menuViewController.dogecoinLabel2.transform = CGAffineTransformIdentity
        
//        menuViewController.darcoinIcon2.transform = CGAffineTransformIdentity
//        menuViewController.darkcoinLabel2.transform = CGAffineTransformIdentity
//
//        menuViewController.feathercoinIcon2.transform = CGAffineTransformIdentity
//        menuViewController.feathercoinLabel2.transform = CGAffineTransformIdentity
//        
//        menuViewController.namecoinIcon2.transform = CGAffineTransformIdentity
//        menuViewController.namecoinLabel2.transform = CGAffineTransformIdentity
//        
//        menuViewController.peercoinIcon2.transform = CGAffineTransformIdentity
//        menuViewController.peercoinLabel2.transform = CGAffineTransformIdentity
//        
//        menuViewController.blackcoinIcon2.transform = CGAffineTransformIdentity
//        menuViewController.blackcoinLabel2.transform = CGAffineTransformIdentity

        
    }
    
    // return how many seconds the transiton animation will take
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.6
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    // return the animataor when presenting a viewcontroller
    // rememeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
}
