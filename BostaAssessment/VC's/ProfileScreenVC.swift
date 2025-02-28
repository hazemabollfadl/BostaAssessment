//
//  ViewController.swift
//  BostaAssessment
//  Created by Hazem Abou El Fadl on 26/02/2025.

import UIKit

class ProfileScreenVC: UIViewController {
    
    
    @IBOutlet var listOfAlbumNames: UITableView!
    
    var userManager = UserManager()
    
    var albumManager = AlbumManager()
    
    var usefullFunctions = UsefulFunctions()
        
    
    var albumName: String?
    var userName: String?
    var userAddress: String?
    var albumTitle:[String] = []
 
    
    override func viewDidLoad() {
        listOfAlbumNames.delegate=self
        listOfAlbumNames.dataSource=self
        
        userManager.delegate=self
        albumManager.delegate=self
        
        
        userManager.fetchUsers(UserNumber: usefullFunctions.randomUser())
        albumManager.fetchAlbums(AlbumNumber: usefullFunctions.randomUser())
        
        
        let nib = UINib(nibName: "tableViewHeader", bundle: .main)
        listOfAlbumNames.register(nib, forHeaderFooterViewReuseIdentifier: "tableViewHeader")
        
        
    }
    
}

//MARK: - UITableViewDataSource
extension ProfileScreenVC:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albumTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listOfAlbumNames.dequeueReusableCell(withIdentifier: "TestCell")
        
        if indexPath.row < albumTitle.count {
            cell?.textLabel?.text = albumTitle[indexPath.row]
        }
        albumName=cell?.textLabel?.text
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = listOfAlbumNames.dequeueReusableHeaderFooterView(withIdentifier: "tableViewHeader")  as! tableViewHeader
        header.titleHeader.text=userName
        header.subTitleHeader.text=userAddress
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 125
    }
    
    
}

//MARK: - UITableViewDelegate
extension ProfileScreenVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "profileToAlbums", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileToAlbums" {
            if let destinationVC = segue.destination as? AlbumsVC{
                destinationVC.selectedAlbum = albumName
                destinationVC.selectedCellIndexPath = listOfAlbumNames.indexPathForSelectedRow
            }
        }
    }
}


//MARK: - UsersManagerDelegate
extension ProfileScreenVC:UsersManagerDelegate{
    func getUserData(user: UserModel) {
        DispatchQueue.main.async { [self] in
            userName = user.name
            userAddress = user.street + " ," + user.suite + " ," + user.city + " ," + user.zipcode
            listOfAlbumNames.reloadData()
        }
        
    }
}

//MARK: - AlbumsManagerDelegate
extension ProfileScreenVC:AlbumManagerDelegate{
    func getAlbumData(albums: [AlbumModel]) {
        DispatchQueue.main.async { [self] in
            for album in albums {
                albumTitle.append(album.title)
            }
            listOfAlbumNames.reloadData()
        }
    }
}


