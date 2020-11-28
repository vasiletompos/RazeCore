//
//  Networking.swift
//  RazeCore
//
//  Created by Tony Tompos on 11/28/20.
//

import Foundation

protocol NetworkSession {
	func get(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void)
	func post(with request: URLRequest, completionHandler: @escaping (Data?, Error?) -> Void)
}

extension URLSession: NetworkSession {
	func post(with request: URLRequest, completionHandler: @escaping (Data?, Error?) -> Void) {
		let task = dataTask(with: request) { data, _, error in
			completionHandler(data, error)
		}
		task.resume()
	}
	
	func get(from url: URL, completionHandler: @escaping (Data?, Error?) -> Void) {
		let task = dataTask(with: url) { data, _, error in
			completionHandler(data, error)
		}
		task.resume()
	}
}

extension RazeCore {
	
	public class Networking {
		
		/// Responsible for handling all networking calls
		/// - Warning: Must create before using any public APIs
		public class Manager {
			public init() {}
			
			internal var sesssion: NetworkSession = URLSession.shared
			
			/// Calls to the live internet to retrieve Data from a specific location
			/// - Parameters:
			///   - url: The location you wish to fetch data from
			///   - completionHandler: Returns a result object which signifies the status of the request
			public func loadData(from url: URL, completionHandler: @escaping (NetworkResult<Data>) -> Void) {
				sesssion.get(from: url) { data, error in
					let result = data.map(NetworkResult<Data>.success) ?? .failure(error)
					completionHandler(result)
				}
			}
			
			/// Calls to the live internet to send data to a specific locatin
			/// - Warning: Make sure that the URL in question can accept a POST route
			/// - Parameters:
			///   - url: The location you wish to send data to
			///   - body: The object you wish to send over the network
			///   - completionHandler: Returns a result object which signifies the status of the request
			public func sendData<I: Codable>(to url: URL, body: I, completionHandler: @escaping (NetworkResult<Data>) -> Void) {
				var request = URLRequest(url: url)
				do {
					let httpBody = try JSONEncoder().encode(body)
					request.httpBody = httpBody
					request.httpMethod = "POST"
					sesssion.post(with: request) { (data, error) in
						let result = data.map(NetworkResult<Data>.success) ?? .failure(error)
						completionHandler(result)
					}
				}
				catch {
					return completionHandler(.failure(error))
				}
			}
		}
		
		public enum NetworkResult<Value> {
			case success(Value)
			case failure(Error?)
		}
	}
}
