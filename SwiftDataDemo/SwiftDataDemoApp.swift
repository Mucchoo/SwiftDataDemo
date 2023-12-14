//
//  SwiftDataDemoApp.swift
//  SwiftDataDemo
//
//  Created by Musa Yazici on 12/10/23.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataDemoApp: App {
    let container = try! ModelContainer(for: Parent.self)
    var body: some Scene {
        WindowGroup {
            Text("Hello, world!")
                .modelContainer(container)
                .onAppear {
                    let parent = Parent()
                    let context = container.mainContext
                    context.insert(parent)
                    
                    for i in 0...100 {
                        let child = Child()
                        context.insert(child)
                        child.name = "\(i)"
                        parent.children?.append(child) // CRASH
                    }
                    
                    print("parent name: \(parent.name)")

                    parent.children?.forEach { child in
                        print("child name:\(child.name)")
                    }
                }
        }
    }
}

@Model final class Parent {
    var name = ""
    @Relationship(deleteRule: .cascade) var children: [Child]?
    
    init() {}
}

@Model final class Child {
    var parent: Parent?
    var name: String = ""
    
    init() {}
}
