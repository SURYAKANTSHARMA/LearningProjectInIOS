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

enum CustomerReviewStars { case one, two, three, four, five }

class Dog {
  
  var name: String = randomName()
  var age: Int = Int.random(in: 0 ..< 10) // Swift 4.2
  
  class func randomName() -> String {
    let names = ["Abby", "Bernie", "Lassie", "Max", "Sandy"]
    return names.randomElement()! // Swift 4.2
  }
}

extension DogCatcherNet: CustomDebugStringConvertible {
    var debugDescription: String {
        return "DogCatcherNet(Review Stars: \(customerReviewStars),"
            + " Weight: \(weightInPounds))"
    }
}

func log(itemToMirror: Any) {
    let mirror = Mirror(reflecting: itemToMirror)
    debugPrint("Type: 🐶 \(type(of: itemToMirror)) 🐶 ")
    for case let (label?, value) in mirror.children {
        debugPrint("⭐ \(label): \(value) ⭐")
    }
}

extension DogCatcherNet: CustomReflectable {
    public var customMirror: Mirror {
        return Mirror(DogCatcherNet.self,
                      children: ["Customer Review Stars": customerReviewStars,
                                 "dog": dog ?? "",
                                 "Dog name": dog?.name ?? "No name"

                                 ],
                      displayStyle: .class, ancestorRepresentation: .generated)
    }
}


class DogCatcherNet {
  
  var dog: Dog?
  let customerReviewStars: CustomerReviewStars
  let weightInPounds: Double
  // ☆ Add Optional called dog of type Dog here
  
  init(stars: CustomerReviewStars, weight: Double) {
    customerReviewStars = stars
    weightInPounds = weight
  }
}

let net = DogCatcherNet(stars: .two, weight: 2.6)
debugPrint("Printing a net: \(net)")
net.dog = Dog()
//dump(net)
//debugPrint("Printing a date: \(Date())")
print()
log(itemToMirror: net)
log(itemToMirror: Date())

// Simple output customization for the DogCatcherNet type.

// MARK: - CustomDebugStringConvertible
// ☆ Add Conformance to CustomDebugStringConvertible for DogCatcherNet here

dump(net.debugDescription)
print()

dump(Date())
print()

// More advanced output customization for the type and its properties.

// ☆ Create log function here

//net.dog = Dog() // ☆ Uncomment assigning the dog

// ☆ Log out the net and a Date object here

// CustomReflectable empowers you to control what is output and
// what text labels to associate with the displayed values.

// MARK: - CustomReflectable
// ☆ Add Conformance to CustomReflectable for DogCatcherNet here
