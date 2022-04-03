//
//  SpotifyService.swift
//  Elated
//
//  Created by Marlon on 5/24/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Moya

enum SpotifyService {
    case getArtists(page: Int)
    case addArtist(spotifyId: Int, name: String)
    case searchArtist(spotifyId: Int, name: String)
    case getArtist(id: Int)
    case updateArtistPartial(id: Int, spotifyId: Int, name: String)
    case updateArtistFull(id: Int, spotifyId: Int, name: String)
    case deleteArtist(id: Int)
    case getUserArtists(page: Int)
    case addUserArtist(parameters: [String: Any])
    case getUserCommonArtists(id: Int, page: Int)
    case getUserTopArtists(page: Int)
    case getUserSavedTopArtists(page: Int)
    case getUserArtist(id: Int)
    case updateUserArtistPartial(id: Int, parameters: [String: Any])
    case updateUserArtistFull(id: Int, parameters: [String: Any])
    case deleteUserArtist(id: Int)
    case getUserPlaylists(page: Int)
    case addUserPlaylist(parameters: [String: Any])
    case getUserGetPlaylists(page: Int)
    case getUserSavedPlaylists(page: Int)
    case getUserPlaylist(id: Int)
    case updateUserPlaylistPartial(id: Int, parameters: [String: Any])
    case updateUserPlaylistFull(id: Int, parameters: [String: Any])
    case deleteUserPlaylist(id: Int)
    case getUserTracks(page: Int)
    case addUserTrack(parameters: [String: Any])
    case getUserCommonTracks(id: Int, page: Int)
    case getUserLikedSongs(page: Int)
    case getUserTopTracks(page: Int)
    case getUserSaveLikedSongs(page: Int)
    case getUserSaveTopTracks(page: Int)
    case getUserTrack(id: Int)
    case updateUserTrackPartial(id: Int, parameters: [String: Any])
    case updateUserTrackFull(id: Int, parameters: [String: Any])
    case deleteUserTrack(id: Int)
}

extension SpotifyService: TargetType {
    
    var baseURL: URL {
        return URL(string: Environment.rootURLString + "/api/v1/social_integrations/spotify")!
    }
    
    var path: String {
        //TODO: Remove the stupid "/" at the end after the API is fixed
        switch self {
        case .getArtists,
             .addArtist:
            return "/artist/"
        case .searchArtist:
            return "/artist/search_artist/"
        case let .getArtist(id),
             let .updateArtistPartial(id, _, _),
             let .updateArtistFull(id, _, _),
             let .deleteArtist(id):
            return "/artist/\(id)/"
        case let .getUserArtist(id),
             let .updateUserArtistFull(id, _),
             let .updateUserArtistPartial(id, _),
             let .deleteUserArtist(id):
            return "/artist/user/\(id)/"
        case .addUserArtist,
             .getUserArtists:
            return "/user/artist/"
        case let .getUserCommonArtists(id, _):
            return "/user/artist/get_common_artists/\(id)/"
        case .getUserTopArtists:
            return "/user/artist/get_top_artists/"
        case .getUserSavedTopArtists:
            return "/user/artist/save_top_artists/"
        case .getUserPlaylists,
             .addUserPlaylist:
            return "/user/playlist/"
        case .getUserGetPlaylists:
            return "/user/playlist/get_playlists/"
        case .getUserSavedPlaylists:
            return "/user/playlist/save_playlists/"
        case let .getUserPlaylist(id),
             let .updateUserPlaylistPartial(id, _),
             let .updateUserPlaylistFull(id, _),
             let .deleteUserPlaylist(id):
            return "/user/playlist/\(id)/"
        case .getUserTracks,
             .addUserTrack:
            return "/user/track/"
        case let .getUserCommonTracks(id, _):
            return "/user/track/get_common_tracks/\(id)/"
        case .getUserLikedSongs:
             return "/user/track/get_liked_songs/"
        case .getUserTopTracks:
            return "/user/track/get_top_tracks/"
        case .getUserSaveLikedSongs:
            return "/user/track/save_liked_songs/"
        case .getUserSaveTopTracks:
            return "/user/track/save_top_tracks/"
        case let .getUserTrack(id),
             let .updateUserTrackPartial(id, _),
             let .updateUserTrackFull(id, _),
             let .deleteUserTrack(id):
            return "/user/track/\(id)/"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getArtists,
             .getArtist,
             .getUserArtists,
             .getUserCommonArtists,
             .getUserTopArtists,
             .getUserSavedTopArtists,
             .getUserArtist,
             .getUserPlaylists,
             .getUserGetPlaylists,
             .getUserSavedPlaylists,
             .getUserPlaylist,
             .getUserTracks,
             .getUserCommonTracks,
             .getUserLikedSongs,
             .getUserTopTracks,
             .getUserSaveLikedSongs,
             .getUserSaveTopTracks,
             .getUserTrack:
            return .get
        case .searchArtist,
             .addArtist,
             .addUserArtist,
             .addUserPlaylist,
             .addUserTrack:
            return .post
        case .updateArtistPartial,
             .updateUserArtistPartial,
             .updateUserPlaylistPartial,
             .updateUserTrackPartial:
            return .put
        case .updateArtistFull,
             .updateUserArtistFull,
             .updateUserPlaylistFull,
             .updateUserTrackFull:
            return .patch
        case .deleteArtist,
             .deleteUserArtist,
             .deleteUserPlaylist,
             .deleteUserTrack:
            return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getArtists,
             .getArtist,
             .deleteArtist,
             .getUserArtist,
             .deleteUserArtist,
             .deleteUserPlaylist,
             .getUserCommonTracks,
             .getUserTrack,
             .deleteUserTrack:
            return .requestPlain
        case let .getUserArtists(page),
             let .getUserCommonArtists(_, page),
             let .getUserTopArtists(page),
             let .getUserSavedTopArtists(page),
             let .getUserPlaylists(page),
             let .getUserGetPlaylists(page),
             let .getUserSavedPlaylists(page),
             let .getUserPlaylist(page),
             let .getUserTracks(page),
             let .getUserLikedSongs(page),
             let .getUserTopTracks(page),
             let .getUserSaveLikedSongs(page),
             let .getUserSaveTopTracks(page):
            return .requestParameters(parameters: ["page": page],
                                      encoding: URLEncoding.default)
        case let .addArtist(spotifyId, name),
             let .searchArtist(spotifyId, name),
             let .updateArtistPartial(_, spotifyId, name),
             let .updateArtistFull(_, spotifyId, name):
            return .requestParameters(parameters: ["spotify_id": spotifyId, "name": name],
                                      encoding: JSONEncoding.default)
        case let .addUserArtist(parameters),
             let .updateUserArtistPartial(_, parameters),
             let .updateUserArtistFull(_, parameters),
             let .addUserPlaylist(parameters),
             let .updateUserPlaylistPartial(_, parameters),
             let .updateUserPlaylistFull(_, parameters),
             let .addUserTrack(parameters),
             let .updateUserTrackPartial(_, parameters),
             let .updateUserTrackFull(_, parameters):
            return .requestParameters(parameters: parameters,
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return NetworkManager.commonHeaders
        }
    }
    
}

