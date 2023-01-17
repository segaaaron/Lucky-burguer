//
//  Helper+Double+extension.swift
//  Lucky-Test-burguer
//
//  Created by Miguel Angel Saravia Belmonte on 1/16/23.
//

import Foundation

final class Utilities {
    func convertLikes(num: Double) ->String{
        let thousandNum = num/1000
        let millionNum = num/1000000
        if num >= 1000 && num < 1000000{
            if(floor(thousandNum) == thousandNum){
                return("\(Int(thousandNum))k")
            }
            return("\(thousandNum.roundToPlaces(places:1))k")
        }
        if num > 1000000{
            if(floor(millionNum) == millionNum){
                return("\(Int(thousandNum))k")
            }
            return ("\(millionNum.roundToPlaces(places:1))M")
        }
        else{
            if(floor(num) == num){
                return ("\(Int(num))")
            }
            return ("\(num)")
        }
    }
    
    func GSFRemoteJson<T: Decodable>(model: T.Type, pathFile: String) -> T? {
        let jsonModel: T?
        guard let pathFile = ServicePath.pathMainUrl(pathFile),
              let data = pathFile.data(using: .utf8)
        else {  return nil }
        do {
            jsonModel = try JSONDecoder().decode(T.self, from: data)
        } catch {
            return nil
        }
        return jsonModel
    }
    
    func formatDate(with formatStringDate: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy"

        let date: NSDate? = dateFormatterGet.date(from: formatStringDate) as NSDate?
        let currentDate = dateFormatterPrint.string(from: date as? Date ?? Date())
        return "Exp." + currentDate
    }
}

extension Double {
    func roundToPlaces(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
