#!/usr/bin/swift
struct CreditCard{
    let digits: [Int]
    var valid: Bool{
        var index = 0
        return reverse(digits)
          .map() { index++ % 2 != 0 ? ($0 * 2) :$0}
          .map() {
            digit in
            switch digit {
            case 0...9:
                return digit
            default:
                var total = 0
                for c in String(digit){
                    total += String(c).toInt()!
                }
                return total
            }
        }
      .reduce(0, +) % 10 == 0
    }
}
println(CreditCard(digits:[4,0,1,2,8,8,8,8,8,8,8,8,1,8,8,1]).valid)
