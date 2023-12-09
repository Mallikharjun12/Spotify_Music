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
    }
    
    public var signInUrl:URL? {
        let scopes = "user-read-private"
        let baseUrlForSignIn = "https://accounts.spotify.com/authorize"
        let urlString = "\(baseUrlForSignIn)?client_id=\(Constants.clientID)&response_type=code&redirect_uri=\(Constants.redirect_uri)&scope=\(scopes)&show_dialog=TRUE"
        
        return URL(string: urlString)
    }
    
    var isSignedIn:Bool {
        return false
    }
    
   private var accessToken:String? {
        return nil
    }
    
    private var refreshToken:String? {
        return nil
    }
    
    private var tokenExpirationDate:Date? {
        return nil
    }
    
    private var shouldRefreshToken:Bool {
        return false
    }
    
    public func exchangeCodeForToken(
        code:String,
        completion:@escaping (Bool)->Void
    ) {
        //Get token
    }
    
    public func refreshAcessToken() {
        
    }
    
    private func cacheToken() {
        
    }
}
