//
//  WeatherManager.swift
//  BostaAssessment
//
//  Created by Hazem Abou El Fadl on 27/02/2025.
//

import UIKit

protocol AlbumManagerDelegate {
    func getAlbumData(albums: [AlbumModel]) 
}

struct AlbumManager {
    
    let AlbumsURL = "https://jsonplaceholder.typicode.com/albums"
    
    var delegate: AlbumManagerDelegate?
    
    func fetchAlbums(AlbumNumber: Int) {
        performRequest(with: AlbumsURL, userId: 1)
    }
    
    func performRequest(with urlString: String, userId: Int) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let albums = self.parseJSON(safeData, userId: userId) {
                        self.delegate?.getAlbumData(albums: albums)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ albumData: Data, userId: Int) -> [AlbumModel]? {
        let decoder = JSONDecoder()
          
        do {
            let decodedData = try decoder.decode([AlbumData].self, from: albumData)
            
            let filteredAlbums = decodedData.filter { $0.userId == userId }
            
            let albums = filteredAlbums.map { AlbumModel(id: $0.id, title: $0.title, userId: $0.userId) }
            
            return albums
        } catch {
            print("Decoding error: \(error)")
            return nil
        }
    }
}
