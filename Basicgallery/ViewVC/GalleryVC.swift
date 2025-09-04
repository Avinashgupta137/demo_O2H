//
//  GalleryVC.swift
//  Basicgallery
//
//  Created by Sanskar IOS Dev on 04/09/25.
//

import UIKit
import Kingfisher
import Firebase
import GoogleSignIn

class GalleryVC: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    
    @IBOutlet weak var CollectionView: UICollectionView!
    
    private var viewModel = GalleryViewModel()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           setupUI()
           bindViewModel()
           viewModel.loadArticles()
       }
       
       private func setupUI() {
           navigationItem.setHidesBackButton(true, animated: true)
           lblemail.text = UserModel.loadFromUserDefaults()?.fullName
           lblName.text = UserModel.loadFromUserDefaults()?.emailAddress
           
           if let profilePicURL = UserModel.loadFromUserDefaults()?.profilePicURL {
               profileImageView.kf.setImage(with: profilePicURL)
           }
           
           if let layout = CollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
               layout.minimumInteritemSpacing = 10
               layout.minimumLineSpacing = 10
           }
       }
       
       private func bindViewModel() {
           viewModel.onDataChanged = { [weak self] _ in
               self?.CollectionView.reloadData()
           }
           
           viewModel.onError = { errorMessage in
               print("Error: \(errorMessage)")
           }
       }
    
    @IBAction func logOutbtn(_ sender: Any) {
        GIDSignIn.sharedInstance.signOut()
        UserModel.clearUserDefaults() 
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let navController = UINavigationController(rootViewController: loginVC)
            sceneDelegate.window?.rootViewController = navController
        }
    }
    
}
//MARK: - COLLECTIONVIEW
extension GalleryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
        let article = viewModel.articles[indexPath.row]
        if let imageUrl = URL(string: article.urlToImage ?? "") {
            cell.imgCollection.kf.setImage(with: imageUrl)
        }
        return cell
    }
}
