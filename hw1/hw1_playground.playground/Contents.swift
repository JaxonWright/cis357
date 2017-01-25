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
let const2 = "\(myString) \(3.1456546e12 * 4.65e10)"


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
for i in(1...10).reversed(){
    print(i)
}
for i in stride(from: 10, to: 1, by: -1) { print(i) }


//Problem 10
var x = 4
var y = 2
var product = 0
for _ in 1...y{
    product +=  x
}
print("\(x) times \(y) is \(product)")


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
func verbalizeNumber (integer: Int) -> String {
    var strOut: String
    switch (integer) {
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
    return strOut
}
//print(verbalizeNumber(integer: 10))


//Problem 15
//commented out becuase it takes a while
/*for i in stride(from: 1, to: 100_000_000, by: 10) {
 print("\(i) is \(verbalizeNumber(integer: i)) something")
 }*/

//Problem 16
func verbalizeAndShout (integer: Int) -> String {
    return verbalizeNumber(integer: integer).uppercased()
}
//print(verbalizeAndShout(integer: 10))


//Problem 17
func expressNumbersElegantly(max: Int, verbalizeFunction: (Int) -> String) -> String {
    var strOut: String = ""
    for i in stride(from: 1, to: max, by: 10) {
        strOut += verbalizeFunction(i)
    }
    return strOut
}

var functionVar: (Int) -> String
functionVar = verbalizeNumber
//print(expressNumbersElegantly(max: 100, verbalizeFunction: functionVar))

functionVar = verbalizeAndShout
//print(expressNumbersElegantly(max: 100, verbalizeFunction: functionVar))


//Problem 18
func expressNumbersVeryElegantly(highestNum max: Int, verbalize verbalizeFunction: (Int) -> String) -> String {
    var strOut: String = ""
    for i in stride(from: 1, to: max, by: 10) {
        strOut += verbalizeFunction(i)
    }
    return strOut
}


//Problem 19
var famousLastWords = ["the cow jumped over the moon.",
                       "three score and four years ago",
                       "lets nuc 'em Joe!",
                       "ah, there is just something about Swift"]
famousLastWords = famousLastWords.map {
   String($0[$0.startIndex]).uppercased() + $0[$0.index(after: $0.startIndex)..<$0.endIndex]
}


//Problem 20
//convert phone numbers to raw numbers. 
//useful when there are letters in the phone number and you don't know what to dial
func letterToNumber(letter l:String) -> String {
    switch (l.lowercased()) {
        case "a"..."c": return "2"
        case "d"..."f": return "3"
        case "g"..."i": return "4"
        case "j"..."l": return "5"
        case "m"..."o": return "6"
        case "p"..."s": return "7"
        case "t"..."v": return "8"
        case "w"..."z": return "9"
        default: return l
    }
}
var testPhoneNum:String = "1 (800) FLOWERS"
func convertPhoneToAllNums(phoneNum n:String, mappingFunc m: (String) -> String) -> String {
    var strOut: String = ""
    for c in n.characters {
        strOut += m(String(c))
    }
    //insert - in right spot if is not present
    if(strOut[strOut.index(strOut.endIndex, offsetBy: -4)] != "-") {
        strOut.insert("-" as Character, at: strOut.index(strOut.endIndex, offsetBy: -4))
    }
    return strOut
}
print(convertPhoneToAllNums(phoneNum: testPhoneNum, mappingFunc: letterToNumber))

