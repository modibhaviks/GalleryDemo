//
//  APIManager.swift
//  GalleryDemo
//
//  Created by Bhavik Modi on 18/12/21.
//

import Foundation
import Alamofire

struct APIManager {
    static func request<T:Decodable>(url:String?,completion:@escaping(_ result:Result<T, Error>) -> Void) {
        guard let urlReq = URL(string: url ?? "") else {
            return
        }
        
        AF.request(urlReq).responseData { response in
            if let validData = response.data {
                let decoder = JSONDecoder()
                do {
                    let object = try decoder.decode(T.self, from: validData)
                    completion(.success(object))
                } catch let error {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(response.error!))
            }
        }
    }
}
