//
//  WeatherManager.swift
//  BostaAssessment
//
//  Created by Hazem Abou El Fadl on 27/02/2025.
//

import UIKit

protocol UsersManagerDelegate{
    func getUserData(user: UserModel)
}


struct UserManager{
    
   
    let UsersURL="https://jsonplaceholder.typicode.com/users"
    
    var delegate: UsersManagerDelegate?
    
    func fetchUsers(UserNumber:Int){
        performRequest(with: "\(UsersURL)/\(UserNumber)")
    }
    
    
    func performRequest(with urlString:String){
        if let url = URL(string: urlString){
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url){ (data,response,error) in
                if error != nil{
                    print(error!)
                    return
                }
                if let safeData=data{
                    if let user = self.parseJSON(safeData){
                        self.delegate?.getUserData(user:user)
                        
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ usersData:Data) -> UserModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(UsersData.self, from: usersData)
            let name = decodedData.name
            let street = decodedData.address.street
            let city = decodedData.address.city
            let suite = decodedData.address.suite
            let zipcode = decodedData.address.zipcode
            
            let user = UserModel(name: name, street: street, suite: suite, city: city, zipcode: zipcode)
            return user
        }catch{
            print(error)
            return nil
        }
    }
}


