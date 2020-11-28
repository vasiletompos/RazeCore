//
//  Networking.swift
//  RazeCore
//
//  Created by Tony Tompos on 11/28/20.
//

import Foundation

extension RazeCore {
	public class Networking {
		/// Responsible for handling all networking calls
		/// - Warning: Must create before using any public APIs
		public class Manager {
			public init() {
				
			}
			
			private let sesssion = URLSession.shared
			
			public func loadData(from url: URL, completionHandler: @escaping (NetworkResult<Data>) -> Void) {
				let task = sesssion.dataTask(with: url) { data, response, error in
					let result = data.map(NetworkResult<Data>.success) ?? .failure(error)
					completionHandler(result)
				}
				task.resume()
			}
		}
		
		public enum NetworkResult<Value> {
			case success(Value)
			case failure(Error?)
		}
	}
}
