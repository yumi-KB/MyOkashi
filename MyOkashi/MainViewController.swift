import UIKit
import SafariServices
import Alamofire

class MainViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var searchText: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var okashiList: [(name: String, maker: String, link: URL, image: URL)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchText.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
//
//    // MARK: Private Method
//    private func searchOkashi(keyword: String) {
//        Alamofire.request("https:sysbird.jp/toriko/api/",
//                          method: .get,
//                          parameters: [
//                            "apikey": "guest",
//                            "format": "json",
//                            "keyword": "\(keyword)",
//                            "max": "10",
//                            "order": "r"],
//                          // キーワードをURLエンコードする
//                          encoding: URLEncoding(destination: .queryString)
//
//        ).response { response in
//            guard let data = response.data else {
//                print("Error with response")
//                return
//            }
//            // JSONデータをパースする
//            self.parseJson(data)
//        }
//    }
//
//    private func parseJson(_ data: Data) {
//        do {
//            let decoder = JSONDecoder()
//            let json = try decoder.decode(ResultJson.self, from: data)
//            print(json)
//
//            self.setOkashi(json, setList: self.okashiList)
//            // TableViewを更新する
//            self.tableView.reloadData()
//
//        } catch {
//            print("Error failed to parse JSON: \(error)")
//        }
//    }
//
//
//    private func setOkashi(_ json: ResultJson, setList okashiList: [(name: String, maker: String, link: URL, image: URL)]) {
//        if let items = json.item {
//            // お菓子のリストを初期化
//            self.okashiList.removeAll()
//
//            for item in items {
//                if let maker = item.maker, let name = item.name, let link = item.url, let image = item.image {
//                    let okashi = (maker, name, link, image)
//                    self.okashiList.append(okashi)
//                }
//            }
//
//            if let okashidbg = self.okashiList.first {
//                print("---")
//                print("okashiList[0] = \(okashidbg)")
//            }
//        }
//    }
}


// MARK: UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    // 検索ボタンがタップされた時のdelegateメソッド
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // キーボードを閉じる
        view.endEditing(true)

        // searchBarに文字が入力されていた場合、お菓子を検索
        if let searchWord = searchBar.text {
            //print(searchWord)
            okashiList = searchOkashi(keyword: searchWord)
            tableView.reloadData()
        }
    }
}


// MARK: UITableViewDataSource
extension MainViewController: UITableViewDataSource {
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
    
    
// MARK: UITableViewDelegate, SFSafariViewControllerDelegate
extension MainViewController: UITableViewDelegate, SFSafariViewControllerDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let safariViewController = SFSafariViewController(url: okashiList[indexPath.row].link)
        
        safariViewController.delegate = self
        
        present(safariViewController, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true, completion: nil)
    }
}
