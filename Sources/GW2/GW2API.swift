//
//  GW2API.swift
//  
//
//  Created by Zach Eriksen on 2/8/20.
//

import Foundation
import OpenCombine

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public class GW2API {
    public enum Route: String {
        case account
        case account_achievements
        case account_bank
        case account_dailycrafting
        case account_dungeons
        case account_dyes
        case account_emotes
    }
    
    public static var instance: GW2API = {
        GW2API()
    }()
    
    // Configuations
    public var apiKey: String?
    
    // Constants
    private let path: String = "https://api.guildwars2.com/v2"
    
    // Lazy Variables
    private lazy var url: URL = URL(string: path)!
}

// MARK: Helper Functions
public extension GW2API {
    
    @discardableResult
    func configure(apiKey: String) -> Self {
        self.apiKey = apiKey
        
        return self
    }
    
    func fetch(route: Route) -> AnyPublisher<Any, Error> {
        var request = url.request(forRoute: route)
        
        return request.dataTaskPublish()
            .mapError { $0 as Error }
            .compactMap {
                do {
                    return try JSONSerialization.jsonObject(with: $0.data, options: [])
                } catch {
                    print("Error: \(error)")
                    return nil
                }
        }
        .eraseToAnyPublisher()
    }
    
    func get<T: Codable>(route: Route) -> AnyPublisher<T, Error> {
        var request = url.request(forRoute: route)
        
        return request.dataTaskPublish()
            .mapError { $0 as Error }
            .compactMap {
                do {
                    return try JSONDecoder().decode(T.self, from: $0.data)
                } catch {
                    print("Error: \(error)")
                    return nil
                }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: API Route Functions
public extension GW2API {
    func account() -> AnyPublisher<Account, Error> {
        get(route: .account)
    }
    
    func achievements() -> AnyPublisher<[Achievement], Error> {
        get(route: .account_achievements)
    }
    
    func bank() -> AnyPublisher<[Item?], Error> {
        get(route: .account_bank)
    }
    
    func dailycrafting() -> AnyPublisher<[String], Error> {
        get(route: .account_dailycrafting)
    }
    
    func dungeons() -> AnyPublisher<[String], Error> {
        get(route: .account_dungeons)
    }
    
    func dyes() -> AnyPublisher<[Int], Error> {
        get(route: .account_dyes)
    }

    func emotes() -> AnyPublisher<[String], Error> {
        get(route: .account_emotes)
    }
}