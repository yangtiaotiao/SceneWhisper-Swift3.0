//
//  HSRequest.swift
//  SceneWhisper
//
//  Created by weipo 2017/4/5.
//  Copyright © 2017年 weipo. All rights reserved.
//

import Foundation
import Alamofire
import SVProgressHUD

@available(iOS 8.0, *)

class HSRequest {
    
    static let manager: HSRequest = { return HSRequest() }()
    
    typealias successCompletionHandler = ((HSSuccessResponse?) -> Void)?
    typealias errorCompletionHandler = ((HSErrorResponse?) -> Void)?
    
    class func request(_ url: URLConvertible,
                       method: HTTPMethod,
                       parameters: Parameters,
                       success: successCompletionHandler,
                       error: errorCompletionHandler) {
        
        SVProgressHUD.show()
        
        Alamofire.request(url,
                          method: method,
                          parameters: parameters,
                          encoding: URLEncoding.default,
                          headers: nil)
            .validate()
            .responseJSON { (response) in
              
                SVProgressHUD.dismiss()
                
                switch response.result {
                case .success:
                    let handler = HSResponseHandler.handle(response: response)
                    if handler.error == nil {
                        success!(handler.data)
                    } else {
                        SVProgressHUD.showError(withStatus: handler.error?.errorMessage)
                        error!(handler.error)
                    }
                    break
                case .failure:
                    HSRequest.requestErrorHandler(response: response, completionHandler: { (requestError) in
                        error!(requestError)
                    })
                    break
                }
        }
    }
 

    
    //MARK: 网络错误处理
    class func requestErrorHandler(response: DataResponse<Any>, completionHandler: ((HSErrorResponse?) -> Void)?) {
        
        guard case let .failure(error) = response.result else { return }
        
        if let error = error as? AFError {
            switch error {
            case .invalidURL(let url):
                print("无效 URL: \(url) - \(error.localizedDescription)")
            case .parameterEncodingFailed(let reason):
                print("参数编码失败: \(error.localizedDescription)")
                print("失败理由: \(reason)")
            case .multipartEncodingFailed(let reason):
                print("Multipart encoding 失败: \(error.localizedDescription)")
                print("失败理由: \(reason)")
            case .responseValidationFailed(let reason):
                print("Response 校验失败: \(error.localizedDescription)")
                print("失败理由: \(reason)")
                switch reason {
                case .dataFileNil, .dataFileReadFailed:
                    print("无法读取下载文件")
                case .missingContentType(let acceptableContentTypes):
                    print("文件类型不明: \(acceptableContentTypes)")
                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                    print("文件类型: \(responseContentType) 无法读取: \(acceptableContentTypes)")
                case .unacceptableStatusCode(let code):
                    print("请求返回状态码出错: \(code)")
                }
            case .responseSerializationFailed(let reason):
                print("请求返回内容序列化失败: \(error.localizedDescription)")
                print("失败理由: \(reason)")
            }
            print("错误: \(String(describing: error.underlyingError))")
        } else if let error = error as? URLError {
            print("URL 错误: \(error)")
        } else {
            print("未知错误: \(error)")
        }
        
        let requestError = HSErrorResponse(code: "-1004", message: "网络异常！")
        completionHandler!(requestError)
    }

}



