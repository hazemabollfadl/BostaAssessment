//
//  Albums.swift
//  BostaAssessment
//
//  Created by Hazem Abou El Fadl on 26/02/2025.
//

import UIKit

class AlbumsVC: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var albumsCollectionView: UICollectionView!
    
    var photosManager = PhotosManager()
    var photosArray:[PhotosModel] = []
    var selectedAlbum: String?
    var selectedCellIndexPath: IndexPath?
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumsCollectionView.delegate=self
        albumsCollectionView.dataSource=self
        searchBar.delegate=self
        
        photosManager.delegate=self
        photosManager.fetchPhotos(PhotoNumber: selectedCellIndexPath?.row ?? 0)
        
        let nib = UINib(nibName: "AlbumsCell", bundle: .main)
        albumsCollectionView.register(nib, forCellWithReuseIdentifier: "AlbumsCell")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)
        
        navigationItem.title = selectedAlbum
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
}

//MARK: - UICollectionViewDataSource
extension AlbumsVC:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.reloadData()
        return photosArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = albumsCollectionView.dequeueReusableCell(withReuseIdentifier: "AlbumsCell", for: indexPath) as! AlbumsCell
        
            if indexPath.row < photosArray.count {
                if let image = UIImage(contentsOfFile: photosArray[indexPath.row].url) {
                    cell.albumImages.image = image
                } else {
                    cell.albumImages.image=UIImage(named: "DummyPhoto")
                }
            }
        if isSearching{
            if photosArray[indexPath.row].id == Int(searchBar.text!){
                cell.albumImages.alpha=1
            }else{
                cell.albumImages.alpha=0.5
            }
        }else{
            cell.albumImages.alpha=1
        }

        return cell

    }
    
    
}

//MARK: - UICollectionViewDelegate
extension AlbumsVC:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = UIImage(contentsOfFile: photosArray[indexPath.row].url) ?? UIImage(named: "DummyPhoto")
        let imageViewerVC = ImageViewerController()
        imageViewerVC.selectedImage = selectedImage
        navigationController?.pushViewController(imageViewerVC, animated: true)
    }
    
    
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension AlbumsVC:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.bounds.width/3), height: (collectionView.bounds.width/3))
    }
    
}

//MARK: - AlbumsManagerDelegate
extension AlbumsVC:PhotosManagerDelegate{
    func getPhotosData(photos: [PhotosModel]) {
        DispatchQueue.main.async { [self] in
            for photo in photos {
                photosArray.append(photo)
            }
            albumsCollectionView.reloadData()
        }
    }
}

//MARK: - UISearchBarDelegate
extension AlbumsVC:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange: String){
        if searchBar.text?.isEmpty==true{
            isSearching=false
            albumsCollectionView.reloadData()
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        print("User began editing")
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar){
        albumsCollectionView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        isSearching=true
        
        if searchBar.text==""{
            let alert = UIAlertController(title: "Warning", message: "Enter value to search", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default))
            self.present(alert, animated: true, completion: nil)
            isSearching=false
        }else{
            searchBar.endEditing(true)
        }
        
    }
    
}

