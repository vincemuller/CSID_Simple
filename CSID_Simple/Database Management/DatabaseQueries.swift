import UIKit
import SQLite3
import Foundation

class DatabaseQueries {
    
    static func dataFormater(value: String) -> String {
        guard value != "N/A" else {
            let formattedValue = "N/A"
            return formattedValue
        }
        
        guard let floatValue = Float(value) else { return "N/A" }
        
        let formattedValue = String(format: "%.1f",floatValue)
        
        return formattedValue
    }
    
    // Extracts and returns string data from a SQL statement or returns "N/A" if nil
    static func sqlColumnProcessing(queryStatement: UnsafePointer<UInt8>?) -> String {
        guard let result = queryStatement else { return "N/A" }
        return String(cString: result)
    }
    
    // Generalized function to execute a query and fetch results
    static func executeQuery(databasePointer: OpaquePointer?, query: String, processRow: (OpaquePointer) -> Void) {
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(databasePointer, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                processRow(queryStatement!)
            }
        } else if let error = sqlite3_errmsg(databasePointer) {
            print("SQL Error: \(String(cString: error))")
        }
        
        sqlite3_finalize(queryStatement)
    }
    
    static func databaseSearch(searchTerms: String, databasePointer: OpaquePointer?, sortFilter: String = "wholeFood DESC, length(description)") -> [FoodDetails] {
        let query = """
            SELECT searchKeyWords, fdicID, brandOwner, brandName, brandedFoodCategory, description, servingSize, servingSizeUnit, carbs, totalSugars, totalStarches, wholeFood
            FROM USDAFoodSearchTable
            WHERE \(searchTerms)
            ORDER BY \(sortFilter);
        """
        print(query)
        var results: [FoodDetails] = []
        executeQuery(databasePointer: databasePointer, query: query) { statement in
            results.append(
                FoodDetails(
                    searchKeyWords: sqlColumnProcessing(queryStatement: sqlite3_column_text(statement, 0)),
                    fdicID: Int(sqlite3_column_int(statement, 1)),
                    brandOwner: sqlColumnProcessing(queryStatement: sqlite3_column_text(statement, 2)),
                    brandName: sqlColumnProcessing(queryStatement: sqlite3_column_text(statement, 3)),
                    brandedFoodCategory: sqlColumnProcessing(queryStatement: sqlite3_column_text(statement, 4)),
                    description: sqlColumnProcessing(queryStatement: sqlite3_column_text(statement, 5)),
                    servingSize: Float(sqlite3_column_double(statement, 6)),
                    servingSizeUnit: sqlColumnProcessing(queryStatement: sqlite3_column_text(statement, 7)),
                    carbs: sqlColumnProcessing(queryStatement: sqlite3_column_text(statement, 8)).dataFormater(),
                    totalSugars: sqlColumnProcessing(queryStatement: sqlite3_column_text(statement, 9)).dataFormater(),
                    totalStarches: sqlColumnProcessing(queryStatement: sqlite3_column_text(statement, 10)).dataFormater(),
                    wholeFood: sqlColumnProcessing(queryStatement: sqlite3_column_text(statement, 11))
                )
            )
        }
        
        return results
    }
    
    static func databaseSavedFoodsSearch(searchTerms: String, databasePointer: OpaquePointer?) -> [FoodDetails] {
        let query = """
            SELECT searchKeyWords, fdicID, brandOwner, brandName, brandedFoodCategory, description, servingSize, servingSizeUnit, carbs, totalSugars, totalStarches, wholeFood
            FROM USDAFoodSearchTable
            WHERE \(searchTerms);
        """
        print(query)
        var results: [FoodDetails] = []
        executeQuery(databasePointer: databasePointer, query: query) { statement in
            results.append(
                FoodDetails(
                    searchKeyWords: sqlColumnProcessing(queryStatement: sqlite3_column_text(statement, 0)),
                    fdicID: Int(sqlite3_column_int(statement, 1)),
                    brandOwner: sqlColumnProcessing(queryStatement: sqlite3_column_text(statement, 2)),
                    brandName: sqlColumnProcessing(queryStatement: sqlite3_column_text(statement, 3)),
                    brandedFoodCategory: sqlColumnProcessing(queryStatement: sqlite3_column_text(statement, 4)),
                    description: sqlColumnProcessing(queryStatement: sqlite3_column_text(statement, 5)),
                    servingSize: Float(sqlite3_column_double(statement, 6)),
                    servingSizeUnit: sqlColumnProcessing(queryStatement: sqlite3_column_text(statement, 7)),
                    carbs: sqlColumnProcessing(queryStatement: sqlite3_column_text(statement, 8)).dataFormater(),
                    totalSugars: sqlColumnProcessing(queryStatement: sqlite3_column_text(statement, 9)).dataFormater(),
                    totalStarches: sqlColumnProcessing(queryStatement: sqlite3_column_text(statement, 10)).dataFormater(),
                    wholeFood: sqlColumnProcessing(queryStatement: sqlite3_column_text(statement, 11))
                )
            )
        }
        
        return results
    }
    
    static func getNutrientData(fdicID: Int, databasePointer: OpaquePointer?) -> NutrientData {
        
        var queryStatement:     OpaquePointer?
        var nutrientData:       NutrientData?
        var carbs:              String = "N/A"
        var netCarbs:           String = "N/A"
        var totalSugars:        String = "N/A"
        var totalStarches:      String = "N/A"
        var totalSugarAlcohols: String = "N/A"
        var fiber:              String = "N/A"
        var protein:            String = "N/A"
        var totalFat:           String = "N/A"
        var sodium:             String = "N/A"
        var ingredients:        String = "N/A"
        var fructose:           String = "N/A"
        var glucose:            String = "N/A"
        var lactose:            String = "N/A"
        var maltose:            String = "N/A"
        var sucrose:            String = "N/A"
        
        
        let queryStatementString = """
            SELECT carbs, totalSugars, totalSugarAlcohols, fiber, protein, totalFat, sodium, ingredients, fructose, glucose, lactose, maltose, sucrose, starch FROM USDAFoodNutData
            WHERE fdicID=\(fdicID);
            """
        if sqlite3_prepare_v2(
          databasePointer,
          queryStatementString,
          -1,
          &queryStatement,
          nil
        ) == SQLITE_OK {
        if sqlite3_step(queryStatement) == SQLITE_ROW {
            if let queryResultCarbs = sqlite3_column_text(queryStatement, 0) {
                carbs    = String(cString: queryResultCarbs)
            } else {
                carbs    = "N/A"
            }
            if let queryResultTotalSugars = sqlite3_column_text(queryStatement, 1) {
                totalSugars = String(cString: queryResultTotalSugars)
            } else {
                totalSugars = "N/A"
            }
            if let queryResultTotalSugarAlcohols = sqlite3_column_text(queryStatement, 2) {
                totalSugarAlcohols = String(cString: queryResultTotalSugarAlcohols)
            } else {
                totalSugarAlcohols = "N/A"
            }
            if let queryResultFiber = sqlite3_column_text(queryStatement, 3) {
                fiber = String(cString: queryResultFiber)
            } else {
                fiber = "N/A"
            }
            if let queryResultProtein = sqlite3_column_text(queryStatement, 4) {
                protein = String(cString: queryResultProtein)
            } else {
                protein = "N/A"
            }
            if let queryResultTotalFat = sqlite3_column_text(queryStatement, 5) {
                totalFat = String(cString: queryResultTotalFat)
            } else {
                totalFat = "N/A"
            }
            if let queryResultSodium = sqlite3_column_text(queryStatement, 6) {
                sodium = String(cString: queryResultSodium)
            } else {
                sodium = "N/A"
            }
            if let queryResultIngredients = sqlite3_column_text(queryStatement, 7) {
                ingredients = String(cString: queryResultIngredients)
            } else {
                ingredients = "N/A"
            }
            if let queryResultFructose = sqlite3_column_text(queryStatement, 8) {
                fructose = String(cString: queryResultFructose)
            } else {
                fructose = "N/A"
            }
            if let queryResultGlucose = sqlite3_column_text(queryStatement, 9) {
                glucose = String(cString: queryResultGlucose)
            } else {
                glucose = "N/A"
            }
            if let queryResultLactose = sqlite3_column_text(queryStatement, 10) {
                lactose = String(cString: queryResultLactose)
            } else {
                lactose = "N/A"
            }
            if let queryResultMaltose = sqlite3_column_text(queryStatement, 11) {
                maltose = String(cString: queryResultMaltose)
            } else {
                maltose = "N/A"
            }
            if let queryResultSucrose = sqlite3_column_text(queryStatement, 12) {
                sucrose = String(cString: queryResultSucrose)
            } else {
                sucrose = "N/A"
            }
              }
            
          } else {
              let errorMessage    = String(cString: sqlite3_errmsg(databasePointer))
              print("error originating from queryDatabaseNutrientData in CADatabaseQueryHelper \(errorMessage)")

          }
          sqlite3_finalize(queryStatement)
        
        //Calculating net data
        //Net Carbs
        if carbs == "N/A" {
            netCarbs = "N/A"
        } else if fiber == "N/A" {
            netCarbs = String(format: "%.1f",Float(carbs) ?? 0)
        } else if totalSugarAlcohols == "N/A" {
            let nC = (max((Float(carbs)!)-(Float(fiber)!), 0))
            netCarbs = String(format: "%.1f",Float(nC))
        } else {
            let nC = (max((Float(carbs)!)-(Float(fiber)!)-(Float(totalSugarAlcohols)!), 0))
            netCarbs = String(format: "%.1f",Float(nC))
        }
        
        //Total Starches
        if carbs == "N/A" || totalSugars == "N/A" {
            totalStarches   = "N/A"
        } else if fiber == "N/A" {
            let tS   = (max((Float(carbs)!)-(Float(totalSugars)!), 0))
            totalStarches = String(format: "%.1f",Float(tS))
        } else {
            let tS = (max((Float(carbs)!)-(Float(fiber)!)-(Float(totalSugars)!), 0))
            totalStarches = String(format: "%.1f",Float(tS))
        }
        
        carbs       = dataFormater(value: carbs)
        totalSugars = dataFormater(value: totalSugars)
        fiber       = dataFormater(value: fiber)
        totalSugarAlcohols = dataFormater(value: totalSugarAlcohols)
        protein     = dataFormater(value: protein)
        totalFat    = dataFormater(value: totalFat)
        sodium      = dataFormater(value: sodium)
        fructose    = dataFormater(value: fructose)
        glucose     = dataFormater(value: glucose)
        lactose     = dataFormater(value: lactose)
        maltose     = dataFormater(value: maltose)
        sucrose     = dataFormater(value: sucrose)
        
        nutrientData = NutrientData(carbs: carbs, fiber: fiber, netCarbs: netCarbs, totalSugars: totalSugars, totalStarches: totalStarches, totalSugarAlcohols: totalSugarAlcohols, protein: protein, totalFat: totalFat, sodium: sodium, ingredients: ingredients, fructose: fructose, glucose: glucose, lactose: lactose, maltose: maltose, sucrose: sucrose)
        
        return nutrientData ?? NutrientData(carbs: "N/A", fiber: "N/A", netCarbs: "N/A", totalSugars: "N/A", totalStarches: "N/A", totalSugarAlcohols: "N/A", protein: "N/A", totalFat: "N/A", sodium: "N/A", ingredients: "N/A", fructose: "N/A", glucose: "N/A", lactose: "N/A", maltose: "N/A", sucrose: "N/A")
    }
    
}
