//
//  Model.swift
//  Basicgallery
//
//  Created by Sanskar IOS Dev on 04/09/25.
//

import Foundation
import UIKit


let sStoreArray = "storeArray"
let sUserDefault = UserDefaults.standard

class UserModel : Codable {
    var userID: String?
    var emailAddress: String?
    var userGoogleEmail: String?
    var fullName: String?
    var userGoogleName: String?
    var givenName: String?
    var familyName: String?
    var profilePicURL: URL?
}


class RoundView:UIView{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.bounds.size.height/2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
}

extension UserModel {
    
    static func saveToUserDefaults(userModel: UserModel) {
          let encoder = JSONEncoder()
          if let encoded = try? encoder.encode(userModel) {
              UserDefaults.standard.set(encoded, forKey: "SavedUserModel")
          }
      }
      
      // MARK: - Load from UserDefaults
      static func loadFromUserDefaults() -> UserModel? {
          if let savedData = UserDefaults.standard.data(forKey: "SavedUserModel") {
              let decoder = JSONDecoder()
              return try? decoder.decode(UserModel.self, from: savedData)
          }
          return nil
      }
      
      // MARK: - Remove User (Logout)
      static func clearUserDefaults() {
          UserDefaults.standard.removeObject(forKey: "SavedUserModel")
      }
}

extension UserModel{
    
    static func setStoreArrayToUD(storeList : [Articles] ){
        do{
            let storeArrayData = try JSONEncoder().encode(storeList)
            sUserDefault.setValue(storeArrayData, forKey:sStoreArray)
            sUserDefault.synchronize()
        }catch{
            print("ERROR UserDStore SET :: \(error.localizedDescription)")
        }
    }
  
    static func getStoreArrayFromUD() -> [Articles]?{
        if let storeArray = sUserDefault.value(forKey: sStoreArray) as? Data{
            do {
                let storeList : [Articles] = try JSONDecoder().decode([Articles].self, from: storeArray)
                return storeList
            }catch{
                DispatchQueue.main.async {
                    print("ERROR UserDStore GET: : \(error.localizedDescription)")
                }
                return nil
            }
        }

        return nil
    }
    
}
