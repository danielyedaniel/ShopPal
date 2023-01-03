//
//  AccountCreationRequest.swift
//  ShopPal
//
//  Created by Kevin Liu on 2023-01-02.
//

import Foundation

enum APIError:Error {
    case responseProblem
    case decodingProblem
    case encodingProblem
}

struct APIRequest {
    let resourceURL: URL
    
    init(endpoint: String) {
        let resourceString = "http://shoppal-env.eba-qxspnwem.us-east-1.elasticbeanstalk.com/user/signup"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
    }
    
    func save (_ accountToSave:NewAccount, completion: @escaping(Result<NewAccount, APIError>) -> Void ) {
        do {
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(accountToSave)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) {data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                      let jsonData = data else {
                    completion(.failure(.responseProblem))
                    return
                }
                
                do {
                    let accountData = try JSONDecoder().decode(NewAccount.self, from: jsonData)
                    completion(.success(accountData))
                } catch {
                    completion(.failure(.decodingProblem))
                }
                
            }
            dataTask.resume()
        } catch {
            completion(.failure(.encodingProblem))
        }
    }
}
