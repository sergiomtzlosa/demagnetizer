import Foundation

extension String  {
    
    var isNumeric : Bool {
        return NumberFormatter().number(from: self) != nil
    }
}
