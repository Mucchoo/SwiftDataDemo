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
    let container = try! ModelContainer(for: Book.self)
    var body: some Scene {
        WindowGroup {
            Text("Hello, world!")
                .modelContainer(container)
                .onAppear {
                    let book = Book(title: "Book1", author: "Musa")
                    let context = container.mainContext
                    context.insert(book)
                    
                    for i in 0...100 {
                        let quote = Quote(text: "\(i)")
                        context.insert(quote)
                        book.quotes?.append(quote) // CRASH
                    }
                    
                    print("book title: \(book.title)")

                    book.quotes?.forEach { quote in
                        print("quote text:\(quote.text)")
                    }
                }
//                .modelContainer(for: Parent.self)
//                .onAppear {
//                    let parent = Parent()
//
//                    let container = try! ModelContainer(for: Parent.self)
//                    let context = container.mainContext
//                    context.insert(parent)
//                    
//                    for i in 0...100 {
//                        let child = Child()
//                        context.insert(child)
//                        child.name = "\(i)"
//                        parent.children?.append(child) // CRASH
//                    }
//                    
//                    print("parent name: \(parent.name)")
//
//                    parent.children?.forEach { child in
//                        print("child name:\(child.name)")
//                    }
//                }
        }
    }
}

//@Model final class Parent {
//    var name = ""
//    @Relationship(deleteRule: .cascade) var children: [Child]?
//    
//    init() {}
//}
//
//@Model final class Child {
//    var parent: Parent?
//    var name: String = ""
//    
//    init() {}
//}

@Model
class Book {
    var title: String = ""
    var author: String = ""
    var dateAdded: Date = Date.now
    var dateStarted: Date = Date.distantPast
    var dateCompleted: Date = Date.distantPast
    @Attribute(originalName: "summary")
    var synopsis: String = ""
    var rating: Int?
    var status: Status.RawValue = Status.onShelf.rawValue
    var recommendedBy: String = ""
    @Relationship(deleteRule: .cascade)
    var quotes: [Quote]?
    @Relationship(inverse: \Genre.books)
    var genres: [Genre]?
    
    @Attribute(.externalStorage)
    var bookCover: Data?
    
    init(
        title: String,
        author: String,
        dateAdded: Date = Date.now,
        dateStarted: Date = Date.distantPast,
        dateCompleted: Date = Date.distantPast,
        synopsis: String = "",
        rating: Int? = nil,
        status: Status = .onShelf,
        recommendedBy: String = ""
    ) {
        self.title = title
        self.author = author
        self.dateAdded = dateAdded
        self.dateStarted = dateStarted
        self.dateCompleted = dateCompleted
        self.synopsis = synopsis
        self.rating = rating
        self.status = status.rawValue
        self.recommendedBy = recommendedBy
    }
    
    var icon: Image {
        switch Status(rawValue: status)! {
        case .onShelf:
            Image(systemName: "checkmark.diamond.fill")
        case .inProgress:
            Image(systemName: "book.fill")
        case .completed:
            Image(systemName: "books.vertical.fill")
        }
    }
}


enum Status: Int, Codable, Identifiable, CaseIterable {
    case onShelf, inProgress, completed
    var id: Self {
        self
    }
    var descr: LocalizedStringResource {
        switch self {
        case .onShelf:
            "On Shelf"
        case .inProgress:
            "In Progress"
        case .completed:
            "Completed"
        }
    }
}

@Model
class Genre {
    var name: String = ""
    var color: String = "FF0000"
    var books: [Book]?
    
    init(name: String, color: String) {
        self.name = name
        self.color = color
    }
}

@Model
class Quote {
    var creationDate: Date = Date.now
    var text: String = ""
    var page: String? = ""
    
    init(text: String, page: String? = nil) {
        self.text = text
        self.page = page
    }
    
    var book: Book?
}
