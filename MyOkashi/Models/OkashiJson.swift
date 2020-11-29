import UIKit
import Alamofire

// MARK: Properties

var okashiList: [(name: String, maker: String, link: URL, image: URL)] = []

struct OkashiJson: Codable {
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
    let item: [OkashiJson]?
}


// MARK: Method

func searchOkashi(keyword: String) -> [(name: String, maker: String, link: URL, image: URL)] {
    Alamofire.request("https:sysbird.jp/toriko/api/",
                      method: .get,
                      parameters: [
                        "apikey": "guest",
                        "format": "json",
                        "keyword": "\(keyword)",
                        "max": "10",
                        "order": "r"],
                      // キーワードをURLエンコードする
                      encoding: URLEncoding(destination: .queryString)
                      
    ).response { response in
        guard let data = response.data else {
            print("Error with response")
            return
        }
        // JSONデータをパースする
        okashiList = parseJson(data)
    }
    
    return okashiList
}

func parseJson(_ data: Data) -> [(name: String, maker: String, link: URL, image: URL)] {
    do {
        let decoder = JSONDecoder()
        let json = try decoder.decode(ResultJson.self, from: data)
        // print(json)
        
        okashiList = setOkashiData(json)
        // TableViewを更新する
        //tableView.reloadData()
    } catch {
        print("Error failed to parse JSON: \(error)")
    }
    return okashiList
}


func setOkashiData(_ json: ResultJson) -> [(name: String, maker: String, link: URL, image: URL)] {
    //var okashiDataList = okashiList
    if let items = json.item {
        // お菓子のリストを初期化
        okashiList.removeAll()
        
        for item in items {
            if let maker = item.maker, let name = item.name, let link = item.url, let image = item.image {
                let okashi = (maker, name, link, image)
                okashiList.append(okashi)
            }
        }
        
        if let okashidbg = okashiList.first {
            print("---")
            print("okashiList[0] = \(okashidbg)")
        }
    }
    
    return okashiList//okashiDataList
}
