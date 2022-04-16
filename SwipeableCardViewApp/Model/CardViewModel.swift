//
//  CardViewModel.swift
//  SwipeableCardViewApp
//
//  Created by Never Mind on 16/04/22.
//

import Foundation

struct baseModel:Decodable {
    let data :[data]?
}

struct data:Decodable {
    let id : String?
    let text : String?
}

