import UIKit
import SQLite3
import Foundation

class DatabaseQueries {
    
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
    
}
