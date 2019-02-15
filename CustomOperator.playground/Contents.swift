import UIKit

infix operator •: AdditionPrecedence
struct Vector: CustomStringConvertible, ExpressibleByArrayLiteral {
    let x: Int
    let y: Int
    
    var description: String {
        return "x \(x) y \(y)"
    }
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    init(arrayLiteral elements: Int...) {
        assert(elements.count == 2, "There should be two elems")
        self.x = elements[0]
        self.y = elements[1]
    }
    
    static func + (lhs: Vector, rhs: Vector) -> Vector {
      return Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static prefix func - (vector: Vector) -> Vector {
        return Vector(x: -vector.x, y:  -vector.y)
    }
    
    static func •(left: Vector, right: Vector) -> Int {
        return left.x * right.x + left.y * right.y
    }
}


var vector1 = Vector(x: 10, y: 10)
print(vector1)
vector1 = [10,20]
print(vector1)

let vector2 = Vector(x: 20, y: 10)
let vectorSum = vector1 + vector2
print(vectorSum)
print(-vectorSum)

