//
//  APIService.swift
//  MovieApp
//
//  Created by Yunus Emre Koca on 29.08.2022.
//

import Foundation

final class APIService {
    
    static let shared = APIService()
    
    private init() {}
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], APIError>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)&language=tr-TR") else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.connectionError))
                return
            }
            
            guard let trendMovies = try? JSONDecoder().decode(Movies.self, from: data) else {
                completion(.failure(APIError.decodeError))
                return
            }
            
            completion(.success(trendMovies.results))
        }.resume()
    }
    
    
    func getTrendingTVShows(completion: @escaping (Result<[Movie], APIError>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)&language=tr-TR") else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.connectionError))
                return
            }
            
            guard let trendTVShows = try? JSONDecoder().decode(Movies.self, from: data) else {
                completion(.failure(APIError.decodeError))
                return
            }
            
            completion(.success(trendTVShows.results))
        }.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Movie], APIError>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=tr-TR&page=1") else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.connectionError))
                return
            }
            
            guard let upcomingMovies = try? JSONDecoder().decode(Movies.self, from: data) else {
                completion(.failure(APIError.decodeError))
                return
            }
            
            completion(.success(upcomingMovies.results))
        }.resume()
    }
    
    func getPopularMovies(completion: @escaping (Result<[Movie], APIError>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=tr-TR&page=1") else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.connectionError))
                return
            }
            
            guard let popularMovies = try? JSONDecoder().decode(Movies.self, from: data) else {
                completion(.failure(APIError.decodeError))
                return
            }
            
            completion(.success(popularMovies.results))
        }.resume()
    }
    
    func getTopRatedMovies(completion: @escaping (Result<[Movie], APIError>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=tr-TR&page=1") else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.connectionError))
                return
            }
            
            guard let topRatedMovies = try? JSONDecoder().decode(Movies.self, from: data) else {
                completion(.failure(APIError.decodeError))
                return
            }
            
            completion(.success(topRatedMovies.results))
        }.resume()
    }
    
    func getTrailerLinkFromYoutube(with query: String, completion: @escaping (Result<Trailer, APIError>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.youtubeBaseURL)?q=\(query)&key=\(Constants.youtube_API_KEY)") else { return }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.connectionError))
                return
            }
            
            guard let trailers = try? JSONDecoder().decode(Trailers.self, from: data) else {
                completion(.failure(APIError.decodeError))
                return
            }
            
            guard let firstTrailer = trailers.items.first else {
                completion(.failure(APIError.decodeError))
                return
            }
            
            completion(.success(firstTrailer))
        }.resume()
    }
    
    func getPopularContents(completion: @escaping (Result<[Movie], APIError>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/all/day?api_key=\(Constants.API_KEY)&language=tr-TR") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.connectionError))
                return
            }
            
            guard let contents = try? JSONDecoder().decode(Movies.self, from: data) else {
                completion(.failure(APIError.decodeError))
                return
            }
            
            completion(.success(contents.results))
        }.resume()
    }
    
    func queryForContent(query: String, completion: @escaping (Result<[Movie], APIError>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseURL)/3/search/multi?api_key=\(Constants.API_KEY)&language=tr-TR&query=\(query)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.connectionError))
                return
            }
            
            guard let contents = try? JSONDecoder().decode(Movies.self, from: data) else {
                completion(.failure(APIError.decodeError))
                return
            }
            
            completion(.success(contents.results))
        }.resume()
    }
}
