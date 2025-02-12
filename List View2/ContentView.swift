//
//  ContentView.swift
//  List View2
//
//  Created by 鴛海剛 on 2025/02/10.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        FirstView()// Firstviewを表示
//        SecondView()//
    }
}

//リストビュー
struct FirstView: View {
    // "TasksData"というキーで保存されたものを監視
    @AppStorage("TasksData") private var tasksData = Data()
    @State var tasksArray: [Task] = []
    //FirstView生成時に呼ばれる。
    init() {
        if let decodedTasks = try? JSONDecoder().decode([Task].self, from: tasksData) {
            _tasksArray = State(initialValue: decodedTasks)
            print(tasksArray)
        }
    }
    
    var body: some View {
        NavigationStack {
            //"Add New Task"をタップするとSecondViewへ画面遷移するようにリンクを設定
            NavigationLink(destination:SecondView(tasksArray: $tasksArray)
                .navigationTitle("Add Task")) {
                    Text("Add New Task")
                        .font(.system(size: 20, weight: .bold))
                        .padding()
                }
            List {
                // Exapletask を List の内側 に ForEach を使って
                ForEach(tasksArray){ task in
                    Text(task.taskItem)
                }
                //並び替えが起きたときに実行される
                .onDelete(perform: deleteRow)//削除
                .onMove (perform: replaceRow)//並び替え
                }
            
            .navigationTitle("Task List")//画面上のタイトル
            //ナビゲーションバーに編集ボタンを追加
            .toolbar {
                EditButton()
            }
        }
    }
    // 並び替え処理 & 保存
    func replaceRow(_ from: IndexSet, _ to: Int) {
        tasksArray.move(fromOffsets: from, toOffset: to)
        saveTasks()
    }

    // 削除処理 & 保存
    func deleteRow(at offsets: IndexSet) {
        tasksArray.remove(atOffsets: offsets)
        saveTasks()
    }

    // タスクの保存処理（UserDefaults）
    func saveTasks() {
        if let encodedArray = try? JSONEncoder().encode(tasksArray) {
            tasksData = encodedArray
        }
    }
}


    //並び替え処理 と並び替え後の保存
//    func replaceRow(_ from: IndexSet, _ to: Int) {
//        tasksArray.move(fromOffsets: from, toOffset: to)//配列内での並び替え
//        if let encodedArray = try? JSONEncoder().encode(tasksArray) {
//            tasksData = encodedArray//エンコードができたらAppStorageに渡す(保存 更新)
//        }
//    }
//}
// タスク入力のビュー
struct SecondView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    //テキストフィールドに入力された文字を格納する変数
    @State private var task: String = ""
    
    @Binding var tasksArray: [Task]  //タスクをいれる配列
    
    
    var body: some View {
        TextField("Enter your task", text: $task)
            .textFieldStyle(.roundedBorder)
            .padding()
        
        Button {
            //ボタンを押したときに実行される
            addTask(newTask: task)//入力されたタスクの保存
            task = ""// テキストフィールドを空に
            print(tasksArray)
            
        } label: {
            Text("Add")
        }
        .buttonStyle(.borderedProminent)
        .tint(.orange)
        .padding()
        
        Spacer() //下側の余白を埋めた
    }
    // タスクの追加と保存 引数は入力されたタスクの文字
    func addTask(newTask: String) {
        // テキストフィールドに入力された値が空白じゃないとき(何か入力されている)ときだけ処理
        if !newTask.isEmpty {
            
            let task = Task(taskItem: newTask)//Taskをインスタンス化(実体化)
            var array = tasksArray
            array.append(task)//一時的配列ArrayにTaskを追加
            
            
            //エンコードがうまくいったらUsrDefaultsに保存するよ
            if let encodedData = try? JSONEncoder().encode(array) {
                UserDefaults.standard.setValue(encodedData, forKey: "TasksData")//保存
                tasksArray = array //保存ができた時だけ 新しいTaskが追加された配列を反映
                dismiss() //前の画面に戻る
            }
        }
    }
}


    



#Preview {
    ContentView()
}

//#Preview("SecondView", body: {
//    SecondView()
//})

