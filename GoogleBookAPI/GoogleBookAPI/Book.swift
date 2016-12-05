//
//  Book.swift
//  GoogleBookAPI
//
//  Created by Kadell on 12/4/16.
//  Copyright © 2016 Kadell. All rights reserved.
//

import Foundation

enum ParsingError: Error {
    case volumeParsingError, idError, titleError, subTitleError, imageError
}

class Book {
   
    let id: String
    let title: String
    let subTitle: String
    let smallImage: String
    let image: String
    
    
    init(id: String, title: String, subTitle: String, smallImage: String, image: String) {
        self.id = id
        self.title = title
        self.subTitle = subTitle
        self.smallImage = smallImage
        self.image = image
    }
    
    
    static func createData(from data: Data) -> [Book]? {
        
        do{
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let dict = jsonData as? [String: Any] else {
                print("Their was an error while parsing the JSON Data.")
                return nil
            }
            guard let bookArray = dict["items"] as? [[String: Any]] else {
                print("Their was an error creating an array of objects")
                return nil
            }
            print("Got in")
            
            var allBooks: [Book] = []
            
            for dict in bookArray {
                
                guard let volumeInfoDict = dict["volumeInfo"] as? [String: Any] else { throw ParsingError.volumeParsingError
                }
                guard let ID = dict["id"] as? String else {throw ParsingError.idError}
                guard let title = volumeInfoDict["title"] as? String else {throw ParsingError.titleError }
                print("Got here")
                guard let subTitle = volumeInfoDict["subtitle"]  as? String else { continue
//                    throw ParsingError.subTitleError
                }
                guard let imageArray = volumeInfoDict["imageLinks"] as? [String:Any] else { throw ParsingError.imageError }
                guard let smallImage = imageArray["smallThumbnail"] as? String else {throw ParsingError.imageError}
                guard let image = imageArray["thumbnail"] as? String else { throw ParsingError.imageError}
                
                let Books = Book(id: ID, title: title, subTitle: subTitle, smallImage: smallImage, image: image)
                
                allBooks.append(Books)
            }
            return allBooks
            
        }
            
        catch ParsingError.volumeParsingError {
            print("Error getting into the VolumeInfo")
        }
        catch ParsingError.idError {
            print("Error retreving Book ID")
        }
        catch ParsingError.titleError {
            print("Error retreving title")
        }
        catch ParsingError.subTitleError {
            print("Error retreving subTitle")
        }
        catch {
            print("Unkown Error")
        }
    
    return nil
    }
    
    
}
