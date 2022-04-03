//
//  UserSettingsServices.swift
//  Elated
//
//  Created by Marlon on 2021/2/28.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import Moya

enum UserSettingsService {
    case getBookList(page: Int)
    case createBook(book: Book)
    case searchBook(page: Int, searchKeyword: String, searchType: String)
    case getBookListByPath(id: Int)
    case updateBookFull(id: Int,
                        title: String,
                        description: String,
                        publishedDate: String,
                        imageLink: String,
                        user: Int)
    case updateBookPartial(id: Int,
                           title: String,
                           description: String,
                           publishedDate: String,
                           imageLink: String,
                           user: Int)
    case deleteBook(id: Int)
    case getMusicList(page: Int)
    case createMusic(spotifyId: Int, title: String, user: Int)
    case createMusicPlaylistTrack(spotifyId: Int, title: String, user: Int)
    case createMusicPlaylists(spotifyId: Int, title: String, user: Int)
    case createMusicToken(spotifyId: Int, title: String, user: Int)
    case searchMusic(spotifyId: Int, title: String, user: Int) // POST
    case getMusicByPath(id: Int)
    case updateMusicFull(id: Int, spotifyId: Int, title: String, user: Int)
    case updateMusicPartial(id: Int, spotifyId: Int, title: String, user: Int)
    case deleteMusic(id: Int)
    //TODO: Update with swagger documentation is already updated
    case createFeedback(parameters: [String: Any])
    case shareTutorial(parameters: [String: Any])
    case updateMatchPreference(parameters: [String: Any])
    case updateNotification(parameters: [String: Any])
    case updateProfile(parameters: [String: Any])
    case updateSettings(parameters: [String: Any])
    case addDislikes(dislikes: [String])
    case addLikes(likes: [String])
    case removeDislikes(dislikes: [String])
    case removeLikes(likes: [String])
    case getLikes
    case getDislikes
}

extension UserSettingsService: TargetType {
    var baseURL: URL {
        return URL(string: Environment.rootURLString + "/api/v1/users/settings")!
    }
    
    var path: String {
        //TODO: Remove the stupid "/" at the end after the API is fixed
        switch self {
        case .getBookList, .createBook:
            return "/books/"
        case .searchBook:
            return "/books/search_book/"
        case let .getBookListByPath(id),
             let .updateBookFull(id, _,_,_,_,_),
             let .updateBookPartial(id, _,_,_,_,_),
             let .deleteBook(id):
            return "/books/\(id)/"
        case .getMusicList,
             .createMusic:
            return "/music/"
        case .createMusicPlaylistTrack:
            return "/music/add_playlist_tracks/"
        case .createMusicPlaylists:
            return "/music/get_playlists/"
        case .createMusicToken:
            return "/music/request_access_token/"
        case .searchMusic:
            return "/music/search_music/"
        case let .getMusicByPath(id),
             let .updateMusicFull(id, _,_,_),
             let .updateMusicPartial(id, _,_,_),
             let .deleteMusic(id):
            return "/music/\(id)/"
        case .createFeedback:
            return "/post_feedback/"
        case .shareTutorial:
            return "/share_tutorial/"
        case .updateMatchPreference:
            return "/update_match_preferences/"
        case .updateNotification:
            return "/update_notification/"
        case .updateProfile:
            return "/update_profile/"
        case .updateSettings:
            return "/update_settings/"
        case .addDislikes:
            return "/add_dislikes/"
        case .addLikes:
            return "/add_likes/"
        case .removeDislikes:
            return "/remove_dislikes/"
        case .removeLikes:
            return "/remove_likes/"
        case .getLikes:
            return "/likes/"
        case .getDislikes:
            return "/dislikes/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBookList,
             .searchBook,
             .getBookListByPath,
             .getMusicList,
             .getMusicByPath,
             .getLikes,
             .getDislikes:
            return .get
        case .createBook,
             .createMusic,
             .createMusicPlaylistTrack,
             .createMusicPlaylists,
             .createMusicToken,
             .searchMusic,
             .createFeedback,
             .shareTutorial:
            return .post
        case .updateBookFull,
             .updateMusicFull,
             .updateMatchPreference,
             .updateNotification,
             .updateProfile,
             .updateSettings,
             .addDislikes,
             .removeDislikes,
             .addLikes,
             .removeLikes:
            return .put
        case .updateBookPartial,
             .updateMusicPartial:
            return .patch
        case .deleteBook,
             .deleteMusic:
            return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .createBook(book):
            return .requestParameters(parameters: ["author": book.authors,
                                                   "title": book.title ?? "",
                                                   "volume_id": book.volumeID ?? "",
                                                   "description": book.description ?? "",
                                                   "image_link": book.cover ?? ""],
                                      encoding: JSONEncoding.default)
        case let .getBookList(page),
             let .getMusicList(page):
            return .requestParameters(parameters: ["page": page],
                                      encoding: URLEncoding.default)
            
        case let .searchBook(page, searchKeyword, searchType):
            return .requestParameters(parameters: ["page": page,
                                                   "search_keyword": searchKeyword,
                                                   "search_type": searchType],
                                      encoding: URLEncoding.default)
        case .getBookListByPath,
             .deleteBook,
             .getMusicByPath,
             .deleteMusic,
             .getLikes,
             .getDislikes:
            return .requestPlain
        case let .updateBookFull(_, title, description, publishedDate, imageLink, user),
             let .updateBookPartial(_, title, description, publishedDate, imageLink, user):
            return .requestParameters(parameters: ["title": title,
                                                   "description": description,
                                                   "published_date": publishedDate,
                                                   "image_link": imageLink,
                                                   "user": user],
                                      encoding: JSONEncoding.default)
        case let .createMusic(spotifyId, title, user),
             let .createMusicPlaylistTrack(spotifyId, title, user),
             let .createMusicPlaylists(spotifyId, title, user),
             let .createMusicToken(spotifyId, title, user),
             let .searchMusic(spotifyId, title, user),
             let .updateMusicFull(_, spotifyId, title, user),
             let .updateMusicPartial(_, spotifyId, title, user):
            return .requestParameters(parameters: ["spotify_id": spotifyId,
                                                   "title": title,
                                                   "user": user],
                                      encoding: JSONEncoding.default)
        case let .createFeedback(parameters),
             let .shareTutorial(parameters),
             let .updateMatchPreference(parameters),
             let .updateNotification(parameters),
             let .updateProfile(parameters),
             let .updateSettings(parameters):
            return .requestParameters(parameters: parameters,
                                      encoding: JSONEncoding.default)
        case let .addDislikes(dislikes), let .removeDislikes(dislikes):
            return .requestParameters(parameters: ["dislikes" : dislikes],
                                      encoding: JSONEncoding.default)
        case let .addLikes(likes), let .removeLikes(likes):
            return .requestParameters(parameters: ["likes" : likes],
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return NetworkManager.commonHeaders
    }
    
}

