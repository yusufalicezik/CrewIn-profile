//
//  DataService.swift
//  CrewIn-project
//
//  Created by Yusuf ali cezik on 11.11.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class DataServiceManager{
    static let shared = DataServiceManager()
    fileprivate let BASE_URL = "http://******************//***/**/values/"
    fileprivate let INFO = "genel_bilgiler?"

    private init(){}
    func getUserInfo(withID userID:Int, completion:@escaping (_ responseUserData:User)->()){
//        let params = [
//            "kullanici_id":userID]
        Alamofire.request(BASE_URL+INFO+"kullanici_id=\(userID)", method: .post).responseData { (response) in
            do{
                let mData = try JSONDecoder().decode([User].self, from: response.data!)
                if mData.count > 0{
                    completion(mData[0]) //apiye tek bir kullanıcı isteği dahi atılsa kullanıcı dizisi dönüyor. Bu yüzden ilkini response ettim.
                }
            }catch(let err){
                print("error \(err)")
            }
        }
    }
    
}
