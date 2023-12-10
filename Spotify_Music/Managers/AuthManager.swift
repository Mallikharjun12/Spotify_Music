//
//  AuthManager.swift
//  Spotify_Music
//
//  Created by Mallikharjun kakarla on 09/12/23.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    
    struct Constants {
        static let clientID = "c90ab479ad2d455ebeccb1d4aa7cf5cd"
        static let clientSecret = "ce637e7bd8c64e01998f24b119282681"
        static let redirect_uri = "https://www.quora.com/"
        static let baseUrlForSignIn = "https://accounts.spotify.com/"
    }
    
    public var signInUrl:URL? {
        let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
        let urlString = "\(Constants.baseUrlForSignIn)authorize?client_id=\(Constants.clientID)&response_type=code&redirect_uri=\(Constants.redirect_uri)&scope=\(scopes)&show_dialog=TRUE"
        
        return URL(string: urlString)
    }
    
    var isSignedIn:Bool {
        return accessToken != nil
    }
    
   private var accessToken:String? {
       return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken:String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate:Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken:Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinues:TimeInterval = 300
        
        return currentDate.addingTimeInterval(fiveMinues) >= expirationDate
    }
    
    public func exchangeCodeForToken(
        code:String,
        completion:@escaping (Bool)->Void
    ) {
        //Get token
        let urlString = Constants.baseUrlForSignIn + "api/token"
        guard let url = URL(string: urlString) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
           URLQueryItem(name: "grant_type",
                        value: "authorization_code"),
           URLQueryItem(name: "code",
                        value: code),
           URLQueryItem(name: "redirect_uri",
                        value: Constants.redirect_uri)
           
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Something went wrong")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
            }
            catch {
                completion(false)
                print(error)
            }
        }
        task.resume()
    }
    
    public func refreshAcessTokenIfNeeded(completion:@escaping (Bool)->Void) {
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        //Get token
        let urlString = Constants.baseUrlForSignIn + "api/token"
        guard let url = URL(string: urlString) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
           URLQueryItem(name: "grant_type",
                        value: "refresh_token"),
           URLQueryItem(name: "refresh_token",
                        value: refreshToken)
           
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("Something went wrong")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("successfully refreshed Token")
                self?.cacheToken(result: result)
                completion(true)
            }
            catch {
                completion(false)
                print(error)
            }
        }
        task.resume()
    }
    
    private func cacheToken(result:AuthResponse) {
        UserDefaults.standard.set(result.access_token,
                                  forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.set(refresh_token,
                                      forKey: "refresh_token")
        }
        UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(result.expires_in)),
                                  forKey: "expirationDate")
    }
}
