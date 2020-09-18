//
//  InsidePackViewController.swift
//  Cleanse
//
//  Created by Alek Matthiessen on 9/9/20.
//  Copyright © 2020 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase
import Kingfisher
import Kingfisher
import Photos
import MBProgressHUD
import FBSDKCoreKit
import Alamofire
import AlamofireImage

class InsidePackViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var taphow: UIButton!
    
    @IBAction func tapHOw(_ sender: Any) {
        
        self.performSegue(withIdentifier: "InsideToHow", sender: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        textone = ""
        texttwo = ""
        textthree = ""
        
        if didpurchase {
            
            taphow.alpha = 1
            
        } else {
            
            taphow.alpha = 0
        }
        
        MBProgressHUD.hide(for: view, animated: true)
        
        
    }
    
    var books: [Book] = [] {
        didSet {
            
            titleCollectionView.alpha = 1
            
            titleCollectionView.reloadData()
            
            
        }
    }
    
    @IBAction func tapBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var packName: UILabel!
    @IBOutlet weak var titleCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        packName.text = selectedgenre
        
        ref = Database.database().reference()
        
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        
        
        var screenSize = titleCollectionView.bounds
        var screenWidth = screenSize.width
        var screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: screenWidth/1.1, height: screenWidth/0.7)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        titleCollectionView!.collectionViewLayout = layout
        
        referrer = selectedbookid
        
        referrer = "InsidePack"
        
        
        queryforids { () -> Void in
            
        }
        // Do any additional setup after loading the view.
    }
    
    func queryforids(completed: @escaping (() -> Void) ) {
        
        titleCollectionView.alpha = 0
        
        var functioncounter = 0
        
        
        ref?.child("fb-ads-filter").child(selectedgenre).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            print (value)
            
            if let snapDict = snapshot.value as? [String: AnyObject] {
                
                let genre = Genre(withJSON: snapDict)
                
                if let newbooks = genre.books {
                    
                    self.books = newbooks
                    
                    self.books = self.books.sorted(by: { $0.popularity ?? 0  > $1.popularity ?? 0 })
                    
                }
                
            }
            
        })
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL){
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let _ = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            //let ab = url.absoluteString
            
            // let image : UIImage = UIImage(data: data!)!
            
            
            print("Download Finished", url.lastPathComponent)
            
            let Url = url.absoluteURL
            
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let fileURL = documentsURL.appendingPathComponent("\(url.lastPathComponent)")
            
            do {
                try data?.write(to: fileURL, options: [])
            } catch {
                print("Unable to write DNG file.")
                return
            }
            
            let filePath = documentsURL.appendingPathComponent("\(url.lastPathComponent)").path
            
            var assetObj:PHFetchResult<PHAsset>!
            
            DispatchQueue.global(qos: .userInitiated).async {
                let options = PHFetchOptions()
                options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
                options.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d ", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
                options.includeAllBurstAssets = false
                options.includeHiddenAssets = true
                
                let fileString = url.lastPathComponent
                
                let fetchResults = PHAsset.fetchAssets(with: options)
                
                DispatchQueue.main.async {
                    assetObj = fetchResults
                    print("Loaded \(fetchResults.count) images.")
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if(assetObj != nil){
                        
                        let temporaryDNGFileURL = URL(fileURLWithPath: filePath)
                        
                        let options = PHImageRequestOptions()
                        
                        options.isSynchronous = false
                        options.version = .current
                        options.deliveryMode = .opportunistic
                        options.resizeMode = .none
                        options.isNetworkAccessAllowed = false
                        
                        guard assetObj.count > 0 else { return }
                        
                        PHImageManager.default().requestImageData(for: assetObj.lastObject!, options: options, resultHandler: {
                            imageData, dataUTI, imageOrientation, info in
                            
                            let assetURL = temporaryDNGFileURL
                            _ = assetURL.pathExtension
                            
                            
                            // try? imageData?.write(to: temporaryDNGFileURL)
                            
                        })
                        
                        let shareAll = [temporaryDNGFileURL] as [Any]
                        
                        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                        
                        //                        activityViewController.popoverPresentationController?.sourceView = self.view
                        
                        
                        //                        self.present(activityViewController, animated: true, completion: nil)
                        
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            // The app is running on an iPad, so you have to wrap it in a UIPopOverController
                            
                            activityViewController.modalPresentationStyle = .popover
                            let screen = UIScreen.main.bounds
                            
                            let view: UIView = UIView(frame: CGRect(x: 0, y: Int(screen.height) - 250, width: Int(screen.width), height: 250));
                            activityViewController.popoverPresentationController?.sourceView = view
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                            
                            self.present(activityViewController, animated: true, completion: nil)
                        } else {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            
                            self.present(activityViewController, animated: true, completion: nil)
                            
                        }
                    }
                    
                }
            }
            
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        self.view.endEditing(true)
        titleCollectionView.isUserInteractionEnabled = true
        
        
        logUsePressed(referrer: referrer)
        
        let book = self.book(atIndexPath: indexPath)
        
        //print("CELL ITEM===>", book ?? [])
        
        
        
        headlines.removeAll()
        
        bookindex = indexPath.row
        selectedauthorname = book?.author ?? ""
        selectedtitle = book?.name ?? ""
        selectedurl = book?.audioURL ?? ""
        selectedbookid = book?.bookID ?? ""
        selectedgenre = book?.genre ?? ""
        selectedamazonurl = book?.amazonURL ?? ""
        selecteddescription = book?.description ?? ""
        selectedduration = book?.duration ?? 15
        selectedheadline = book?.headline1 ?? ""
        selectedprofession = book?.profession ?? ""
        selectedauthorimage = book?.authorImage ?? ""
        selectedbackground = book?.imageURL ?? ""
        selectedbeforeimage = book?.before ?? ""
        selectedafterimage = book?.imageURL ?? ""
        selecteddownload = book?.download ?? ""
        
        headlines.append(book?.headline1 ?? "x")
        headlines.append(book?.headline2 ?? "x")
        headlines.append(book?.headline3 ?? "x")
        headlines.append(book?.headline4 ?? "x")
        headlines.append(book?.headline5 ?? "x")
        headlines.append(book?.headline6 ?? "x")
        headlines.append(book?.headline7 ?? "x")
        headlines.append(book?.headline8 ?? "x")
        
        headlines = headlines.filter{$0 != "x"}
        
        
        
        
        if didpurchase {
            let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)

            
            var path = String()
            //
            if let resourcePath = Bundle.main.resourcePath {
                let imgName = "Summer1"
                path = resourcePath + "/" + imgName
            }
            
            let file = NSURL(string: selecteddownload);
            
            downloadImage(from:file! as URL)
            
            ref?.child(uid).child("Favorites").child(selectedbookid).updateChildValues(["filter_name": selectedtitle, "download_image_url" : selecteddownload, "image_url" : selectedafterimage])
            
            
        } else {
            self.performSegue(withIdentifier: "InsideToSale", sender: self)
            
        }
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return books.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let book = self.book(atIndexPath: indexPath)
        titleCollectionView.alpha = 1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Books", for: indexPath) as! TitleCollectionViewCell
        //
        //            if book?.bookID == "Title" {
        //
        //                return cell
        //
        //            } else {
        
        if didpurchase {
            
            cell.lockimage.alpha = 0
        } else {
            
            cell.lockimage.alpha = 0.35
            
        }
        
//        if indexPath.row == 0 {
            
            cell.leadinglabel.alpha = 1
            
//        } else {
//            cell.leadinglabel.alpha = 0
//            
//        }
        
        cell.beforeimge.alpha = 0
        
        
        //                            cell.taphold.tag = indexPath.row
        //
        //                            cell.taphold.addTarget(self, action: #selector(DiscoverViewController.tapWishlist), for: .touchUpInside)
        //
        let name = book?.name
        
        
        
        cell.titlelabel.text = name
        
        
        
        //                    cell.tapup.tag = indexPath.row
        //
        //                    cell.tapup.addTarget(self, action: #selector(DiscoverViewController.tapWishlist), for: .touchUpInside)
        
        if let imageURLString = book?.imageURL, let imageUrl = URL(string: imageURLString) {
            
            
            let image = UIImage(named: "Artboard-1")
            cell.titleImage.kf.setImage(with: imageUrl, placeholder: image)
            
            
            //cell.titleImage.kf.setImage(with: imageUrl)
            //                        cell.titleImage.kf.setImage(with: imageUrl)
            
            MBProgressHUD.hide(for: view, animated: true)
            
            
            
            
        }
        
        
        if let imageURLString2 = book?.before, let imageUrl2 = URL(string: imageURLString2) {
            
            cell.beforeimge.kf.setImage(with: imageUrl2)
            
        }
        
        
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        
        cell.titlelabel.alpha = 1
        cell.titlelabel.alpha = 1
        
        if book?.views != nil {
            
            
            
            cell.viewslabel.text = "\(book!.views!)"
            
            
        } else {
            
            //                        var randomInt = Int.random(in:100..<900)
            //
            //
            //                        ref?.child("fb-ads-filter").child(selectedgenre).child(book!.bookID).updateChildValues(["Views" : "\(randomInt)k"])
            
            
            cell.viewslabel.text = "1.3M"
            
        }
        
        
        
        
        return cell
        
    }
    
    @objc func tapWishlist(sender: UIButton) {
        
        
        
        let book = self.book(atIndex: sender.tag)
        
        
        let author = book?.author
        let name = book?.name
        let imageURL = book?.imageURL
        let bookID = book?.bookID
        let selectedduration = book?.duration ?? 15
        let amazonlink = book?.amazonURL ?? ""
        let originals = book?.original ?? "No"
        let description = book?.description
        
        if let index = wishlistids.index(of: bookID!) {
            
            wishlistids.remove(at: index)
            
            ref?.child("Users").child(uid).child("Wishlist").child(bookID!).removeValue()
            
            titleCollectionView.reloadData()
            
        } else {
            
            ref?.child("Users").child(uid).child("Wishlist").child(bookID!).updateChildValues(["Author": author, "Name": name, "Image": imageURL, "Genre": selectedgenre, "Description": description, "Duration": selectedduration, "Amazon": amazonlink, "Original" : originals])
            
            wishlistids.append(bookID!)
            
            titleCollectionView.reloadData()
            
            
        }
        
    }
    
    func logUsePressed(referrer : String) {
        AppEvents.logEvent(AppEvents.Name(rawValue: "use pressed"), parameters: ["referrer" : referrer, "bookID" : selectedbookid, "genre" : selectedgenre])
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension InsidePackViewController {
      func book(atIndex index: Int) -> Book? {
          if index > books.count - 1 {
              return nil
          }

          return books[index]
      }

      func book(atIndexPath indexPath: IndexPath) -> Book? {
          return self.book(atIndex: indexPath.row)
      }
  }

