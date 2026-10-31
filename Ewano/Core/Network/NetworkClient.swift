//
//  NetworkClient.swift
//  Ewano
//
//  Created by Alireza Sotoudeh on 2026/10/28.
//

import Foundation
import Alamofire

protocol NetworkClient {
    associatedtype U: Endpoint
    func request<T: Decodable>(_ endpoint: U) async throws -> T
}

final class NetworkProvider<U: Endpoint>: NetworkClient {
    private let baseURL: URL
    private let session: Session
    private let decoder: JSONDecoder
    private let authInterceptor: RequestInterceptor

    init(
        baseURL: URL = APIConfig.baseURL,
        session: Session = .default,
        decoder: JSONDecoder = JSONDecoder(),
        authInterceptor: RequestInterceptor = AuthInterceptor()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
        self.authInterceptor = authInterceptor
    }

    func request<T: Decodable>(_ endpoint: U) async throws -> T {
        let response = await dataRequest(for: endpoint)
            .validate()
            .serializingDecodable(T.self, decoder: decoder)
            .response

        switch response.result {
        case .success(let value):
            return value
        case .failure(let error):
            throw NetworkError(error, statusCode: response.response?.statusCode)
        }
    }

    func requestEmpty(_ endpoint: U) async throws {
        let response = await dataRequest(for: endpoint)
            .validate()
            .serializingData(emptyResponseCodes: [200, 201, 204, 205])
            .response

        if case .failure(let error) = response.result {
            throw NetworkError(error, statusCode: response.response?.statusCode)
        }
    }

    private func dataRequest(for endpoint: U) -> DataRequest {
        let url = baseURL.appending(path: endpoint.path)
        let interceptor = endpoint.requiresAuth ? authInterceptor : nil

        guard let payload = endpoint.multipart else {
            return session.request(
                url,
                method: endpoint.method,
                parameters: endpoint.parameters,
                encoding: endpoint.encoding,
                headers: endpoint.headers,
                interceptor: interceptor
            )
        }

        return session.upload(
            multipartFormData: { formData in
                formData.append(payload.data, withName: payload.fieldName, fileName: payload.fileName, mimeType: payload.mimeType)
            },
            to: url,
            method: endpoint.method,
            headers: endpoint.headers,
            interceptor: interceptor
        )
    }
}

/// Answers from bundled JSON files, for previews and until the backend exists.
struct MockNetworkClient<U: Endpoint>: NetworkClient {
    func request<T: Decodable>(_ endpoint: U) async throws -> T {
        guard let fileName = endpoint.mockFileName else {
            throw NetworkError.missingMock(path: endpoint.path)
        }
        return Bundle.main.decode(fromJSON: fileName)
    }
}
