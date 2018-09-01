/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
import Foundation

// @dynamicMemberLookup is a Swift 4.2 attribute.
// It requires the subscript(dynamicMember:) be implemented.

@dynamicMemberLookup // ☆ Uncomment this line
class Dog {
    
    subscript(dynamicMember member: String) -> Direction {
        if member == "moving" || member == "directionOfMovement" {
            // Here's where you would call the motion detection library
            // that's in another programming language such as Python
            return randomDirection()
        }
        return .motionless
    }

  enum Direction: String { case left, right, motionless }
  
  // ☆ Add subscript method that returns a Direction here.
  
  // ☆ Add subscript method that returns an Int here.
  
  private func randomDirection() -> Direction {
    return Bool.random() ? .right : .left
  }
}

let dynamicDog = Dog()

// ☆ Use the dynamicMemberLookup feature for dynamicDog here.
let directionOfMove: Dog.Direction = dynamicDog.directionOfMovement
print("Dog's direction of movement is \(directionOfMove).")

let movingDirection: Dog.Direction = dynamicDog.moving
print("Dog is moving \(movingDirection).")


//@dynamicMemberLookup // ☆ Uncomment this line
struct JSONDogCatcher {
  
  private var storedString: String?
  private var storedInt: Int?
  private var storedDictionary: [String: Any]?
  
  init(string: String) {
    storedString = string
  }
  
  init(int: Int) {
    storedInt = int
  }
  
  init(dictionary: [String: Any]) {
    storedDictionary = dictionary
  }
  
  // ☆ Add subscript(dynamicMember:) method that returns a
  // JSONDogCatcher here.
  
  // Traditional way that supports catcher["owner"] syntax.
  
  subscript(key: String) -> JSONDogCatcher? {
    
    let value = storedDictionary?[key]
    
    if let dictionary = value as? [String: Any] {
      return JSONDogCatcher.init(dictionary: dictionary)
    }
    if let string = value as? String {
      return JSONDogCatcher.init(string: string)
    }
    if let int = value as? Int {
      return JSONDogCatcher.init(int: int)
    }
    
    return nil
  }
  
  func value() -> String? {
    return storedString
  }
  
  func value() -> Int? {
    return storedInt
  }
}

let catchAString = JSONDogCatcher.init(string: "Rover").value() ?? ""
print("Caught \(catchAString)")

let catchAnInt = JSONDogCatcher.init(int: 3).value() ?? 0
print("Caught \(catchAnInt)")

// ----

let json: [String: Any] = ["name": "Rover", "speed": 12,
                           "owner": ["name": "Ms. Simpson", "age": 36]]

let catcher = JSONDogCatcher.init(dictionary: json)

let messyName: String = catcher["owner"]?["name"]?.value() ?? ""
print("Owner's name extracted in a less readable way is \(messyName).")

// ☆ Use dot notation to get the owner's name and speed through the
// catcher.
