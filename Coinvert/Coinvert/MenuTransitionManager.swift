//
//  MenuTransitionManager.swift
//  Menu
//
//  Created by JOSH HENDERSHOT on 10/10/14.
//  Copyright (c) 2014 Joshua Hendershot. All rights reserved.
//

import UIKit

class MenuTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    
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
        let menuViewController = !self.presenting ? screens.from as MenuViewController : screens.to as MenuViewController
        
        let bottomViewController = !self.presenting ? screens.to as UIViewController : screens.from as UIViewController
        
        let menuView = menuViewController.view
        let bottomView = bottomViewController.view
        
        // prepare menu items to slide in
        if (self.presenting){
            self.offStageMenuController(menuViewController)
        }
        
        // add the both views to our view controller
        container.addSubview(bottomView)
        container.addSubview(menuView)
        
        let duration = self.transitionDuration(transitionContext)
        
        // perform the animation!
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: nil, animations: {
            
                if (self.presenting){
                    self.onStageMenuController(menuViewController) // onstage items: slide in
                }
                else {
                    self.offStageMenuController(menuViewController) // offstage items: slide out
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
    
    func offStageMenuController(menuViewController: MenuViewController){
        
        menuViewController.view.alpha = 0
        
        // setup paramaters for 2D transitions for animations
        let topRowOffset  :CGFloat = 50
        let middleRowOffset :CGFloat = 150
        let bottomRowOffset  :CGFloat = 300
        
        menuViewController.bitcoinIcon.transform = self.offStage(-topRowOffset)
        menuViewController.bitcoinLabel.transform = self.offStage(-topRowOffset)
        
        menuViewController.litecoinIcon.transform = self.offStage(-middleRowOffset)
        menuViewController.litecoinLabel.transform = self.offStage(-middleRowOffset)
        
        menuViewController.darcoinIcon.transform = self.offStage(topRowOffset)
        menuViewController.darkcoinLabel.transform = self.offStage(topRowOffset)
        
        menuViewController.dogecoinIcon.transform = self.offStage(middleRowOffset)
        menuViewController.dogecoinLabel.transform = self.offStage(middleRowOffset)
       
        
        
    }
    
    func onStageMenuController(menuViewController: MenuViewController){
        
        // prepare menu to fade in
        menuViewController.view.alpha = 1
        
        menuViewController.bitcoinIcon.transform = CGAffineTransformIdentity
        menuViewController.bitcoinLabel.transform = CGAffineTransformIdentity
        
        menuViewController.litecoinIcon.transform = CGAffineTransformIdentity
        menuViewController.litecoinLabel.transform = CGAffineTransformIdentity
        
        menuViewController.darcoinIcon.transform = CGAffineTransformIdentity
        menuViewController.darkcoinLabel.transform = CGAffineTransformIdentity
        
        menuViewController.dogecoinIcon.transform = CGAffineTransformIdentity
        menuViewController.dogecoinLabel.transform = CGAffineTransformIdentity

        
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
