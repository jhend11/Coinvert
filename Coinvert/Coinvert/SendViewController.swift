//
//  SendViewController.swift
//  Coinvert
//
//  Created by JOSH HENDERSHOT on 11/18/14.
//  Copyright (c) 2014 Joshua Hendershot. All rights reserved.
//

import UIKit

class SendViewController: UIViewController {
    var fromCoinString2: String!
    var toCoinString2: String!
    var depositAmount: Float!
    var withDrawalString: String!
    
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var depositAddressLabel: UILabel!
    @IBOutlet weak var withdrawalAddressLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        depositAddressLabel.text = "LNsJKWYhz3tswFrEzDddwYALAtmpCQdX2A"
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        qrCodeImageView.image = UIImage.mdQRCodeForString(depositAddressLabel.text, size: qrCodeImageView.bounds.size.width)
        self.view.addSubview(qrCodeImageView)
        var string = "\(fromCoinString2)_\(toCoinString2)"
        
        println(withdrawalAddressLabel.text)
        println(fromCoinString2)
        println(toCoinString2)
        println(string)

        println(depositAmount)
        withdrawalAddressLabel.text = withDrawalString
        var stringy = "\(depositAmount)"
        let s2 = withdrawalAddressLabel.text

        var params: [String:String]
        var shapeshiftURL: String!
        
        //MARK: JSON POST
        
        
        if depositAmount != nil {
            let s = NSString(format: "%f", depositAmount)
            params = ["amount":s as String!, "withdrawal":s2 as String!, "pair": "\(fromCoinString2)_\(toCoinString2)"] as Dictionary
            shapeshiftURL = "http://shapeshift.io/sendamount"
        } else {
            
            params = ["withdrawal":s2 as String!, "pair": "\(fromCoinString2)_\(toCoinString2)"] as Dictionary
            shapeshiftURL = "http://shapeshift.io/shift"

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
            
            var err: NSError?
            
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as NSDictionary
            
            // json = {"response":"Success","msg":"User login successfully."}
            if((err) != nil) {
                
                println(err!.localizedDescription)
                
            }
                
            else {
                
                var success = json["response"] as? String
                
                println("Succes: \(success)")
                
                
                
                if json["response"] as NSString == "success"
                    
                {
                    
                    println("Login Successfull")
                    
                }
                
//                self.responseMsg=json["msg"] as String
                
                dispatch_async(dispatch_get_main_queue(), {
                    
//                    self.loginStatusLB.text=self.responseMsg
                    
                })
                
                
                
            }
            
        })
        
        task.resume()

        
        

    }
    @IBAction func qrGenerate(sender: AnyObject) {
        qrCodeImageView.image = UIImage.mdQRCodeForString(depositAddressLabel.text, size: qrCodeImageView.bounds.size.width)
        self.view.addSubview(qrCodeImageView)
    }
    
    
}
