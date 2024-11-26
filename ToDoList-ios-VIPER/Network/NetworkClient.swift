//
//  NetworkClient.swift
//  ToDoList-ios-VIPER
//
//  Created by Дима on 26.11.2024.
//

import Foundation

protocol NetworkClientProtocol {
    func get(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
    func get<T: Decodable>(from url: URL, type: T.Type, completion: @escaping (Result<T, Error>) -> Void)
}

struct NetworkClient: NetworkClientProtocol {
    
    
    // MARK: - Properties
    private let session: URLSession
    private let decoder: JSONDecoder

    // MARK: - Initializer
    init(session: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    // MARK: - Methods
    func get(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NetworkError.noData))
            }
        }

        task.resume()
    }

    func get<T: Decodable>(from url: URL, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        get(from: url) { result in
            switch result {
            case .success(let data):
                self.parse(data: data, type: type, onResponse: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Private

    private func parse<T: Decodable>(data: Data, type _: T.Type, onResponse: @escaping (Result<T, Error>) -> Void) {
        do {
            let response = try decoder.decode(T.self, from: data)
            onResponse(.success(response))
        } catch {
            onResponse(.failure(NetworkError.parsingError))
        }
    }
}

// MARK: - Errors
enum NetworkError: Error {
    case invalidResponse
    case noData
    case parsingError
}

