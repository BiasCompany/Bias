//
//  EndpointType.swift
//  terapilah
//
//  Created by Adithya Firmansyah Putra on 19/08/24.
//

import Alamofire
import Foundation

protocol EndPointType {
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var url: URL { get }
    var encoder: ParameterEncoder { get }
    var version: String { get }

}
