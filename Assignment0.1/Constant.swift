//
//  Constant.swift
//  Assignment0.1
//
//  Created by Jicang Wang on 1/22/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import Foundation

var todoList:[String]?

func saveData(todoList:[String]){
    UserDefaults.standard.set(todoList, forKey: "todolist")
}

func fetchData() -> [String]?{
    if let todo = UserDefaults.standard.array(forKey: "todoList") as? [String]{
        return todo
    }
    else{
        return nil
    }
}
