//
//  FFavoritesViewController.swift
//  Cleanse
//
//  Created by Alek Matthiessen on 6/5/20.
//  Copyright © 2020 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase
import Kingfisher
import Photos
import MBProgressHUD

class FFavoritesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

  var counter = 0
                //
                var books: [Book] = [] {
                    didSet {

                        self.titleCollectionView.reloadData()

                    }
                }
            
            override func viewDidAppear(_ animated: Bool) {
                
                textone = ""
                texttwo = ""
                textthree = ""

            }

                @IBOutlet var searchField: UITextField!

                @IBOutlet weak var tapback: UIButton!
                @IBOutlet weak var tapbuton: UIButton!
                @IBAction func tapBack(_ sender: Any) {

                    titleCollectionView.alpha = 0

                    if counter > 1 {

                        tapbuton.alpha = 1
                        counter -= 1


                        tapgenre.text = genres[counter]
                        selectedgenre = genres[counter]
              

                        queryforids { () -> Void in


                        }
                        

                        tapbuton.alpha = 0.25

                    } else {

                        counter -= 1


                        tapgenre.text = genres[counter]
                        selectedgenre = genres[counter]
              
                        queryforids { () -> Void in


                        }

                        tapback.alpha = 0

                    }

                }
            
            func queryforinfo() {
                        
                ref?.child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? NSDictionary
                    
                    if let purchased = value?["Purchased"] as? String {
                        
                        if purchased == "True" {
                            
                            didpurchase = true
                            
                        } else {
                                         
                            didpurchase = true
                            self.performSegue(withIdentifier: "FFavoritesToSale", sender: self)
                            
                        }
                        
                    } else {
                        
                        didpurchase = true
                      self.performSegue(withIdentifier: "FFavoritesToSale", sender: self)
                    }
             
                })
                
            }

                @IBAction func tapGenre(_ sender: Any) {

                    titleCollectionView.alpha = 0

                    if counter < genres.count-1 {

                        tapbuton.alpha = 0.25


                        tapgenre.text = genres[counter]
                        selectedgenre = genres[counter]
          
                        queryforids { () -> Void in

                        }

                        tapback.alpha = 0.25

                    } else {

                        tapbuton.alpha = 0

                    }
                }
    
    var genres = [String]()

                @IBOutlet weak var tapgenre: UILabel!
                @IBOutlet weak var tapselectedgenre: UIButton!
                @IBOutlet weak var titleCollectionView: UICollectionView!

                var swipecounter = Int()

                let swipeRightRec = UISwipeGestureRecognizer()
                let swipeLeftRec = UISwipeGestureRecognizer()
                let swipeUpRec = UISwipeGestureRecognizer()
                let swipeDownRec = UISwipeGestureRecognizer()

                func textFieldDidBeginEditing(_ textField: UITextField) {

                    titleCollectionView.isUserInteractionEnabled = false

                }

                @objc func swipeR() {

                    swipecounter += 1
                    selectedindex = swipecounter

                    genreCollectionView.reloadData()

                }

                @objc func swipeL() {

                    swipecounter -= 1
                    selectedindex = swipecounter
                    genreCollectionView.reloadData()

                }

                var intdayofweek = Int()

                @IBOutlet var darklabel: UILabel!

                func textFieldShouldReturn(_ textField: UITextField) -> Bool {

                    print(searchField.text!)

                    darklabel.alpha = 0
                    titleCollectionView.isUserInteractionEnabled = true

                    if searchField.text != "" {

                        text = searchField.text!

                        self.view.endEditing(true)

                   

                        queryforsearch()

                    } else {

                    }

                    return true
                }

                override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

                    self.view.endEditing(true)

                    titleCollectionView.isUserInteractionEnabled = true

                }

                @objc func loadList(notification: NSNotification) {

                    self.titleCollectionView.reloadData()

                }

                var mycolors = [UIColor]()

            @IBOutlet weak var backimage: UIImageView!
        
            override func viewDidLoad() {
                    super.viewDidLoad()

                    ref = Database.database().reference()

                    
                genres.removeAll()

                    selectedgenre = "Influencers"
                
                    let date = Date()
                      let dateFormatter = DateFormatter()
                      dateFormatter.dateFormat = "MMM d"
                      let result = dateFormatter.string(from: date)

                      dateformat = result


                    NotificationCenter.default.addObserver(self, selector: #selector(loadList(notification:)), name: NSNotification.Name(rawValue: "load"), object: nil)

                    titleCollectionView.reloadData()

                    //        addstaticbooks()



                    //        dayofmonth = "15"

                    musictimer?.invalidate()
                    
                    updater?.invalidate()
                    player?.pause()

                    var screenSize = titleCollectionView.bounds
                    var screenWidth = screenSize.width
                    var screenHeight = screenSize.height

                    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                    layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                layout.itemSize = CGSize(width: screenWidth/1.1, height: screenWidth/0.7)
                    layout.minimumInteritemSpacing = 0
                    layout.minimumLineSpacing = 0

                    titleCollectionView!.collectionViewLayout = layout

                    queryforids { () -> Void in

                    }

                    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
                    swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
                    self.view.addGestureRecognizer(swipeLeft)

                    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
                    swipeRight.direction = UISwipeGestureRecognizer.Direction.right
                    self.view.addGestureRecognizer(swipeRight)

                    counter = 0


                    // Do any additional setup after loading the view.
                }

            @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

                if let swipeGesture = gesture as? UISwipeGestureRecognizer {

                    switch swipeGesture.direction {
                    case UISwipeGestureRecognizer.Direction.right:

                        if selectedindex > 0 {

                            selectedindex = selectedindex - 1

                            selectedgenre = genres[selectedindex]

                            

                            queryforids { () -> Void in

                            }

                            genreCollectionView.reloadData()

                        }

                    case UISwipeGestureRecognizer.Direction.down:
                        break
                    case UISwipeGestureRecognizer.Direction.left:

                        if selectedindex < 3 {

                            selectedindex = selectedindex + 1

                            selectedgenre = genres[selectedindex]


                            queryforids { () -> Void in

                            }


                            genreCollectionView.reloadData()

                        }
                    case UISwipeGestureRecognizer.Direction.up:
                        break
                    default:
                        break
                    }
                }
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
            
            var genreindex = Int()
                var text = String()

                func queryforsearch() {

                    text = text.capitalized

                    print(text)

                    ref?.child("AllBooks3").child("All").queryOrdered(byChild: "Name").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").observeSingleEvent(of: .value, with: { (snapshot) in

                        var value = snapshot.value as? NSDictionary

                        print (value)

                        if let snapDict = snapshot.value as? [String: AnyObject] {

                            let genre = Genre(withJSON: snapDict)

                            if let newbooks = genre.books {

                                self.books = newbooks

                                print(self.books)

                                self.titleCollectionView.reloadData()
                                self.selectedindex = 1000
                                referrer = "Search"
                                selectedgenre = ""

                                self.genreCollectionView.reloadData()

                            }

                        } else {

                            self.books.shuffle()
                            self.titleCollectionView.reloadData()

                        }

                    })
                }

                func queryforids(completed: @escaping (() -> Void) ) {

                    titleCollectionView.alpha = 0

                    var functioncounter = 0

         

                    ref?.child(uid).child("Favorites").observeSingleEvent(of: .value, with: { (snapshot) in

                        var value = snapshot.value as? NSDictionary

                        print (value)

                        if let snapDict = snapshot.value as? [String: AnyObject] {

                            let genre = Genre(withJSON: snapDict)

                            if let newbooks = genre.books {

                                self.books = newbooks

                                self.books = self.books.sorted(by: { $0.popularity ?? 0  > $1.popularity ?? 0 })

                            }

            //                                for each in snapDict {
            //
            //                                    functioncounter += 1
            //
            //                                    let ids = each.key
            //
            //                                    seemoreids.append(ids)
            //
            //
            //                                    if functioncounter == snapDict.count {
            //
            //                                        self.updateaudiostructure()
            //
            //                                    }
            //                                }

                        }

                    })
                }

                func queryforwishlists() {

                    wishlistids.removeAll()
                    var functioncounter = 0

                    ref?.child("Users").child(uid).child("Wishlist").observeSingleEvent(of: .value, with: { (snapshot) in

                        var value = snapshot.value as? NSDictionary

                        print (value)

                        if let snapDict = snapshot.value as? [String: AnyObject] {

                            for each in snapDict {

                                let ids = each.key

                                wishlistids.append(ids)

                                functioncounter += 1

                                if functioncounter == snapDict.count {

                                    self.titleCollectionView.reloadData()
                                }

                            }
                        }
                    })

                }

             

                

                var dayofmonth = String()

                func addstaticbooks() {

                    selectedgenre = "Love"

                    var counter2 = 7

                    while counter2 < 12 {

                        ref?.child("AllBooks1").child(selectedgenre).child("\(counter2)").updateChildValues(["Author": "Jordan B. Peterson", "BookID": "\(counter2)", "Description": "What does everyone in the modern world need to know? Renowned psychologist Jordan B. Peterson's answer to this most difficult of questions uniquely combines the hard-won truths of ancient tradition with the stunning revelations of cutting-edge scientific research.", "Genre": "\(selectedgenre)", "Image": "F\(counter2)", "Name": "12 Rules for Life", "Completed": "No", "Views": "x", "AmazonURL": "https://www.amazon.com/b?ie=UTF8&node=17025012011"])

                        //    ref?.child("AllBooks2").child(selectedgenre).child("\(counter2)").updateChildValues([ "Views" : "\(nineviews[counter2])"])

                        ref?.child("AllBooks1").child(selectedgenre).child("\(counter2)").child("Summary").child("Text").updateChildValues(["1": "x", "2": "x", "3": "x", "4": "x", "5": "x", "6": "x", "7": "x", "8": "x", "9": "x", "10": "x", "11": "x", "12": "x", "13": "x", "14": "x", "15": "x", "16": "x", "17": "x", "18": "x", "19": "x", "20": "x", "Title": "x"])

                        counter2 += 1

                    }

                }

                override func didReceiveMemoryWarning() {
                    super.didReceiveMemoryWarning()
                    // Dispose of any resources that can be recreated.
                }

                func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                    
                    refer = "On Tap Discover"

                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()
                    self.view.endEditing(true)
                    titleCollectionView.isUserInteractionEnabled = true

                    if collectionView.tag == 1 {

                        selectedindex = indexPath.row

                        genreCollectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)

                        collectionView.alpha = 0

                        selectedgenre = genres[indexPath.row]
                        
                        
                        genreindex = indexPath.row

                        queryforids { () -> Void in

                        }

            //            titleCollectionView.scrollToItem(at: indexPath, at: .top, animated: false)
                        

                        genreCollectionView.reloadData()

                    } else {

                        let book = self.book(atIndexPath: indexPath)
                        
                        //print("CELL ITEM===>", book ?? [])
                        
                        headlines.removeAll()
                        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)

                        bookindex = indexPath.row
                        selectedauthorname = book?.author ?? ""
                        selectedtitle = book?.inspiredby ?? ""
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
                        selectedafterimage = book?.after ?? ""
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
                                    
                                    
                                    var path = String()
                                    //
                                    if let resourcePath = Bundle.main.resourcePath {
                                        let imgName = "Summer1"
                                        path = resourcePath + "/" + imgName
                                    }
                                    
                                    let file = NSURL(string: selecteddownload);
                                    
                                    downloadImage(from:file! as URL)
                                } else {
                                     self.performSegue(withIdentifier: "FFavoritesToSale", sender: self)

                                }
                                
                            }

                     

                }

                private var contentOffset: CGPoint?

                override func viewWillAppear(_ animated: Bool) {
                    super.viewWillAppear(animated)

                }

                func organizebyalphabetical() {

                    titleCollectionView.reloadData()

                }

                @IBOutlet weak var genreCollectionView: UICollectionView!

                func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

                    switch collectionView {
                    case self.genreCollectionView:
                        return genres.count
                    case self.titleCollectionView:
                        return books.count
                    default:
                        return 0
                    }
                }

                func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

                    switch collectionView {
                    // Genre collection
                    case self.genreCollectionView:
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Categories", for: indexPath) as! GenreCollectionViewCell

                        collectionView.alpha = 1
                        cell.titlelabel.text = genres[indexPath.row]
                        //            cell.titlelabel.sizeToFit()

                        cell.selectedimage.layer.cornerRadius = 10.0
                        cell.selectedimage.layer.masksToBounds = true
                        
                     
                        

                        genreCollectionView.alpha = 1

                        if selectedindex == 0 {

                            if indexPath.row == 0 {

                                cell.titlelabel.alpha = 1
                                cell.selectedimage.alpha = 1

                            } else {

                                cell.titlelabel.alpha = 0.25
                                cell.selectedimage.alpha = 0

                            }
                        }

                        if selectedindex == 1 {

                            if indexPath.row == 1 {

                                cell.titlelabel.alpha = 1
                                cell.selectedimage.alpha = 1

                            } else {

                                cell.titlelabel.alpha = 0.25
                                cell.selectedimage.alpha = 0

                            }

                        }

                        if selectedindex == 2 {

                            if indexPath.row == 2 {

                                cell.titlelabel.alpha = 1
                                cell.selectedimage.alpha = 1

                            } else {

                                cell.titlelabel.alpha = 0.25
                                cell.selectedimage.alpha = 0

                            }

                        }

                        if selectedindex == 3 {

                            if indexPath.row == 3 {

                                cell.titlelabel.alpha = 1
                                cell.selectedimage.alpha = 1

                            } else {

                                cell.titlelabel.alpha = 0.25
                                cell.selectedimage.alpha = 0

                            }

                        }

                        if selectedindex == 4 {

                            if indexPath.row == 4 {

                                cell.titlelabel.alpha = 1
                                cell.selectedimage.alpha = 1

                            } else {

                                cell.titlelabel.alpha = 0.25
                                cell.selectedimage.alpha = 0

                            }
                        }

                        if selectedindex == 5 {

                            if indexPath.row == 5 {

                                cell.titlelabel.alpha = 1
                                cell.selectedimage.alpha = 1

                            } else {

                                cell.titlelabel.alpha = 0.25
                                cell.selectedimage.alpha = 0

                            }

                        }

                        if selectedindex == 6 {

                            if indexPath.row == 6 {

                                cell.titlelabel.alpha = 1
                                cell.selectedimage.alpha = 1

                            } else {

                                cell.titlelabel.alpha = 0.25
                                cell.selectedimage.alpha = 0

                            }

                        }

                        if selectedindex == 7 {

                            if indexPath.row == 7 {

                                cell.titlelabel.alpha = 1
                                cell.selectedimage.alpha = 1

                            } else {

                                cell.titlelabel.alpha = 0.25
                                cell.selectedimage.alpha = 0

                            }

                        }
                        
                        if selectedindex == 8 {
                            
                            if indexPath.row == 8 {
                                
                                cell.titlelabel.alpha = 1
                                cell.selectedimage.alpha = 1
                                
                            } else {
                                
                                cell.titlelabel.alpha = 0.25
                                cell.selectedimage.alpha = 0
                                
                            }
                            
                        }


                        if selectedindex == 1000 {

                            cell.titlelabel.alpha = 0.25
                            cell.selectedimage.alpha = 0
                        }

                        return cell

                    case self.titleCollectionView:
                     let book = self.book(atIndexPath: indexPath)
                                  titleCollectionView.alpha = 1
                                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Books", for: indexPath) as! TitleCollectionViewCell
                                  //
                                  //            if book?.bookID == "Title" {
                                  //
                                  //                return cell
                                  //
                                  //            } else {
                                  
                                  MBProgressHUD.hide(for: view, animated: true)

                                  
                                  let name = book?.name
                                  
                             
                                      
                                cell.titlelabel.text = name
                                      
                                
                                  
                                  //                    cell.tapup.tag = indexPath.row
                                  //
                                  //                    cell.tapup.addTarget(self, action: #selector(DiscoverViewController.tapWishlist), for: .touchUpInside)
                                  
                                  if let imageURLString = book?.imageURL, let imageUrl = URL(string: imageURLString) {
                                      
                                      cell.titleImage.kf.setImage(with: imageUrl)
                                      
                                      
                                      
                                      cell.titleImage.layer.cornerRadius = 10.0
                                      cell.titleImage.clipsToBounds = true
                                      cell.titleImage.alpha = 1
                                      
                                      
                                      
                                      
                                      //                    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
                                      //                    let blurEffectView = UIVisualEffectView(effect: blurEffect)
                                      //                    blurEffectView.frame = cell.titleback.bounds
                                      //                    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                                      //                    cell.titleback.addSubview(blurEffectView)
                                      
                                      
                                  }
                                  
                                  let isWished = Bool()
                                  
                                  if wishlistids.contains(book!.bookID) {
                                      
                                      
                                  } else {
                                      
                                  }
                                  
                                  cell.layer.cornerRadius = 10.0
                                  cell.layer.masksToBounds = true
                                  
                                  cell.titlelabel.alpha = 1
                                  cell.titlelabel.alpha = 1
                                  
                                  if book?.views != nil {
                                      
                                      cell.viewslabel.text = book?.views
                                      
                                      
                                  } else {
                                      
                                      cell.viewslabel.text = "1.3M uses"
                                      
                                  }
                                  
                                  
                                  
                                  
                                  return cell

                        //            }

                    default:

                        return UICollectionViewCell()
                    }

                }

                var selectedindex = Int()

                @objc func tapWishlist(sender: UIButton) {

                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()

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

                @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
                /*
                 // MARK: - Navigation

                 // In a storyboard-based application, you will often want to do a little preparation before navigation
                 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                 // Get the new view controller using segue.destinationViewController.
                 // Pass the selected object to the new view controller.
                 }
                 */

            }

            // MARK: - Helpers
            extension FFavoritesViewController {
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

            //var selectedurl = String()

          

