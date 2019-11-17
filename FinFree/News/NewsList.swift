//
//  NewsList.swift
//  FinFree
//
//  Created by Björn Kaczmarek on 22/5/19.
//  Copyright © 2019 Björn Kaczmarek. All rights reserved.
//

import UIKit

class NewsList: UITableViewController {

    var choosenStock: String = ""
    var headlines: [String] = []
    var sources: [String] = []
    var url: [String] = []
    var imageUrl: [String] = []
    var image = UIImage()
    let imageCache = NSCache<NSString, UIImage>()
    var token = Token()
    
    var refreshcontrol = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        
        downloadNews()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshcontrol
        } else {
            tableView.addSubview(refreshcontrol)
        }
        
        refreshcontrol.addTarget(self, action: #selector(refreshNewsList(_:)), for: .valueChanged)
        
        refreshcontrol.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.tableView.reloadData()
    }
    
    @objc private func refreshNewsList(_ sender: Any) {
        
        self.tableView.reloadData()
        
        if (headlines.count == 0) {
            print("News downloaded")
            downloadNews()
        } else {
            print("No news downloaded!")
        }
        
        refreshcontrol.endRefreshing()
    }

    func downloadNews() {
        
        headlines = []
        sources = []
        
        let urlString = token.testURL(symbol: choosenStock, info: "/news")
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                print(data)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Json ist:")
                    print(json)
                    if let dictionary = json as? [String: Any] {
                        print(dictionary)
                        if let latestHeadline = dictionary["headline"] as? String {
                            print("Headline is: " + "\(latestHeadline)")
                            self.headlines.append(latestHeadline)
                        }
                        if let source = dictionary["source"] as? String {
                            print("Source is: " + "\(source)")
                            self.sources.append(source)
                        }
                    } else {
                        let dictionaryAlt = json as! [[String:Any]]
                        for dictionary in dictionaryAlt {
                            if let latestHeadline = dictionary["headline"] as? String {
                                print("Headline is: " + "\(latestHeadline)")
                                self.headlines.append(latestHeadline)
                            }
                            if let source = dictionary["source"] as? String {
                                print("Source is: " + "\(source)")
                                self.sources.append(source)
                            }
                            if let url = dictionary["url"] as? String {
                                print("Url is: " + "\(url)")
                                self.url.append(url)
                            }
                            if let imageURlString = dictionary["image"] as? String {
                                print("ImageUrl is: " + imageURlString)
                                self.imageUrl.append(imageURlString)
                            }
                        }
                    }
                    
                } catch {
                    print("The error is:")
                    print(error)
                }
            }
            }.resume()
        
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if headlines.count > 0 {
            return headlines.count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cellStory = tableView.dequeueReusableCell(withIdentifier: "cellStory", for: indexPath) as! NewsListCell
        let cellStory = Bundle.main.loadNibNamed("ImageLabelCell", owner: self, options: nil)?.first as! ImageLabelCell
        
        print("Cell refreshed!!")
        
        if headlines.count > 0 {
            cellStory.label.text = headlines[indexPath.row]
            cellStory.label.numberOfLines = 0
            DispatchQueue.global(qos: .background).async {
                let url = URL(string:self.imageUrl[indexPath.row])
                print("Url ist : " + "\(String(describing: url))")
                var data = try? Data(contentsOf: url!)
                if data == nil {
                    let alternativURL = URL(string: "https://dummyimage.com/600x400/c7c7c7/0011ff.png&text=Image+not+available+")
                    data = try? Data(contentsOf: alternativURL!)
                    self.image = UIImage(data: data!)!
                } else {
                    self.image = UIImage(data: data!)!
                }
                DispatchQueue.main.async {
                    self.imageCache.setObject(self.image, forKey: NSString(string:        self.imageUrl[indexPath.row]))
                    cellStory.imageViewCell.image = self.image
                    
                }
            }
        } else {
            cellStory.label.text = "No news found"
        }

        return cellStory
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if headlines.count > 0 {
            let destVC = NewsDetail()
            destVC.urlAsString = url[indexPath.row]
            self.navigationController?.pushViewController(destVC, animated: true)
        } else {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height / 8
    }

}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
}
