//
//  ConfigLoader.swift
//  ConnectFour
//
//  Created by xxxxxxx on 28.09.20.
//

import Foundation

struct ConfigLoader {
    
    private let configUrlStr = "https://private-75c7a5-blinkist.apiary-mock.com/connectFour/configuration"
    
    func loadConfig(_ completion: @escaping (_ result: Result<GameConfig, GameError>) -> Void) {
        
        guard let url = URL(string: configUrlStr) else {
            completion(.failure(.urlError))
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            guard error == nil else {
                completion(.failure(.system(error!)))
                return
            }

            guard let data = data else {
                completion(.failure(.general("Data was missing from response")))
                return
            }
        
            do {
                let decoded = try JSONDecoder().decode([GameConfig].self, from: data)
                guard let config = decoded.first else {
                    completion(.failure(.decodingError))
                    return
                }
                completion(.success(config))
                
            } catch let error {
                completion(.failure(.system(error)))
            }
        }.resume()
    }
}
