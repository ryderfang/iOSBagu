import UIKit
import Foundation

struct USER {
    let isHappy : Bool = true
}

var user = USER()

// 1. K&R style
if user.isHappy {
    print("Happy. :)")
} else {
    print("Unhappy. :(")
}

class Database {

}

// spaces, only one after ':', ','
class TestDB : Database {
    var data: [String: CGFloat] = ["A": 1.2, "B": 3.2]
}

let myArray = [1, 2, 3, 4, 5]
let myValue = 20 + (30 / 2) * 3

if 1 + 1 == 3 {
    fatalError("The universe is broken.")
}

func pancake(with syrup: Int) -> String? {
    /* ... */
    return nil
}

// 2. Naming
private let maximumWidgetCount = 100

class WidgetContainer {
    var widgetButton: UIButton
    let widgetHeightPercentage = 0.85

    init() {
        widgetButton = UIButton(frame: CGRect.zero)
    }
}

struct URLString {

}

struct UserID {

}

let urlString: URLString
let userID: UserID

// 2.1 Methods
func dateFromString(_ dateString: String) -> NSDate {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "YYYY-MM-dd"
    let date = dateFormatter.date(from: dateString)
    return date! as NSDate
}

func convertPointAt(column column: Int, row: Int) -> CGPoint {
    return CGPoint(x: column, y: row)
}

//func timedAction(afterDelay delay: NSTimeInterval, perform action: SKAction) -> SKAction!

// would be called like this:
let dt = dateFromString("2014-03-14") as Date
convertPointAt(column: 42, row: 13)
//timedAction(afterDelay: 1.0, perform: someOtherAction)

class Counter {
    func combineWith(otherCounter: Counter, options: Dictionary<String, Int>?) {
        //...
    }
    func incrementBy(amount: Int) {
        //...
    }
}

// here, the name is a noun that describes what the protocol does
protocol TableViewSectionProvider {
    func rowHeight(at row: Int) -> CGFloat
    var numberOfRows: Int { get }
    /* ... */
}

// here, the protocol is a capability, and we name it appropriately
protocol Loggable {
    func logCurrentState()
    /* ... */
}

// suppose we have an `InputTextView` class, but we also want a protocol
// to generalize some of the functionality - it might be appropriate to
// use the `Protocol` suffix here
protocol InputTextViewProtocol {
    func sendTrackingEvent()
    func inputText() -> String
    /* ... */
}

enum ShapeType {
    case rectangle
    case square
    case rightTriangle
    case equilateralTriangle
}

// use prefix in Module name not Class name
/*
import SomeModule
let myClass = MyModule.UsefulClass()
*/

//let sel = #selector(viewDidLoad)

struct Stack<Element> {
    //...
}

func writeTo<Target: OutputStream>(target: inout Target) {

}

// not colour
let color = "gray"

// MARK: use extensions
extension UIView {

}

class MyViewController: UIViewController {
    // class stuff here
}

// MARK: - UITableViewDataSource
extension MyViewController: UITableViewDataSource {
    // table view data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }
}

// MARK: - UIScrollViewDelegate
extension MyViewController: UIScrollViewDelegate {
    // scroll view delegate methods
}

// 3. code organization
// os frameworks
import Foundation
import UIKit
// external frameworks, alphabetized order
import Alamofire
import RxSwift
import SwiftyJSON

/**
 *  A concise description of the functionality.
 *
 *  @param title     Describe what value should be passed in.
 *  @param message   Left-align param documentation.
 *  @param number    If there is a default value, explain.
 *
 *  @return Describe the return value of the method.
 */
func exampleMethod(withTitle title: String?, message: String?,  number: NSNumber?) -> UILabel? {
    nil
}

// MARK: - Initializers
// TODO: @ryder
// FIXME: @ryder
// ERR: OMG!

class Shape {
    func computeArea() -> Double {
        0
    }
}

class Circle: Shape {
    var x: Int, y: Int
    var radius: Double
    var diameter: Double {
        get {
            return radius * 2
        }
        set {
            radius = newValue / 2
        }
    }

    init(x: Int, y: Int, radius: Double) {
        self.x = x
        self.y = y
        self.radius = radius
    }

    convenience init(x: Int, y: Int, diameter: Double) {
        self.init(x: x, y: y, radius: diameter / 2)
    }

    func describe() -> String {
        return "I am a circle at \(centerString()) with an area of \(computeArea())"
    }

    override func computeArea() -> Double {
        return Double.pi * radius * radius
    }

    private func centerString() -> String {
        return "(\(x),\(y))"
    }
}

class BoardLocation {
    let row: Int, column: Int

    init(row: Int, column: Int) {
        self.row = row
        self.column = column

        let closure = {
            print(self.row)
        }
    }
}

// omit the 'get' clause
var diameter: Double {
    return 2.0
    //return radius * 2
}

//subscript(index: Int) -> T {
//    return objects[index]
//}

// mostly use 'final'
final class Box<T> {
    private let value: T
    init(_ value: T) {
        self.value = value
    }
}

func reticulateSplines(spline: [Double]) -> Bool {
    // reticulate code goes here
    true
}
func reticulateSplines(spline: [Double], adjustmentFactor: Double,
    translateConstant: Int, comment: String) -> Bool {
    // reticulate code goes here
    false
}

UIView.animate(withDuration: 1.0,
    animations: {
        //self.myView.alpha = 0
    },
    completion: { finished in
        //self.myView.removeFromSuperview()
    }
)

var attendeeList = [10, 20, 30]
attendeeList.sort { a, b in
    a > b
}

var numbers = attendeeList
let value = numbers
    .map {$0 * 2}
    .filter {$0 > 50}
    .map {$0 + 10}

let width = 120.0 // Double (instead of NSNumber)
let widthString = (width as NSNumber).stringValue // String (instead of NSString)

// work as namespace
enum Math {
    static let e = 2.718281828459045235360287
    static let pi = 3.141592653589793238462643
}

let circumference = 3.0 * Math.pi * 2  // circumference

var subview: UIView?
var volume: Double?

// later on...
if let subview = subview, let volume = volume {
    // do something with unwrapped subview and volume
}

// use type annotation
// user [String] instead of Array<String>
var names: [String] = []
var lookup: [String: Int] = [:]
// MARK: do not use this.
// var names = [String]()
// var lookup = [String: Int]()

var sequence = [1, 2, 3, 5, 8]

if sequence.isEmpty {
    // ...
}

let first = sequence.first
let last = sequence.last

sequence.removeFirst()
sequence.removeLast()

for i in sequence.indices {
    // ...
}

let sorted = sequence.sorted()

let tuples = zip(sequence, sorted)

/* prevent retain cycle
resource.request().onComplete { [weak self] response in
    guard let strongSelf = self else { return }
    let model = strongSelf.updateModel(response)
    strongSelf.updateUI(model)
}
 */

// access keywords first
private /*static*/ let myPrivateNumber: Int

open class Pirate {
    /* ... */
}

// prefer 'for..in' than 'while'
for _ in 0..<3 {
    print("Hello three times")
}
let items: Array = ["Sofia", "Camilla", "Martina", "Mateo", "Nicolás"]
for (index, person) in items.enumerated() {
    print("\(person) is at position \(index)")
}
for index in stride(from: 0, to: items.count, by: 2) {
    print(index)
}
for index in (0...3).reversed().enumerated() {
    print(index)
}

extension String : Error {

}

func handleDigit(_ digit: Int) throws {
    switch digit {
    case 0, 1, 2, 3, 4, 5, 6, 7, 8, 9:
        print("Yes, \(digit) is a digit!")
    default:
        throw "The given number was not a digit."
    }
}

//handleDigit(10)

enum FFTError : Error {
    case noContext(String)
    case noInputData(String)
}

// multi return instead of nested if
func computeFFT(context: String?, inputData: String?) throws -> Bool {
    guard let context = context else { throw FFTError.noContext("1") }
    guard let inputData = inputData else { throw FFTError.noInputData("2") }

    // use context and input to compute the frequencies
    let frequencies = true
    return frequencies
}

computeFFT(context: "context", inputData: nil)

// Most of your custom data types should be structs and enums.
