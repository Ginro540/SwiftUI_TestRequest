//
//  BaseRequest.swift
//  TestRequest
//
//  Created by 古賀貴伍 on 2020/10/15.
//

import Foundation

enum APIError: Error {
    case server(Int)
    case decode(Error)
    case noResponse
    case unknown(Error)
}


protocol Requestable {
    var url: String { get }
    var httpMethod: String { get }
    var headers: [String: String] { get }
    var body: Data? { get }
    associatedtype Model
    func decode(from data: Data) throws -> Model
}


extension Requestable {
    var urlRequest: URLRequest? {
        guard let url = URL(string: url) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        if let body = body {
            request.httpBody = body
        }
        headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        debugPrint(request)
        return request
    }
}


struct APIClient {
    func request<T: Requestable>(_ requestable: T, completion: @escaping(Result<T.Model?, APIError>) -> Void){
        guard let request = requestable.urlRequest else { return }

        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                completion(.failure(APIError.unknown(error)))
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                    completion(.failure(APIError.noResponse))
                    return
            }
            if case 200..<300 = response.statusCode {
                do {
                    debugPrint(data)
                    let model = try requestable.decode(from: data)
                    completion(.success(model))
                } catch let decodeError {
                    completion(.failure(APIError.decode(decodeError)))
                }
            } else {
                completion(.failure(APIError.server(response.statusCode)))
            }
        })
        task.resume()
    }
}
