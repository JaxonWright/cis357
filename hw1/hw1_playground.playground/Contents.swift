//: Playground - noun: a place where people can play
// CIS 357 - HW1 - Jaxon Wright and Kent Sinclair

//Problem 1
let myString = "hello"
var cost = 3.14
let cnt: Int = 2
var shouldBe = true
let intConst1 = 0xB //11
let intConst2 = 0b1010 //10

//Problem 2

//Problem 3
var jobsArray = ["queen", "worker", "drone"]
print(jobsArray[0])
jobsArray.append("honey")
jobsArray += ["are", "us"]

//Problem 4
for a in jobsArray {
    print(a)
}
for (i, a) in jobsArray.enumerated() {
    print("Item #\(i) is \(a)")
}

//Problem 5
var dict: [String:Float] = [
    "Mark Twain": 8.9,
    "Nathaniel Hawthorne": 5.1,
    "John Steinbeck": 2.3,
    "C.S. Lewis": 9.9,
    "Jon Krakaur": 6.1
]

//Problem 6
print(dict["John Steinbeck"]!)
dict["Erik Larson"] = 9.2
if dict["Jon Krakaur"]! > dict["Mark Twain"]! {
    print("Jon Krakaur")
} else {
    print("Mark Twain")
}

//Problem 7
for (k,v) in dict {
    print("\(k): \(v)")
}

//Problem 8
for i in 1...10 {
    print(i)
}

//Problem 9
/*for var i=10; i > 0; i -= 1 {
    print(i)
}*/

//Problem 10


//Problem 11
var i = 1
var avg = 0.0
var tot = 0.0
while (i < dict.count) {
    var index = dict.index(dict.startIndex, offsetBy: i)
    tot += Double(dict.values[index])
    i += 1
}
avg = tot/Double(dict.count)

//Problem 12
if avg < 5.0 {
    print("Low")
} else if avg < 7 {
    print("Moderate")
} else if avg >= 7 {
    print("High")
}

//Problem 13
var count:Int = 5
var strOut:String
switch (count) {
    case 0:
        strOut = "none"
    case 1...3:
        strOut = "a few"
    case 4...9:
        strOut = "several"
    case 10...99:
        strOut = "tens of"
    case 100...999:
        strOut = "hundreds of"
    case 1000...999999:
        strOut = "thousands of"
    default:
        strOut = "millions of"
    
}

//Problem 14

//Problem 15

//Problem 16

//Problem 17

//Problem 18

//Problem 19

//Problem 20
