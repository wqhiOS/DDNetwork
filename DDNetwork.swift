//
//  DDNetwork.swift
//  DDNetwork
//
//  Created by wuqh on 2018/6/1.
//  Copyright © 2018年 wuqh. All rights reserved.
//

import Foundation
import Alamofire

typealias SuccessHandle = ([String:Any])->()
typealias FailureHandle = (Error)->()

typealias UploadProgressHandle = (Progress)->()
typealias UploadHandle = (MultipartFormData)->Void


func postRequest(_ url: String,
                 parameters: Parameters,
                 success: SuccessHandle?,
                 failure: FailureHandle?) {
    
    
    request(url: url, method: .post, parameters: parameters, success: success, failure: failure)
}

func getRequest(_ url: String,
                 parameters: Parameters,
                 success: SuccessHandle?,
                 failure: FailureHandle?) {
    request(url: url, method: .get, parameters: parameters, success: success, failure: failure)
}

func upload(_ url: String,
            parameter: Parameters?,
            data: Data,
            upload:@escaping UploadHandle,
            progress: UploadProgressHandle?,
            success: SuccessHandle?,
            failure: FailureHandle?) {
    
    
    Alamofire.upload(multipartFormData: upload, to: url, method: .post, headers: nil) { (multipartFormDataEncodingResult) in
        switch multipartFormDataEncodingResult {
            
        case .success(let upload, _, _):
            
            upload.responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    
                    
                    if let dict = value as? Dictionary<String,Any>, let success = success {
                        success(dict)
                    }
                    
                case .failure(let error):
                    
                    if let failure = failure {
                        failure(error)
                    }
                }
            })
            
            if let progress = progress {
                upload.uploadProgress(closure: progress)
            }
            
        case .failure(let error):
            if let failure = failure {
                failure(error)
            }
        }
    }
}

private func request(url: String,
                     method: HTTPMethod,
                     parameters: Parameters,
                     encoding: ParameterEncoding = URLEncoding.default,
                     headers: HTTPHeaders? = nil,
                     success: SuccessHandle?,
                     failure: FailureHandle?) {
    

    Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { (response) in
        switch response.result {
        case .success(let value):
            let dict = value as! Dictionary<String,Any>
            if let success = success {
                success(dict)
            }
            
        case .failure(let error):
            
            if let failure = failure {
                failure(error)
            }
        }
    }
    
}






