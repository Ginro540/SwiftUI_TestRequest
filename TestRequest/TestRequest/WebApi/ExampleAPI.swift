//
//  ExampleAPI.swift
//  TestRequest
//
//  Created by 古賀貴伍 on 2020/10/15.
//

import Foundation

struct ExampleAPI: Requestable {
    
    typealias Model = ExampleResponce
    
    var url: String {
      return "https://XXXXXXXXXXXXXXXXXXXXXXX"
    }
    var httpMethod: String {
      return "POST"
    }
    var headers: [String : String] {
        return ["Content-type":"application/json"]
    }
    func decode(from data: Data) throws -> ExampleResponce {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(ExampleResponce.self, from: data)
    }
    
    var id:String

    var Pass:String
    
    var body: Data? {
        let body: [String: Any] = [
                "username": id,
                "password": Pass
            ]
        return try! JSONSerialization.data(withJSONObject: body, options: [])
    }
}
struct ExampleResponce: Codable {
    let token: String
}
