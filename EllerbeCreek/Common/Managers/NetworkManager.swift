//
//  NetworkManager.swift
//  EllerbeCreek
//
//  Created by Ryan Anderson on 4/18/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import Foundation

class NetworkManager {
    
    // MARK: Public Properties
    
    public var requestHttpHeaders = NetworkEntity<String>()
    public var urlQueryParameters = NetworkEntity<String>()
    public var httpBodyParameters = NetworkEntity<Encodable>()
    public var httpBody: Data?
    
    // MARK: Public Methods
    
    func makeRequest(toURL url: URL, withHttpMethod httpMethod: HTTPMethod, completion: @escaping (_ result: Results) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let targetURL = self?.addURLQueryParameters(toURL: url)
            let httpBody = self?.getHttpBody()
            
            guard let request = self?.prepareRequest(withURL: targetURL, httpBody: httpBody, httpMethod: httpMethod) else {
                completion(Results(withError: CustomError.failedToCreateRequest))
                return
            }
            
            let sessionConfiguration = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfiguration)
            let task = session.dataTask(with: request) { (data, response, error) in
                completion(Results(withData: data,
                                   response: Response(fromURLResponse: response),
                                   error: error))
            }
            task.resume()
        }
    }
    
    func getData(fromURL url: URL, completion: @escaping (_ data: Data?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let sessionConfiguration = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfiguration)
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                guard let data = data else { completion(nil); return }
                completion(data)
            })
            task.resume()
        }
    }
    
    // MARK: Private Methods
    
    private func addURLQueryParameters(toURL url: URL) -> URL {
        if urlQueryParameters.totalItems() > 0 {
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url }
            var queryItems = [URLQueryItem]()
            for (key, value) in urlQueryParameters.allValues() {
                let item = URLQueryItem(name: key, value: value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                queryItems.append(item)
            }
            
            urlComponents.queryItems = queryItems
            
            guard let updatedURL = urlComponents.url else { return url }
            return updatedURL
        }
        
        return url
    }
    
    private func getHttpBody() -> Data? {
        guard let contentType = requestHttpHeaders.value(forKey: "Content-Type") else { return nil }
        
        if contentType.contains("application/json") {
            do {
                let jsonEncoder = JSONEncoder()
                jsonEncoder.outputFormatting = .prettyPrinted
                let data = try jsonEncoder.encode(httpBodyParameters.allValues())
                return data
            } catch {
                print(error)
            }
            return nil
        } else if contentType.contains("application/x-www-form-urlencoded") {
            let bodyString = httpBodyParameters.allValues().map { "\($0)=\(String(describing: $1))" }.joined(separator: "&")
            return bodyString.data(using: .utf8)
        } else {
            return httpBody
        }
    }
    
    private func prepareRequest(withURL url: URL?, httpBody: Data?, httpMethod: HTTPMethod) -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        for (header, value) in requestHttpHeaders.allValues() {
            request.setValue(value, forHTTPHeaderField: header)
        }
        
        request.httpBody = httpBody
        return request
    }
    
}

extension NetworkManager {
    
    enum HTTPMethod: String {
        case get
        case post
        case put
        case patch
        case delete
    }

    struct NetworkEntity<T> {
        private var values: [String: T] = [:]
        
        mutating func add(value: T, forKey key: String) {
            values[key] = value
        }
        
        func value(forKey key: String) -> T? {
            return values[key]
        }
        
        func allValues() -> [String: T] {
            return values
        }
        
        func totalItems() -> Int {
            return values.count
        }
    }
    
    struct Response {
        var response: URLResponse?
        var httpStatusCode: Int = 0
        var headers = NetworkEntity<String>()
        
        init(fromURLResponse response: URLResponse?) {
            guard let response = response else { return }
            self.response = response
            httpStatusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            
            if let headerFields = (response as? HTTPURLResponse)?.allHeaderFields {
                for (key, value) in headerFields {
                    headers.add(value: "\(value)", forKey: "\(key)")
                }
            }
        }
    }

    struct Results {
        var data: Data?
        var response: Response?
        var error: Error?
        
        init(withData data: Data?, response: Response?, error: Error?) {
            self.data = data
            self.response = response
            self.error = error
        }
        
        init(withError error: Error) {
            self.error = error
        }
    }
    
    struct Token: Codable {
        
        private enum CodingKeys: String, CodingKey {
            case auth
            case value
            case date
        }
        
        let dateFormatter = DateFormatter()
        
        var auth: Bool
        var value: String
        var date: String
        
        var formattedDate: Date {
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            return dateFormatter.date(from: date)!
        }
        
        init(auth: Bool, value: String, date: String) {
            self.auth = auth
            self.value = value
            self.date = date
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let auth = try values.decode(Bool.self, forKey: .auth)
            let value = try values.decode(String.self, forKey: .value)
            let date = try values.decode(String.self, forKey: .date)
            
            self.init(auth: auth, value: value, date: date)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(auth, forKey: .auth)
            try container.encode(value, forKey: .value)
            try container.encode(date, forKey: .date)
        }
        
        public func isExpired() -> Bool {
            if let diff = Calendar.current.dateComponents([.hour], from: formattedDate, to: Date()).hour, diff > 24 {
                return true
            }
            return false
        }
        
    }
    
    struct PostData: Decodable {
        
        enum CodingKeys: String, CodingKey {
            case token
            case user
        }
        
        var token: Token
        var user: User
        
        init(token: Token, user: User) {
            self.token = token
            self.user = user
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let token = try values.decode(Token.self, forKey: .token)
            let user = try values.decode(User.self, forKey: .user)
            
            self.init(token: token, user: user)
        }
        
    }

    enum CustomError: Error {
        case failedToCreateRequest
        case failedToUpdateToken
        case failedToFetchObjects
        case failedToFetchObject
        case failedToSaveObject
        case failedToUpdateObject
        case failedToDeleteObject
    }
    
}

// MARK: - Custom Error Description
extension NetworkManager.CustomError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .failedToCreateRequest:
            return NSLocalizedString("Unable to create the URLRequest object", comment: "")
        case .failedToUpdateToken:
            return NSLocalizedString("Unable to update the auth token for the request object", comment: "")
        case .failedToFetchObjects:
            return NSLocalizedString("Unable to fetch the request objects", comment: "")
        case .failedToFetchObject:
            return NSLocalizedString("Unable to fetch the request object", comment: "")
        case .failedToSaveObject:
            return NSLocalizedString("Unable to save the request object", comment: "")
        case .failedToUpdateObject:
            return NSLocalizedString("Unable to update the request object", comment: "")
        case .failedToDeleteObject:
            return NSLocalizedString("Unable to delete the request object", comment: "")
        }
    }
}
