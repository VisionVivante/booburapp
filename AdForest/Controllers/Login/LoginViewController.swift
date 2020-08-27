//
//  LoginViewController.swift
//  Adforest
//
//  Created by apple on 1/2/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import NVActivityIndicatorView
import SDWebImage
import AuthenticationServices

class LoginViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable, GIDSignInUIDelegate, GIDSignInDelegate , UIScrollViewDelegate{
    
    var first_name = String()
    var last_name =  String()
    var email =  String()
    var my_id = String()
    
    
    
    //MARK:- Outlets
    @IBOutlet weak var appleLoginView: UIView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.isScrollEnabled = false
        }
    }
    @IBOutlet weak var containerViewImage: UIView!
    
    
    @IBOutlet weak var imgTitle: UIImageView!
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var txtEmail: UITextField! {
        didSet {
            txtEmail.delegate = self
        }
    }
    @IBOutlet weak var imgPassword: UIImageView!
    @IBOutlet weak var txtPassword: UITextField! {
        didSet {
            txtPassword.delegate = self
        }
    }
    @IBOutlet weak var buttonForgotPassword: UIButton!
    @IBOutlet weak var buttonSubmit: UIButton! {
        didSet {
            buttonSubmit.roundCorners()
            buttonSubmit.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var buttonFBLogin: UIButton! {
        didSet {
            buttonFBLogin.roundCorners()
            buttonFBLogin.isHidden = true
        }
    }
    @IBOutlet weak var buttonGoogleLogin: UIButton! {
        didSet {
            buttonGoogleLogin.roundCorners()
            buttonGoogleLogin.isHidden = true
        }
    }
    
    @IBOutlet weak var buttonGuestLogin: UIButton! {
        didSet {
            buttonGuestLogin.roundCorners()
            buttonGuestLogin.layer.borderWidth = 1
            buttonGuestLogin.isHidden = true
        }
    }
    
    @IBOutlet weak var buttonRegisterWithUs: UIButton! {
        didSet {
            buttonRegisterWithUs.layer.borderWidth = 0.4
            buttonRegisterWithUs.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBOutlet weak var viewRegisterWithUs: UIView!
    @IBOutlet weak var containerViewSocialButton: UIView!
    
    
    
    //MARK:- Properties
    var getLoginDetails = [LoginData]()
    var defaults = UserDefaults.standard
    var isVerifyOn = false
    
    // MARK: Application Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        self.adForest_loginDetails()
        
        if #available(iOS 13.0, *) {
            let appleBTN = ASAuthorizationAppleIDButton()


//            appleBTN.center = self.appleLoginView.center
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        defaults.removeObject(forKey: "isGuest")
        defaults.synchronize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    @IBAction func AppleLoginClicked(_ sender: UIButton) {
        
        if #available(iOS 13.0, *) {
            let authorizationProvider = ASAuthorizationAppleIDProvider()
            let request = authorizationProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
        
        
    }
    
    
    
    //MARK:- text Field Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail {
            txtPassword.becomeFirstResponder()
        }
        else if textField == txtPassword {
            txtPassword.resignFirstResponder()
            self.adForest_logIn()
        }
        return true
    }
    
    //MARK: - Custom
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    
    func adForest_populateData() {
        if UserHandler.sharedInstance.objLoginDetails != nil {
            let objData = UserHandler.sharedInstance.objLoginDetails
            
            if let isVerification = objData?.isVerifyOn {
                self.isVerifyOn = isVerification
            }
            
            if let bgColor = defaults.string(forKey: "mainColor") {
                self.containerViewImage.backgroundColor = Constants.hexStringToUIColor(hex: bgColor)
                self.buttonSubmit.layer.borderColor = Constants.hexStringToUIColor(hex: bgColor).cgColor
                self.buttonGuestLogin.layer.borderColor = Constants.hexStringToUIColor(hex: bgColor).cgColor
                self.buttonSubmit.setTitleColor(Constants.hexStringToUIColor(hex: bgColor), for: .normal)
                self.buttonGuestLogin.setTitleColor(Constants.hexStringToUIColor(hex: bgColor), for: .normal)
            }
            
            if let imgUrl = URL(string: (objData?.logo)!) {
                imgTitle.sd_setImage(with: imgUrl, completed: nil)
                imgTitle.sd_setShowActivityIndicatorView(true)
                imgTitle.sd_setIndicatorStyle(.gray)
            }
            
            if let welcomeText = objData?.heading {
                self.lblWelcome.text = welcomeText
            }
            if let emailPlaceHolder = objData?.emailPlaceholder {
                self.txtEmail.placeholder = emailPlaceHolder
            }
            if let passwordPlaceHolder = objData?.passwordPlaceholder {
                self.txtPassword.placeholder = passwordPlaceHolder
            }
            if let forgotText = objData?.forgotText {
                self.buttonForgotPassword.setTitle(forgotText, for: .normal)
            }
            if let submitText = objData?.formBtn {
                self.buttonSubmit.setTitle(submitText, for: .normal)
            }
            
            if let registerText = objData?.registerText {
                self.buttonRegisterWithUs.setTitle(registerText, for: .normal)
            }
            
            // Show hide guest button
            guard let settings = defaults.object(forKey: "settings") else {
                return
            }
            let  settingObject = NSKeyedUnarchiver.unarchiveObject(with: settings as! Data) as! [String : Any]
            let objSettings = SettingsRoot(fromDictionary: settingObject)
            
            
            var isShowGuestButton = false
            if let isShowGuest = objSettings.data.isAppOpen {
                isShowGuestButton = isShowGuest
            }
            if isShowGuestButton {
                self.buttonGuestLogin.isHidden = false
                if let guestText = objData?.guestLogin {
                    self.buttonGuestLogin.setTitle(guestText, for: .normal)
                }
            }
            else {
                self.buttonGuestLogin.isHidden = true
            }
            
            // Show/hide google and facebook button
            var isShowGoogle = false
            var isShowFacebook = false
            
            if let isGoogle = objSettings.data.registerBtnShow.google {
                isShowGoogle = isGoogle
            }
            if let isFacebook = objSettings.data.registerBtnShow.facebook{
                isShowFacebook = isFacebook
            }
            if isShowFacebook || isShowGoogle {
                if let sepratorText = objData?.separator {
                    self.lblOr.text = sepratorText
                }
            }
            
            if isShowFacebook && isShowGoogle {
                self.buttonFBLogin.isHidden = false
                self.buttonGoogleLogin.isHidden = false
                if let fbText = objData?.facebookBtn {
                    self.buttonFBLogin.setTitle(fbText, for: .normal)
                }
                if let googletext = objData?.googleBtn {
                    self.buttonGoogleLogin.setTitle(googletext, for: .normal)
                }
            }
                
            else if isShowFacebook && isShowGoogle == false {
                self.buttonFBLogin.isHidden = false
                self.buttonFBLogin.translatesAutoresizingMaskIntoConstraints = false
                buttonFBLogin.leftAnchor.constraint(equalTo: self.containerViewSocialButton.leftAnchor, constant: 0).isActive = true
                buttonFBLogin.rightAnchor.constraint(equalTo: self.containerViewSocialButton.rightAnchor, constant: 0).isActive = true
                if let fbText = objData?.facebookBtn {
                    self.buttonFBLogin.setTitle(fbText, for: .normal)
                }
            }
                
            else if isShowGoogle && isShowFacebook == false {
                self.buttonGoogleLogin.isHidden = false
                self.buttonGoogleLogin.translatesAutoresizingMaskIntoConstraints = false
                buttonGoogleLogin.leftAnchor.constraint(equalTo: self.containerViewSocialButton.leftAnchor, constant: 0).isActive = true
                buttonGoogleLogin.rightAnchor.constraint(equalTo: self.containerViewSocialButton.rightAnchor, constant: 0).isActive = true
                
                if let googletext = objData?.googleBtn {
                    self.buttonGoogleLogin.setTitle(googletext, for: .normal)
                }    
            }
            else if isShowFacebook == false && isShowGoogle == false {
                self.containerViewSocialButton.isHidden = true
                if isShowGuestButton {
                    self.buttonGuestLogin.isHidden = false
                    self.buttonGuestLogin.translatesAutoresizingMaskIntoConstraints = false
                    buttonGuestLogin.topAnchor.constraint(equalTo: self.buttonSubmit.bottomAnchor, constant: 8).isActive = true
                    if let guestText = objData?.guestLogin {
                        self.buttonGuestLogin.setTitle(guestText, for: .normal)
                    }
                }
                else {
                    self.buttonGuestLogin.isHidden = true
                }
                
            }
        }
    }
    
    //MARK:- IBActions
    
    @IBAction func actionForgotPassword(_ sender: Any) {
        let forgotPassVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(forgotPassVC, animated: true)
    }
    
    
    @IBAction func actionSubmit(_ sender: Any) {
        self.adForest_logIn()
    }
    
    func adForest_logIn() {
        guard let email = txtEmail.text else {
            return
        }
        guard let password = txtPassword.text else {
            return
        }
        if email == "" {
            let alert = Constants.showBasicAlert(message: "Enter Valid Email")
            self.presentVC(alert)
        }
        else if !email.isValidEmail {
            let alert = Constants.showBasicAlert(message: "Enter Valid Email")
            self.presentVC(alert)
        }
        else if password == "" {
            let alert = Constants.showBasicAlert(message: "Enter Valid Password")
            self.presentVC(alert)
        }
        else {
            let param : [String : Any] = [
                "email" : email,
                "password": password
            ]
            print(param)
            self.defaults.set(email, forKey: "email")
            self.defaults.set(password, forKey: "password")
            self.adForest_loginUser(parameters: param as NSDictionary)
        }
    }
    
    @IBAction func actionFBLogin(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Nothing")
            }
            else if (result?.isCancelled)! {
                print("Cancel")
            }
            else if error == nil {
                self.userProfileDetails()

            } else {
            }
        }
    }
    
    @IBAction func actionGoogleLogin(_ sender: Any) {
        if GoogleAuthenctication.isLooggedIn {
            GoogleAuthenctication.signOut()
        }
        else {
            GoogleAuthenctication.signIn()
        }
    }
    
    @IBAction func actionGuestLogin(_ sender: Any) {
        defaults.set(true, forKey: "isGuest")
        self.showLoader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.appDelegate.moveToHome()
            self.stopAnimating()
        }
    }
    
    @IBAction func actionRegisterWithUs(_ sender: Any) {
        let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    //MARK:- Google Delegate Methods
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
        }
        if error == nil {
            guard let email = user.profile.email,
                let googleID = user.userID,
                let name = user.profile.name
                else { return }
            guard let token = user.authentication.idToken else {
                return
            }
            print("\(email), \(googleID), \(name), \(token)")
            let param: [String: Any] = [
                "email": email,
                "type": "social"
            ]
            print(param)
            self.defaults.set(true, forKey: "isSocial")
            self.defaults.set(email, forKey: "email")
            self.defaults.set("1122", forKey: "password")
            self.defaults.synchronize()
            self.adForest_loginUser(parameters: param as NSDictionary)
        }
    }
    // Google Sign In Delegate
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Facebook Delegate Methods
    
    func userProfileDetails() {
        
        
        
        if((FBSDKAccessToken.current()) != nil){
               FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, gender, picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                   if (error == nil){
                    print(result ?? "")
                       guard let results = result as? NSDictionary else { return }
                                 // guard let facebookId = results["email"] as? String,
                    
             
                    var email = results["email"] as? String ?? ""
                    let id = results["id"] as? String ?? ""
                    let defaultEmail = id + "@facebook.com"
                    
                    email = email == "" ? defaultEmail:email
                    
                                  print("\(email),")
                                  let param: [String: Any] = [
                                      "email": email,
                                      "type": "social"
                                  ]
                                  print(param)
                                  self.defaults.set(true, forKey: "isSocial")
                                  self.defaults.set(email, forKey: "email")
                                  self.defaults.set("1122", forKey: "password")
                                  self.defaults.synchronize()
                                  
                                  self.adForest_loginUser(parameters: param as NSDictionary)
                       
                   }else {
                       print(error?.localizedDescription ?? "Nothing")
                   }
               })
           }
        
        
//        if (FBSDKAccessToken.current() != nil) {
//            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, email, gender, picture.type(large)"]).start { (connection, result, error) in
//                if error != nil {
//                    print(error?.localizedDescription ?? "Nothing")
//                    return
//                }
//                else {
//                    guard let results = result as? NSDictionary else { return }
//                    guard let facebookId = results["email"] as? String,
//                        let email = results["email"] as? String else {
//                            return
//                    }
//                    print("\(email), \(facebookId)")
//                    let param: [String: Any] = [
//                        "email": email,
//                        "type": "social"
//                    ]
//                    print(param)
//                    self.defaults.set(true, forKey: "isSocial")
//                    self.defaults.set(email, forKey: "email")
//                    self.defaults.set("1122", forKey: "password")
//                    self.defaults.synchronize()
//
//                    self.adForest_loginUser(parameters: param as NSDictionary)
//                }
//            }
//        }
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        
        return true
    }
    
    
    //MARK:- API Calls
    
    //Login Data Get Request
    func adForest_loginDetails() {
        self.showLoader()
        UserHandler.loginDetails(success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                UserHandler.sharedInstance.objLoginDetails = successResponse.data
                self.adForest_populateData()
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
            
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    // Login User
    func adForest_loginUser(parameters: NSDictionary) {
        self.showLoader()
        UserHandler.loginUser(parameter: parameters , success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success{
                if self.isVerifyOn && successResponse.data.isAccountConfirm == false {
                    let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                        let confirmationVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
                        confirmationVC.isFromVerification = true
                        confirmationVC.user_id = successResponse.data.id
                        self.navigationController?.pushViewController(confirmationVC, animated: true)
                    })
                    self.presentVC(alert)
                }
                else {
                    self.defaults.set(true, forKey: "isLogin")
                    self.defaults.synchronize()
                    self.appDelegate.moveToHome()
                }
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}


extension LoginViewController: ASAuthorizationControllerDelegate {
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let userFirstName = appleIDCredential.fullName?.givenName
            let userLastName = appleIDCredential.fullName?.familyName
            let userEmail = appleIDCredential.email
            let fullName = appleIDCredential.fullName
            print(userIdentifier, userFirstName , userLastName, userEmail, fullName)
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID:userIdentifier) { (credentialState, error) in
                switch credentialState {
                case .authorized:
                    // The Apple ID credential is valid.
                    debugPrint("The Apple ID credential is valid")
                    if let userEmail = appleIDCredential.email,let fullName = appleIDCredential.fullName {
                        
                        let userIdentifier = appleIDCredential.user
                        let userFirstName = appleIDCredential.fullName?.givenName
                        let userLastName = appleIDCredential.fullName?.familyName
                        let userEmail = appleIDCredential.email
                        let user_id = userIdentifier.replacingOccurrences(of: ".", with: "")
                        self.my_id = user_id
                        UserDefaults.standard.setValue(user_id, forKey: "appleId")
                        UserDefaults.standard.setValue(userFirstName, forKey: "appleFirstName")
                        UserDefaults.standard.setValue(userLastName, forKey: "appleLastName")
                        UserDefaults.standard.setValue(userEmail, forKey: "appleEmail")
                        UserDefaults.standard.set(self.my_id, forKey: "uid")
                        self.first_name = userFirstName ?? ""
                        self.last_name = userLastName ?? ""
                        self.email = userEmail ?? ""

                        DispatchQueue.main.async {
//                        self.getAppleSignInData(username:self.first_name,email:self.email,profile_pic:"rt",latitude:userlatitudes,longitude:userlongitudes,address:userCitys,appleid:self.my_id,device_token:deviceID,device_type:"1")
 
                        let param: [String: Any] = [
                            "email": self.email,
                            "type": "social"
                        ]
                        
                        print(param)
                        self.defaults.set(true, forKey: "isSocial")
                        self.defaults.set(self.email, forKey: "email")
                        self.defaults.set("1122", forKey: "password")
                        self.defaults.synchronize()
                        
                        self.adForest_loginUser(parameters: param as NSDictionary)
                        }
                        
                   
                    }else{
                        let user_id = userIdentifier.replacingOccurrences(of: ".", with: "")
                        self.my_id = user_id
                        UserDefaults.standard.set(self.my_id, forKey: "uid")
                        let userId = UserDefaults.standard.value(forKey: "appleId") as? String
                        if self.my_id == userId {
                            self.first_name = UserDefaults.standard.value(forKey: "appleFirstName") as? String ?? ""
                            self.last_name = UserDefaults.standard.value(forKey: "appleLastName") as? String ?? ""
                            self.email = UserDefaults.standard.value(forKey: "appleEmail") as? String ?? ""
                        }
                        
                        let userlatitudes = UserDefaults.standard.value(forKey: "Latitude") as? String ?? ""
                        let userlongitudes = UserDefaults.standard.value(forKey: "Longitude") as? String  ?? ""
                        let userCitys = UserDefaults.standard.value(forKey: "City") as? String ?? ""
                        let deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String ?? ""
                        
                        DispatchQueue.main.async {
                        
                            let param: [String: Any] = [
                                "email": self.email,
                                "type": "social"
                            ]
                            
                            print(param)
                            self.defaults.set(true, forKey: "isSocial")
                            self.defaults.set(self.email, forKey: "email")
                            self.defaults.set("1122", forKey: "password")
                            self.defaults.synchronize()
                            
                            self.adForest_loginUser(parameters: param as NSDictionary)
                        
                        
//                            self.getAppleSignInData(username:self.first_name,email:self.email,profile_pic:"rt",latitude:userlatitudes,longitude:userlongitudes,address:userCitys,appleid:self.my_id,device_token:deviceID,device_type:"1")
//
                        }
                    }
                    break
                case .revoked:
                    // The Apple ID credential is revoked.
                    debugPrint("The Apple ID credential is revoked")
                    
                    break
                case .notFound:
                    // No credential was found, so show the sign-in UI.
                    break
                default:
                    break
                }
            }
            //Navigate to other view controller
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            //Navigate to other view controller
        }

        // print("AppleID Crendential Authorization: userId: \(appleIDCredential.user), email: \(String(describing: appleIDCredential.email))")
        
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("AppleID Crendential failed with error: \(error.localizedDescription)")
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
