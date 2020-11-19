//
//  ViewController.swift
//  MyOkashi
//
//  Created by yumi kanebayashi on 2020/11/09.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var searchText: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // お菓子のリスト（タプル配列）
    var okashiList: [(name: String, maker: String, link: URL, image: URL)] = []

    struct ItemJson: Codable {
        // お菓子の名称
        let name: String?
        // メーカー
        let maker: String?
        // 掲載URL
        let url: URL?
        // 画像URL
        let image: URL?
    }

    struct ResultJson: Codable {
        let item: [ItemJson]?
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegateの通知先を設定
        searchText.delegate = self
        
        // TableViewのdatasourceを設定
        tableView.dataSource = self
    }
    
    
    // MARK: Private Method
    private func searchOkashi(keyword: String) {
        // お菓子の検索キーワードをURLエンコードする
        guard let keyword_encode = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }

        // リクエストURLの組み立て
        guard let request_url = URL(string: "https://sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(keyword_encode)&max=10&order=r") else {
            return
        }
        print(request_url)

        let request = URLRequest(url: request_url)

        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)

        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            // タスク完了後、セッション終了
            session.finishTasksAndInvalidate()

            do {
                // JSONデータをパースする
                let decoder = JSONDecoder()
                let json = try decoder.decode(ResultJson.self, from: data!)
                // print(json)
                
                if let items = json.item {
                    // お菓子のリストを初期化
                    self.okashiList.removeAll()
                    
                    for item in items {
                        if let maker = item.maker, let name = item.name, let link = item.url, let image = item.image {
                            let okashi = (maker, name, link, image)
                            self.okashiList.append(okashi)
                        }
                    }
                    // TableViewを更新する
                    self.tableView.reloadData()
                    
                    if let okashidbg = self.okashiList.first {
                        print("---")
                        print("okashiList[0] = \(okashidbg)")
                    }
                }
            } catch {
                print("エラーが出ました")
            }
        })
        // タスクの実行
        task.resume()
    }
}


// MARK: UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    // 検索ボタンがタップされた時のdelegateメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // キーボードを閉じる
        view.endEditing(true)

        // searchBarに文字が入力されていた場合、お菓子を検索
        if let searchWord = searchBar.text {
            print(searchWord)
            searchOkashi(keyword: searchWord)
        }
    }
}


// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // お菓子のリストの総数
        return okashiList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 表示のための、cellオブジェクト(一行)を取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "okashiCell", for: indexPath)
        
        // お菓子のタイトル設定
        cell.textLabel?.text = okashiList[indexPath.row].name
        
        // お菓子画像を取得
        if let imageData = try? Data(contentsOf: okashiList[indexPath.row].image) {
            cell.imageView?.image = UIImage(data: imageData)
        }
        
        return cell
    }
}
    
    

