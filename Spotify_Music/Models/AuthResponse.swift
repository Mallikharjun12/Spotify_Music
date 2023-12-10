//
//  AuthResponse.swift
//  Spotify_Music
//
//  Created by Mallikharjun kakarla on 09/12/23.
//

import Foundation

struct AuthResponse:Codable {
    let access_token:String
    let expires_in:Int
    let refresh_token:String?
    let scope:String
    let token_type:String
}
