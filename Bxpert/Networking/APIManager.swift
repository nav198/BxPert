//
//  APIManager.swift
//  Bxpert
//
//  Created by Naveen on 27/03/25.
//

import Foundation

class APIManager{
    static let shared = APIManager()
    
    private init () {}
    
    func fetchData(completion:@escaping (Result<[MobilesModel],DataError>)->Void){
        let urlString = URL(string: ApiURl.mobiles.rawValue)
        guard let url=urlString else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url){data,response,error in
            var result: Result<[MobilesModel], DataError>
          
            if let error = error {
                result = .failure(.otherError(msg: error.localizedDescription))
            } else if let data = data,
                      let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) {
                do {
                    let jsonData = try JSONDecoder().decode([MobilesModel].self, from: data)
                    result = .success(jsonData)
                } catch {
                    result = .failure(.otherError(msg: error.localizedDescription))
                }
            } else {
                result = .failure(.invalidResponse)
            }

            // Ensure completion is called on the main thread
            DispatchQueue.main.async {
                completion(result)
            }
            
            
        }.resume()
    }
}
