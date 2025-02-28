//
//  WeatherManager.swift
//  BostaAssessment
//
//  Created by Hazem Abou El Fadl on 27/02/2025.
//

import UIKit

protocol PhotosManagerDelegate {
    func getPhotosData(photos: [PhotosModel])
}

struct PhotosManager {
    
    let PhotosURL = "https://jsonplaceholder.typicode.com/photos"
    
    var delegate: PhotosManagerDelegate?
    
    func fetchPhotos(PhotoNumber: Int) {
        performRequest(with: PhotosURL, albumId: 1)
    }
    
    func performRequest(with urlString: String, albumId: Int) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let photos = self.parseJSON(safeData, albumId: albumId) {
                        self.delegate?.getPhotosData(photos: photos)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ photosData: Data, albumId: Int) -> [PhotosModel]? {
        let decoder = JSONDecoder()

        do {
            let decodedData = try decoder.decode([PhotosData].self, from: photosData)
            
            let filteredPhotos = decodedData.filter { $0.albumId == albumId }
            
            let photos = filteredPhotos.map { PhotosModel(albumId: $0.albumId, id: $0.id, title: $0.title, url: $0.url, thumbnailUrl: $0.thumbnailUrl)}
            
            return photos
        } catch {
            print("Decoding error: \(error)")
            return nil
        }
    }
}
