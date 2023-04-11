import Foundation

class ClothUtility {
    static func getTypeInt(from type: String) -> Int {
        for i in (0..<GlobalEnvironment.clothTypes.count) {
            if GlobalEnvironment.clothTypes[i] == type {
                return i
            }
        }
        return 0
    }
    
    static func getColorInt(from color: String) -> Int {
        for i in (0..<GlobalEnvironment.clothColors.count) {
            if GlobalEnvironment.clothColors[i] == color {
                return i
            }
        }
        return 0
    }
    
    
    static func getShelfInt(from type: String) -> Int {
        switch type {
        case "Hat":
            return 0
        case "Top":
            return 1
        case "Bottoms":
            return 2
        case "Shoes":
            return 3
        default:
            return 1
        }
    }
    
    static func initializeCloth(cloth: Cloth) -> (image: Data, typeInt: Int, colorInt: Int, shelfInt: Int) {
        let image = cloth.imageD ?? .init(count: 0)
        let typeInt = getTypeInt(from: cloth.type ?? "Hat")
        let colorInt = getColorInt(from: cloth.color ?? "Red")
        let shelfInt = getShelfInt(from: cloth.shelf ?? "Top")
        return (image, typeInt, colorInt, shelfInt)
    }
    
    func updateShelfInt(type : String) -> Int{
        if  type == "longsleeve" ||
                type == "t-shirt" ||
                type == "demi-season outwear" ||
                type == "winter outwear" ||
                type == "dress" {
            return 1
        }
        else if     type == "pants" ||
                    type == "shorts" ||
                    type == "skirt" {
            return 2
        }
        else if type == "hat" {
            return  0
        }
        else if type == "shoes" {
            return  3
        }
        return 0
    }
}
