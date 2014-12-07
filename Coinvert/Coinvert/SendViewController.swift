//
//  SendViewController.swift
//  Coinvert
//
//  Created by JOSH HENDERSHOT on 11/18/14.
//  Copyright (c) 2014 Joshua Hendershot. All rights reserved.
//

import UIKit

class SendViewController: UIViewController {
    var pendingTransaction: Bool!
    var coinsReceived: Bool!
    var secondsLeft: Int!
    var minutes, seconds: Int!
    var textField: UITextField!
    var fromCoinString2: String!
    var toCoinString2: String!
    var depositAddressString: String!
    var depositAmount: Float!
    var withDrawalString: String!
    var txIdForReciept: String!
    var timer1 = NSTimer?()
    var transactionTimer = NSTimer?()
    var timer2 = NSTimer?()
    var timer3 = NSTimer?()
    var emailAddressForReciept: String!
    
    var nc = NSNotificationCenter.defaultCenter()
    
    
    @IBOutlet weak var fixedAmountCover: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var transactionStatusLabel: UILabel!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var depositAddressLabel: UILabel!
    @IBOutlet weak var withdrawalAddressLabel: UILabel!
    
    @IBOutlet weak var copyDepositAddressButton: UIButton!
    
    @IBOutlet weak var sendAmountLabel: UILabel!
    @IBOutlet weak var copySendAmountButton: UIButton!
    @IBOutlet weak var depositAddressPopup: UIView!
    
    @IBOutlet weak var toCoinImageView: UIImageView!
    @IBOutlet weak var fromCoinImageView: UIImageView!
    @IBOutlet weak var depositAmountPopup: UIView!
    @IBOutlet weak var sendStringLabel: UILabel!
    @IBOutlet weak var sendCoinsToLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        depositAmountPopup.hidden = true
        depositAddressPopup.hidden = true
        copySendAmountButton.hidden = true
        fromCoinImageView.hidden = true
        toCoinImageView.hidden = true
        coinsReceived = false
        checkCoinViews()
        sendCoinsToLabel.text = "Send \(fromCoinString2.uppercaseString) to:"
        resetTimerwithSpeed(6)

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
  
        
        pendingTransaction = true
        animateCoins()

        qrCodeImageView.image = UIImage.mdQRCodeForString(depositAddressLabel.text, size: qrCodeImageView.bounds.size.width)
        self.view.addSubview(qrCodeImageView)
        
        
        
        var string = "\(fromCoinString2)_\(toCoinString2)"
        println(withdrawalAddressLabel.text!)
        println(fromCoinString2)
        println(toCoinString2)
        println(string)
        
        println(depositAmount)
        withdrawalAddressLabel.text = withDrawalString
        var stringy = "\(depositAmount)"
        let s2 = withdrawalAddressLabel.text!
        
        var params: [String:String]
        var shapeshiftURL: String!
        
        
        //MARK: JSON POST
        
        nc.addObserverForName("appEnteredForeground", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification:NSNotification!) -> Void in
            
            if self.depositAmount != nil && self.coinsReceived == false {
                self.checkTimeRemaining()
            } else if self.depositAmount != nil && self.coinsReceived == true {
                self.checkTransactionStatus()
                println("this just might work")
            }
        })
        
        if depositAmount != nil {
            let s = NSString(format: "%f", depositAmount)
            params = ["amount":s as String!, "withdrawal":s2 as String!, "pair": "\(fromCoinString2)_\(toCoinString2)"] as Dictionary
            shapeshiftURL = "https://shapeshift.io/sendamount"
            fixedAmountCover.removeFromSuperview()
            copySendAmountButton.hidden = false
sendStringLabel.text = fromCoinString2.uppercaseString
            
        } else {
            
            params = ["withdrawal":s2 as String!, "pair": "\(fromCoinString2)_\(toCoinString2)"] as Dictionary
            shapeshiftURL = "https://shapeshift.io/shift"
            
        }
        
        var request = NSMutableURLRequest(URL: NSURL(string: shapeshiftURL)!)
        
        var session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        
        
        println(params)
        
        var err: NSError?
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            println("Response: \(response)")
            
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            println("Body: \(strData)\n\n")
            
            
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as NSDictionary
            
            
            if json["error"] != nil {
                
                var alert = UIAlertController(title: "Uh-Oh!", message: json["error"] as String + ".", preferredStyle: UIAlertControllerStyle.Alert)
                
                
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler:self.handleCancel))
                
                self.presentViewController(alert, animated: true, completion: {
                })
                
            }
                
            else {
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if self.depositAmount != nil {
                        self.depositAddressString = json["success"]!["deposit"] as String!
                        self.sendAmountLabel.text = json["success"]!["depositAmount"] as String!
                        self.checkTimeRemaining()
                        
                    }
                    else  {
                        self.depositAddressString = json["deposit"] as String!
                        
                    }
                    println(self.depositAddressString)
                    
                    self.depositAddressLabel.text = self.depositAddressString
                    self.qrCodeImageView.image = UIImage.mdQRCodeForString(self.depositAddressLabel.text, size: self.qrCodeImageView.bounds.size.width)
                    self.view.addSubview(self.qrCodeImageView)
                    
                    
                })
                
                
                
                
            }
            
        })
        
        task.resume()
        checkTransactionStatus()
        
    }
    
    func checkTransactionStatus() {
        
        if pendingTransaction == true {
            
            let urlAsString = "https://shapeshift.io/txStat/\(depositAddressString)"
            let url = NSURL(string: urlAsString)!
            let urlSession = NSURLSession.sharedSession()
            
            let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
                if (error != nil) {
                    println(error.localizedDescription)
                }
                var err: NSError?
                
                
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                if (err != nil) {
                    println("JSON Error \(err!.localizedDescription)")
                }
                
                if jsonResult["status"] != nil {
                    
                    
                    var results = jsonResult["status"] as String!
                    
                    
                    if results == "received" {
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.transactionStatusLabel.layer.removeAllAnimations()
                            
                            self.transactionStatusLabel.text = "Received"
                            self.transactionStatusLabel.textColor = UIColor.redColor()
                            if self.timer2 != nil { self.timer2!.invalidate() }
                            self.timeLabel.text = "N/A"
                            
                            self.coinsReceived == true
                            
                            UIView.animateWithDuration(3, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                                self.transactionStatusLabel.alpha = 1
                                
                                }) { (Bool) -> Void in
                                    UIView.animateWithDuration(3, animations: { () -> Void in
                                        self.transactionStatusLabel.alpha = 0
                                        
                                    })
                            }
                        })
                        
                    } else if results == "complete" {
                        
                        self.txIdForReciept = jsonResult["transaction"] as String!
                        self.transactionStatusLabel.text = "Complete"
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            var alert = UIAlertController(title: "Coinversion complete!", message: "Would you like a receipt?   Enter e-mail address below.", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            alert.addTextFieldWithConfigurationHandler(self.configurationTextField)
                            
                            alert.addAction(UIAlertAction(title: "No Thanks", style: UIAlertActionStyle.Cancel, handler:self.handleCancel))
                            alert.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                                
                                self.emailAddressForReciept = ((alert.textFields![0] as UITextField).text)

                                self.sendEmailReceipt(3)
                            }))
                            self.presentViewController(alert, animated: true, completion: {
                            })
                            
                        })
                        
                        
                    } else if results == "failed" {
                        self.transactionStatusLabel.text = "Failed"
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            var alert = UIAlertController(title: "Coinversion failed", message: "Lets try again!", preferredStyle: UIAlertControllerStyle.Alert)
                            
                            alert.addTextFieldWithConfigurationHandler(self.configurationTextField)
                            
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler:self.handleCancel))
                            
                            self.presentViewController(alert, animated: true, completion: {
                            })
                            
                        })
                        
                        
                    } else if results == "no_deposits" {
                        println("checked status: no deposits")
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.transactionStatusLabel.layer.removeAllAnimations()

                        self.transactionStatusLabel.text = "Waiting"
                        self.transactionStatusLabel.textColor = UIColor.whiteColor()
                            
                        UIView.animateWithDuration(3, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                            self.transactionStatusLabel.alpha = 1
                            
                            }) { (Bool) -> Void in
                                UIView.animateWithDuration(3, animations: { () -> Void in
                                    self.transactionStatusLabel.alpha = 0

                                })
                        }
                        })
                        
                    }
                    
                    
                }
            })
            
            jsonQuery.resume()
        }
    }
    
    func resetTimerwithSpeed(speed: Double) {
        
        if timer1 != nil { timer1!.invalidate() }
        
        timer1 = NSTimer.scheduledTimerWithTimeInterval(speed, target: self, selector: Selector("timerDone"), userInfo: nil, repeats: false)
    }
    
    func timerDone() {
        resetTimerwithSpeed(6)
        checkTransactionStatus()
    }
    func timerDone2() {
        
        var  params = ["email":emailAddressForReciept, "txid": txIdForReciept] as Dictionary
        var  shapeshiftURL = "https://shapeshift.io/mail"
        
        
        
        var request = NSMutableURLRequest(URL: NSURL(string: shapeshiftURL)!)
        
        var session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        
        
        println(params)
        
        var err: NSError?
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            var err: NSError?
            
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as NSDictionary
            
            if((err) != nil) {
                
                println(err!.localizedDescription)
                
            }
            
            
        })
        
        task.resume()
        transactionTimeOut()

    }
    
    func configurationTextField(textField: UITextField!)
    {
        
        if let tField = textField {
            textField.keyboardType = UIKeyboardType.EmailAddress
            
            self.textField = textField!
        }
    }
    
    
    func handleCancel(alertView: UIAlertAction!)
    {
        transactionTimeOut()
    }
    
    func sendEmailReceipt(speed: Double) {
        if timer3 != nil { timer3!.invalidate() }
        
        timer3 = NSTimer.scheduledTimerWithTimeInterval(speed, target: self, selector: Selector("timerDone2"), userInfo: nil, repeats: false)
        println(self.emailAddressForReciept)

    }
    
    func checkTimeRemaining() {
        
        let urlAsString = "https://shapeshift.io/timeremaining/\(depositAddressString)"
        let url = NSURL(string: urlAsString)!
        let urlSession = NSURLSession.sharedSession()
        println(urlAsString)
        
        let jsonQuery = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            
            
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if (err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
            
            println(jsonResult["status"])
            
            if jsonResult["status"] as String == "pending" {
                
                var jsonDate: String! = jsonResult["seconds_remaining"] as String
                println(jsonDate)
                
                
                let numberFormatter = NSNumberFormatter()
                let number = numberFormatter.numberFromString(jsonDate)
                
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.secondsLeft = number as Int
                    self.countdown()
                    
                    
                })
            } else if jsonResult["status"] as String == "expired" {
                println("right before everything breaks")
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
                    println("right before everything breaks1")

                    println("right before everything breaks2")
                    self.timeLabel.text = "N/A"
                    if self.timer2 != nil { self.timer2!.invalidate() }

                    var alert = UIAlertController(title: "Coinversion Expired", message: "Your current Coinversion has expired. If you still wish you exchange coins, you must begin a new Coinversion.", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler:self.handleCancel))
                    
                    
                    self.presentViewController(alert, animated: true, completion: {})
                    
                })
            } else if jsonResult["status"] == nil {
                self.checkTimeRemaining()
                println("somethingwrong with shapeshift")
            }
            
        })
        
        jsonQuery.resume()
        
    }
    func transactionTimeOut() {
        pendingTransaction = false
        nc.postNotificationName("resetCoinvert", object: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    @IBAction func copyDepositButtonWasPressed(sender: AnyObject) {
        
        UIPasteboard.generalPasteboard().string = depositAddressString as String
        self.depositAddressPopup.hidden = false
        self.depositAddressPopup.alpha = 1
        
        UIView.animateWithDuration(0.5, delay: 1, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            self.depositAddressPopup.alpha = 0.0
            }) { (Bool) -> Void in
                
                self.depositAddressPopup.hidden = true
                
        }
        
    }
    
    @IBAction func copySendAmountButtonWasPressed(sender: AnyObject) {
        UIPasteboard.generalPasteboard().string = sendAmountLabel.text
        self.depositAmountPopup.hidden = false
        self.depositAmountPopup.alpha = 1
        
        UIView.animateWithDuration(0.5, delay: 1, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            self.depositAmountPopup.alpha = 0.0
            }) { (Bool) -> Void in
                
                self.depositAmountPopup.hidden = true
        }
        
    }
    
    @IBAction func cxlButtonWasPressed(sender: AnyObject) {
        
        var alert = UIAlertController(title: "Cancel Coinversion", message: "Cancel current Coinversion?", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Cancel, handler:self.handleCancel))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler:nil))
        
        
        self.presentViewController(alert, animated: true, completion: {
        })
    }
    func updateTime() {
        if secondsLeft > 1 {
            secondsLeft!--
            minutes = (secondsLeft % 3600) / 60
            seconds = (secondsLeft % 3600) % 60
            timeLabel.text = NSString(format: "%02d:%02d", minutes, seconds)
            timeLabel.textColor = UIColor.redColor()
            println("label should update")
            
        } else {
            
            transactionTimeOut()
        }
        
    }
    func countdown() {
        
        if timer2 != nil { timer2!.invalidate() }
        
        timer2 = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
    }
    
    func checkCoinViews() {
        
        if fromCoinString2 == "btc" {
            fromCoinImageView.image = UIImage(named: "bitcoin")
            
            
        } else if fromCoinString2 == "ltc" {
            fromCoinImageView.image = UIImage(named: "litecoin")
            
            
        } else if fromCoinString2 == "drk" {
            fromCoinImageView.image = UIImage(named: "darkcoin")
           
            
        } else if fromCoinString2 == "doge" {
            fromCoinImageView.image = UIImage(named: "dogecoin")
           
            
        } else if fromCoinString2 == "ftc" {
            fromCoinImageView.image = UIImage(named: "feathercoin")
          
            
        } else if fromCoinString2 == "nmc" {
            fromCoinImageView.image = UIImage(named: "namecoin")
            
            
        } else if fromCoinString2 == "ppc" {
            fromCoinImageView.image = UIImage(named: "peercoin")
            
            
        } else if fromCoinString2 == "bc" {
            fromCoinImageView.image = UIImage(named: "blackcoin")
            
        }
        
        /// checking to coins
        
        
        if toCoinString2 == "btc" {
            toCoinImageView.image = UIImage(named: "bitcoin")
            
            
        } else if toCoinString2 == "ltc" {
            toCoinImageView.image = UIImage(named: "litecoin")
            
            
        } else if toCoinString2 == "drk" {
            toCoinImageView.image = UIImage(named: "darkcoin")
            
            
        } else if toCoinString2 == "doge" {
            toCoinImageView.image = UIImage(named: "dogecoin")
            
            
        } else if toCoinString2 == "ftc" {
            toCoinImageView.image = UIImage(named: "feathercoin")
            
            
        } else if toCoinString2 == "nmc" {
            toCoinImageView.image = UIImage(named: "namecoin")
            
            
        } else if toCoinString2 == "ppc" {
            toCoinImageView.image = UIImage(named: "peercoin")
            
            
        } else if toCoinString2 == "bc" {
            toCoinImageView.image = UIImage(named: "blackcoin")
            
        }

    }
    func animateCoins() {
        
        if pendingTransaction == true {
            
            fromCoinImageView.frame = CGRectMake(-50, 272, 50, 50)
            fromCoinImageView.alpha = 1
fromCoinImageView.hidden = false
            
            UIView.animateWithDuration(4, delay: 0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
                self.fromCoinImageView.frame = CGRectMake(162, 272, 50, 50)
                }) { (Bool) -> Void in
                    
                    self.toCoinImageView.frame = CGRectMake(162, 272, 50, 50)
                    self.toCoinImageView.alpha = 0
                    self.toCoinImageView.hidden = false
                    
                    UIView.animateWithDuration(0.75, delay: 0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
                        self.toCoinImageView.alpha = 1
                        self.fromCoinImageView.alpha = 0
                        }) { (Bool) -> Void in
                            
                            
                            
                            
                            UIView.animateWithDuration(4, delay: 0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
                                self.toCoinImageView.frame = CGRectMake(376, 272, 50, 50)

                                }) { (Bool) -> Void in
                                    
                                    self.animateCoins()
                                    
                                    
                            }
                            
                    }
                    
                    
            }
            
        } else {
            
        }
    }
}
