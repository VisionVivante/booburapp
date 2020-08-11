//
//  UserHandler.swift
//  AdForest
//
//  Created by apple on 3/8/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation
import Alamofire
class UserHandler {
    
    static let sharedInstance = UserHandler()
    
    var objSettings: SettingsData?
    var objSettingsMenu = [SettingsPage]()
    var objLoginDetails: LoginData?
    var objregisterDetails: RegisterData?
    var objForgotDetails: ForgotData?
    var objProfileDetails: ProfileDetailsRoot?
    var objUserRating : UserRatings?
    var objPaymentType : PackagesData?
   
    var objPayPal : PackagesDataPaypal?
    var objStripeData: StripePaymentData?
    var objUserRatingReply: [UserRatingReply]?
    var objPublicProfile: PublicProfileData?
    var objSentOffers: SentOffersData?
    var objOfferOnAdsData: OfferAdsData?
    var objSentOfferChatData: SentOfferChatData?
    
    var objBlog: BlogDetailRoot?
    var userConfirmationData : UserConfirmationData?
    
    var sentOffersArray = [SentOffersItem]()
    var messagesTitle = ""
    var sentOffersTitle = ""
    var offerOnAdsTitle = "" 
    
    //MARK:- Settings Data
    class func settingsdata(success: @escaping(SettingsRoot) -> Void, failure: @escaping(NetworkError)-> Void) {
        
        let url = Constants.URL.baseUrl+Constants.URL.settings
        print(url)
        
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objData = SettingsRoot(fromDictionary: dictionary)
            let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            UserDefaults.standard.set(data, forKey: "settings")
            UserDefaults.standard.synchronize()
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    
    //MARK:- Login Get
    
    class func loginDetails(success: @escaping(LoginRoot) -> Void, failure: @escaping(NetworkError) -> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.logIn
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objData = LoginRoot(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Login Post
    
    class func loginUser(parameter: NSDictionary, success: @escaping(UserRegisterRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.logIn
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            print("-------------userhandler-----------------")
            print("all login data::::", data)
            print("-------------userhandler-----------------")
            
            UserDefaults.standard.set(data, forKey: "userData")
            UserDefaults.standard.synchronize()
            let objLogin = UserRegisterRoot(fromDictionary: dictionary)
            print("-------------userhandler-----------------")
            print("all login data::::", objLogin)
            print("-------------userhandler-----------------")
            success(objLogin)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Register Get
    
    class func registerDetails(success: @escaping(RegisterRoot) -> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.register
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objUser = RegisterRoot(fromDictionary: dictionary)
            success(objUser)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Register Post
    class func registerUser(parameter: NSDictionary, success: @escaping(UserRegisterRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.register
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            UserDefaults.standard.set(data, forKey: "userData")
            UserDefaults.standard.synchronize()
            let objRegister = UserRegisterRoot(fromDictionary: dictionary)
            success(objRegister)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- User Confirmation Get Data
    class func userConfirmation(success: @escaping(UserConfirmationRoot)-> Void, failure : @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.userConfirmation
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objData = UserConfirmationRoot(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- User Confirmation Post Data
    class func userConfirmationPost(parameter: NSDictionary, success: @escaping(UserForgot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.userConfirmation
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objUser = UserForgot(fromDictionary: dictionary)
            success(objUser)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Forgot Password Get
    
    class func forgotDetails(success: @escaping(ForgotRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.forgotPassword
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objForgot = ForgotRoot(fromDictionary: dictionary)
            success(objForgot)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Forgot Password Post
    
    class func forgotUser(parameter: NSDictionary, success: @escaping(UserForgot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.forgotPassword
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objForgotUser = UserForgot(fromDictionary: dictionary)
            success(objForgotUser)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    
    
    //MARK:- Profile Get
    
    class func profileGet(success: @escaping(ProfileDetailsRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.profileGet
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objProfile = ProfileDetailsRoot(fromDictionary: dictionary)
            print("***************11*************")
            print(dictionary)
            print("*****************22***********")
            print(objProfile)
            print("*****************33***********")
            print(successResponse)
            print("********************44********")
            success(objProfile)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Profile Post
    class func profileUpdate(parameters: NSDictionary, success: @escaping(ProfileUpdateRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.profileGet
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameters as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objProfile = ProfileUpdateRoot(fromDictionary: dictionary)
            success(objProfile)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- User Profile rating
    class func userProfileRating(success: @escaping(UserRatingRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.userProfileRating
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objUser = UserRatingRoot(fromDictionary: dictionary)
            success(objUser)
        }) { (error) in
               failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Update Profile Image
    
    class func imageUpdate(fileUrl: URL, fileName: String, uploadProgress: @escaping(Int)-> Void ,success: @escaping(UpdateImageRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.imageUpdate
        print(url)
        NetworkHandler.upload(url: url, fileUrl: fileUrl, fileName: fileName, params: nil, uploadProgress: { (uploadProgress) in
            print(uploadProgress)
        }, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            
            let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            UserDefaults.standard.set(data, forKey: "userData")
            UserDefaults.standard.synchronize()
            
            let objImage = UpdateImageRoot(fromDictionary: dictionary)
            
            success(objImage)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Change Password
    class func changePassword(parameter: NSDictionary, success: @escaping(AdRemovedRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.changePassword
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objPass = AdRemovedRoot(fromDictionary: dictionary)
            success(objPass)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Verify Phone
    class func verifyPhone(success: @escaping(NumberVerifyRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.verifyPhone
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objPhone = NumberVerifyRoot(fromDictionary: dictionary)
            success(objPhone)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Verify Code
    class func verifyCode(param: NSDictionary , success: @escaping(PhoneVerificationRoot)-> Void, failure: @escaping(NetworkError)-> Void)  {
        let url = Constants.URL.baseUrl+Constants.URL.verifyCode
        print(url)
        NetworkHandler.postRequest(url: url, parameters: param as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objCode = PhoneVerificationRoot(fromDictionary: dictionary)
            success(objCode)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Blog Data
    class func blogData(success: @escaping(BlogRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.getBlog
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objBlog = BlogRoot(fromDictionary: dictionary)
            success(objBlog)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- More Blog Data
    class func moreBlogData(parameter: NSDictionary ,success: @escaping(BlogRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.getBlog
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objBlog = BlogRoot(fromDictionary: dictionary)
            success(objBlog)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Blog Detail
    class func blogDetail(parameter: NSDictionary, success: @escaping(BlogDetailRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.blogDetail
        print("hello1")
        print(parameter)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objBlog = BlogDetailRoot(fromDictionary: dictionary)
            success(objBlog)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Blog Post Comment
    class func blogPostComment(parameter: NSDictionary, success: @escaping(BlogPostRoot)-> Void , failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.blogPostComment
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objPost = BlogPostRoot(fromDictionary: dictionary)
            success(objPost)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Get Packages Data
    
    class func packagesdata(success: @escaping(PackagesDataRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.packages
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objPackage = PackagesDataRoot(fromDictionary: dictionary)
            success(objPackage)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
   
    //MARK:- Payment Confirmation
    
    class func paymentConfirmation(parameters: NSDictionary, success: @escaping(AdRemovedRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.paymentConfirmation
        print(url)
        
        NetworkHandler.postRequest(url: url, parameters: parameters as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objResponse = AdRemovedRoot(fromDictionary: dictionary)
            success(objResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Payment Success
    
    class func paymentSuccess(success: @escaping(PaymentSuccessRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.paymentSuccess
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objResponse = PaymentSuccessRoot(fromDictionary: dictionary)
            success(objResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Stripe Check Out Data
    
    class func stripeCheckOutData(success: @escaping(StripePaymentRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.stripeCheckOutProcess
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objStripe = StripePaymentRoot(fromDictionary: dictionary)
            success(objStripe)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- User Public Profile
    class func userPublicProfile(params: NSDictionary, success: @escaping(PublicProfileRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.userPublicProfile
        print(url)
        NetworkHandler.postRequest(url: url, parameters: params as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objPublicProfile = PublicProfileRoot(fromDictionary: dictionary)
            success(objPublicProfile)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Get sent Offers
    class func getSentOffersData(success: @escaping(SentOffersRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.sentOffers
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objSentOffer = SentOffersRoot(fromDictionary: dictionary)
            success(objSentOffer)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //Load more sent offers Data
    class func moreSentOffersData(param: NSDictionary, success: @escaping(SentOffersRoot)-> Void, failure: @escaping(NetworkError)-> Void ) {
        let url = Constants.URL.baseUrl+Constants.URL.sentOffers
        print(url)
        NetworkHandler.postRequest(url: url, parameters: param as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objSentOffer = SentOffersRoot(fromDictionary: dictionary)
            success(objSentOffer)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Get Offer On Ads
    class func offerOnAds(success: @escaping(OfferAdsRoot)-> Void, failure: @escaping(NetworkError)-> Void){
        let url = Constants.URL.baseUrl+Constants.URL.offerOnAds
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objOfferAds = OfferAdsRoot(fromDictionary: dictionary)
            success(objOfferAds)
        }) { (error) in
              failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Load More Offer Ads Data
    class func moreOfferAdsData(parameter: NSDictionary ,success: @escaping(OfferAdsRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.offerOnAds
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objOfferAds = OfferAdsRoot(fromDictionary: dictionary)
            success(objOfferAds)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Get Sent Offer Messages
    class func getSentOfferMessages (parameter: NSDictionary, success: @escaping(SentOfferChatRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.getSentOfferChatMessages
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objChat = SentOfferChatRoot(fromDictionary: dictionary)
            success(objChat)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Send message
    
    class func sendMessage(parameter: NSDictionary, success: @escaping(SentOfferChatRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.sendmessage
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objChat = SentOfferChatRoot(fromDictionary: dictionary)
            success(objChat)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Offer On Add Detail
    class func getOfferAddDetail(param: NSDictionary, success: @escaping(OfferOnAdDetailRoot)-> Void, failure: @escaping(NetworkError)->Void) {
        let url = Constants.URL.baseUrl+Constants.URL.offerOnAdsDetail
        print(url)
        NetworkHandler.postRequest(url: url, parameters: param as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objData = OfferOnAdDetailRoot(fromDictionary: dictionary)
            success(objData)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Delete Account
    class func deleteAccount(param: NSDictionary, success: @escaping(UserForgot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.deleteAccount
        print(url)
        NetworkHandler.postRequest(url: url, parameters: param as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objResp = UserForgot(fromDictionary: dictionary)
            success(objResp)
        }) { (error) in
              failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Terms and Conditions Page
    class func termsConditions(parameter: NSDictionary, success: @escaping(TermsConditionsRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.termsPage
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objUser = TermsConditionsRoot(fromDictionary: dictionary)
            success(objUser)
        }) { (error) in
              failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Blocked Users List
    class func blockedUsersList(success: @escaping(BlockedUserRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.blockedUsersList
        print(url)
        NetworkHandler.getRequest(url: url, parameters: nil, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objUser = BlockedUserRoot(fromDictionary: dictionary)
            success(objUser)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Un Block User
    class func unBlockUser(parameter: NSDictionary, success: @escaping(UserForgot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.unBlockUser
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objUser = UserForgot(fromDictionary: dictionary)
            success(objUser)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- Block User
    class func blockUser(parameter: NSDictionary, success: @escaping(UserForgot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.baseUrl+Constants.URL.blockUser
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (sucessResponse) in
            let dictionary = sucessResponse as! [String: Any]
            let objUser = UserForgot(fromDictionary: dictionary)
            success(objUser)
        }) { (error) in
             failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
}
