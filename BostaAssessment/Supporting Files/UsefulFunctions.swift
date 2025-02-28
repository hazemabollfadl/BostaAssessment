//
//  UsefulFunctions.swift
//  BostaAssessment
//
//  Created by Hazem Abou El Fadl on 28/02/2025.
//

import UIKit

struct UsefulFunctions{
    func randomUser() -> Int{
        let choosenUser = Int.random(in: 1...10)
        return choosenUser
    }
}
