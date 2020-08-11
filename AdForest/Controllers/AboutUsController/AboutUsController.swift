//
//  AboutUsController.swift
//  AdForest
//
//  Created by Rajeev Lochan Ranga on 07/07/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class AboutUsController: UIViewController {

    @IBOutlet weak var lbl_aboutUs: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "About Us"
        self.getAboutUsDetails()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addLeftBarButtonWithImage(#imageLiteral(resourceName: "menu"))

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAboutUsDetails() {
        let url = "http://boobur.com/wp-json/wp/v2/pages/2"
        
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dict = successResponse as! [String: Any]
          
            if let str = dict["content"] as? [String: Any] {
                if let result = str["rendered"] as? String {
                   
                    self.lbl_aboutUs.attributedText = result.html2AttributedString
                }
            }

            
        }) { (error) in
            let alert = AlertView.prepare(title: "", message: error.message, okAction: {
            })
            self.presentVC(alert)        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
