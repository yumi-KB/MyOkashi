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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegateの通知先を設定
        searchText.delegate = self
    }
    
    func searchOkashi(keyword: String) {
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

