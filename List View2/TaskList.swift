//
//  TaskList.swift
//  List View2
//
//  Created by 鴛海剛 on 2025/02/10.
//

import Foundation

struct ExampleTask {
let taskList = [
    "掃除",
    "洗濯",
    "料理",
    "買い物",
    "運動"
    ]
}
//カスタマイズされた構造体 Task を定義
//エンコードとデコード可能なように codable に準拠
struct Task: Codable, Identifiable {
    var id = UUID()// ユニーク(一意)なIDを自動で生成
    var taskItem: String
}
