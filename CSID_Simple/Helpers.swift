//
//  Helpers.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/14/24.
//

import Foundation

class Helpers {
    
    func customServingCalculator(actualServingSize: Float, customServing: String, nutrientData: NutrientData) -> NutrientData {
        let adjustor = getAdjustor(servingSize: actualServingSize, customPortion: customServing)
        
        return customPortionAdjustment(nutrientData: nutrientData, adjustor: adjustor)
    }
        
    func getAdjustor(servingSize: Float, customPortion: String) -> Float {
        let cP: Float           = Float(customPortion) ?? 1
        let adjustor:   Float   = cP/servingSize
        
        return adjustor
    }
        
    func customPortionAdjustment(nutrientData: NutrientData, adjustor: Float) -> NutrientData {
        var adjustedCarbs: String       = "N/A"
        var adjustedNetCarbs: String    = "N/A"
        var adjustedStarches: String    = "N/A"
        var adjustedTotalSugars: String = "N/A"
        var adjustedFiber: String       = "N/A"
        var adjustedFructose: String    = "N/A"
        var adjustedGlucose: String     = "N/A"
        var adjustedLactose: String     = "N/A"
        var adjustedMaltose: String     = "N/A"
        var adjustedSucrose: String     = "N/A"
        
        if nutrientData.carbs != "N/A" {
            let aC:  Float  = (Float(nutrientData.carbs)!*adjustor)
            adjustedCarbs   = String(format: "%.1f", aC)
        }
        
        if nutrientData.fiber != "N/A" {
            let aF:  Float  = (Float(nutrientData.fiber)!*adjustor)
            adjustedFiber   = String(format: "%.1f", aF)
        }
        
        if nutrientData.netCarbs != "N/A" {
            let aNC:  Float    = (Float(nutrientData.netCarbs)!*adjustor)
            adjustedNetCarbs   = String(format: "%.1f", aNC)
        }
        
        if nutrientData.totalStarches != "N/A" {
            let aS:  Float     = (Float(nutrientData.totalStarches)!*adjustor)
            adjustedStarches   = String(format: "%.1f", aS)
        }
        
        if nutrientData.totalSugars != "N/A" {
            let aTS:  Float     = (Float(nutrientData.totalSugars)!*adjustor)
            adjustedTotalSugars = String(format: "%.1f", aTS)
        }
        
        if nutrientData.fructose != "N/A" {
            let aF:  Float      = (Float(nutrientData.fructose)!*adjustor)
            adjustedFructose    = String(format: "%.1f", aF)
        }
        
        if nutrientData.glucose != "N/A" {
            let aGl:  Float     = (Float(nutrientData.glucose)!*adjustor)
            adjustedGlucose     = String(format: "%.1f", aGl)
        }
        
        if nutrientData.lactose != "N/A" {
            let aL:  Float      = (Float(nutrientData.lactose)!*adjustor)
            adjustedLactose     = String(format: "%.1f", aL)
        }
        
        if nutrientData.maltose != "N/A" {
            let aM:  Float      = (Float(nutrientData.maltose)!*adjustor)
            adjustedMaltose     = String(format: "%.1f", aM)
        }
        
        if nutrientData.sucrose != "N/A" {
            let aSuc:  Float    = (Float(nutrientData.sucrose)!*adjustor)
            adjustedSucrose     = String(format: "%.1f", aSuc)
        }
        
        let adjustedNutrientData = NutrientData(carbs: adjustedCarbs, fiber: adjustedFiber, netCarbs: adjustedNetCarbs, totalSugars: adjustedTotalSugars, totalStarches: adjustedStarches, totalSugarAlcohols: "", protein: "", totalFat: "", sodium: "", ingredients: nutrientData.ingredients, fructose: adjustedFructose, glucose: adjustedGlucose, lactose: adjustedLactose, maltose: adjustedMaltose, sucrose: adjustedSucrose)
        
        return adjustedNutrientData
    }
    
    // Define arrays for sugar ingredients and their replacements
    var sugarKeywords: [String] = [
        "organic hydrogenated starch hydrolysates",
        "organic hfcs (high-fructose corn syrup)",
        "organic free-flowing brown sugars",
        "organic glucose-fructose syrup",
        "hydrogenated starch hydrolysates",
        "organic high fructose corn syrup",
        "hfcs (high-fructose corn syrup)",
        "organic brown rice syrup solids",
        "organic fruit juice concentrate",
        "organic dehydrated cane juice",
        "organic evaporated cane juice",
        "organic confectioner's sugar",
        "organic cane juice crystals",
        "organic coconut palm sugar",
        "organic monk fruit extract",
        "free-flowing brown sugars",
        "organic barley malt syrup",
        "organic corn syrup solids",
        "high fructose corn syrup",
        "organic brown rice syrup",
        "organic refiner's syrup",
        "organic turbinado sugar",
        "brown rice syrup solids",
        "fruit juice concentrate",
        "glucose-fructose syrup",
        "organic barbados sugar",
        "organic buttered syrup",
        "organic cemerara sugar",
        "organic powdered sugar",
        "organic corn sweetener",
        "organic glucose solids",
        "dehydrated cane juice",
        "evaporated cane juice",
        "organic coconut sugar",
        "organic sorghum Syrup",
        "organic sweet sorghum",
        "organic sugar alcohol",
        "confectioner's sugar",
        "organic castor sugar",
        "organic golden sugar",
        "organic golden syrup",
        "organic invert sugar",
        "organic yellow sugar",
        "organic agave nectar",
        "organic maltodextrin",
        "cane juice crystals",
        "organic brown sugar",
        "organic carob syrup",
        "organic icing sugar",
        "organic maple syrup",
        "organic agave syrup",
        "organic barley malt",
        "organic fruit juice",
        "organic grape sugar",
        "coconut palm sugar",
        "organic beet sugar",
        "organic cane juice",
        "organic cane sugar",
        "organic cane syrup",
        "organic palm sugar",
        "organic saccharose",
        "monk fruit extract",
        "organic date sugar",
        "organic malt syrup",
        "organic rice syrup",
        "organic corn syrup",
        "organic erythritol",
        "organic monk fruit",
        "barley malt syrup",
        "organic muscovado",
        "organic raw sugar",
        "corn syrup solids",
        "organic molasses",
        "brown rice syrup",
        "organic dextrose",
        "organic fructose",
        "organic maltitol",
        "organic mannitol",
        "organic sorbitol",
        "refiner's syrup",
        "turbinado sugar",
        "organic caramel",
        "organic panocha",
        "organic sucrose",
        "organic treacle",
        "organic dextrin",
        "organic glucose",
        "organic maltose",
        "organic mannose",
        "organic xylitol",
        "organic isomalt",
        "buttered syrup",
        "cemerara sugar",
        "powdered sugar",
        "corn sweetener",
        "glucose solids",
        "organic maltol",
        "barbados sugar",
        "coconut sugar",
        "sorghum Syrup",
        "sweet sorghum",
        "organic sugar",
        "organic syrup",
        "organic honey",
        "castor sugar",
        "golden sugar",
        "golden syrup",
        "invert sugar",
        "yellow sugar",
        "sugar alcohol",
        "agave nectar",
        "maltodextrin",
        "brown sugar",
        "carob syrup",
        "icing sugar",
        "maple syrup",
        "agave syrup",
        "barley malt",
        "fruit juice",
        "grape sugar",
        "beet sugar",
        "cane juice",
        "cane sugar",
        "cane syrup",
        "palm sugar",
        "saccharose",
        "date sugar",
        "malt syrup",
        "rice syrup",
        "corn syrup",
        "erythritol",
        "monk fruit",
        "muscovado",
        "raw sugar",
        "molasses",
        "dextrose",
        "fructose",
        "maltitol",
        "mannitol",
        "sorbitol",
        "caramel",
        "panocha",
        "sucrose",
        "treacle",
        "dextrin",
        "glucose",
        "maltose",
        "mannose",
        "xylitol",
        "isomalt",
        "maltol",
        "sugar",
        "syrup",
        "honey"
    ]

    var sugarReplacements: [String] = [
        "O300",
        "O299",
        "S298",
        "O297.5",
        "O297",
        "O296",
        "O295",
        "O294",
        "O293",
        "S292",
        "S291",
        "S290",
        "S289",
        "S288",
        "O287",
        "S286",
        "S285",
        "O284",
        "O283",
        "O282",
        "S281",
        "S280",
        "O279",
        "O278",
        "0277.5",
        "S277",
        "S276",
        "S275",
        "S274",
        "O273",
        "O272",
        "S271",
        "S270",
        "S269",
        "S268",
        "S267",
        "O266",
        "S265",
        "S264",
        "S263",
        "S262",
        "S261",
        "S260",
        "O259",
        "O258",
        "S257",
        "S256",
        "S255",
        "S254",
        "S253",
        "O252",
        "O251",
        "O250",
        "O249",
        "S248",
        "S247",
        "S246",
        "S245",
        "S244",
        "S243",
        "S242",
        "O241",
        "O240",
        "O239",
        "O238",
        "O237",
        "O236",
        "O235",
        "S234",
        "S233",
        "S232",
        "O231",
        "S230",
        "O229",
        "O228",
        "O227",
        "O226",
        "O225",
        "O224",
        "S223",
        "S222",
        "S221",
        "S220",
        "S219",
        "S218",
        "O217",
        "O216",
        "O215",
        "O214",
        "O213",
        "O212",
        "S211",
        "S210",
        "S209",
        "O208",
        "O207",
        "O206",
        "S205",
        "S204",
        "S203",
        "S202",
        "S201",
        "S200",
        "O199",
        "S198",
        "S197",
        "S196",
        "S195",
        "S194",
        "O193",
        "O192",
        "O191",
        "S190",
        "S189",
        "S188",
        "S187",
        "O186",
        "O185",
        "O184",
        "O183",
        "S182",
        "S181",
        "S180",
        "S179",
        "S178",
        "S177",
        "O176",
        "O175",
        "O174",
        "O173",
        "O172",
        "O171",
        "S170",
        "S169",
        "S168",
        "O167",
        "O166",
        "O165",
        "O164",
        "O163",
        "S162",
        "S161",
        "S160",
        "S159",
        "O158",
        "O157",
        "O156",
        "O155",
        "O154",
        "O153",
        "O152",
        "S151",
        "S150",
        "O149"
    ]

//FUTURE FEATURE THAT NEEDS TO BE FURTHER REFINED
//    // Define natural sucrose sources
//    let naturalSucroseSources = [
//        "all purpose flour",
//        "almond",
//        "amaranth",
//        "apple",
//        "apricot",
//        "artichoke",
//        "asparagus",
//        "aurgula",
//        "avocado",
//        "babaco",
//        "bamboo shoot",
//        "banana",
//        "barley",
//        "beetroot",
//        "beets",
//        "bilberr",
//        "black bean",
//        "blackberr",
//        "blackcurrant",
//        "blueberr",
//        "boysenberr",
//        "brazil nut",
//        "broccoli",
//        "brown rice",
//        "brussel sprout",
//        "buckwheat",
//        "butter bean",
//        "cantaloupe",
//        "carob",
//        "carrot",
//        "cashew",
//        "cassava",
//        "celery",
//        "cheddar cheese",
//        "cherrie",
//        "cherry",
//        "chestnut",
//        "chickpea",
//        "chive",
//        "choko",
//        "cocoa powder",
//        "coconut",
//        "colby cheese",
//        "corn chip",
//        "cornflour",
//        "cornmeal",
//        "couscous",
//        "cranberr",
//        "creamed wheat",
//        "cress",
//        "currant",
//        "dates",
//        "edamame",
//        "egg noodle",
//        "eggplant",
//        "endive",
//        "fava bean",
//        "fig",
//        "flaxseed",
//        "Garlic powder",
//        "graham cracker",
//        "graham flour",
//        "grape",
//        "grapefruit",
//        "great northern bean",
//        "green bean",
//        "green pepper",
//        "grits",
//        "guava",
//        "ham",
//        "hazelnut",
//        "hibiscus",
//        "hominy",
//        "jasmine",
//        "kale",
//        "kidney bean",
//        "kiwi",
//        "kohirabi",
//        "lasagna",
//        "leek",
//        "lemon",
//        "lentil",
//        "lima bean",
//        "lime",
//        "lobster",
//        "loganberr",
//        "lychee",
//        "macadamia",
//        "macaroni",
//        "maize",
//        "mandarin",
//        "mango",
//        "millet",
//        "miso",
//        "mulberr",
//        "mung bean",
//        "muscadine grape",
//        "mussel",
//        "mutton",
//        "navy bean",
//        "nectarine",
//        "Oat bran",
//        "oat flour",
//        "Oatmeal",
//        "okra",
//        "onion",
//        "orange",
//        "orzo",
//        "oyster",
//        "parsnip",
//        "passion fruit",
//        "pastry",
//        "pea",
//        "peach",
//        "peanut",
//        "pear",
//        "pecan",
//        "persimmon",
//        "pine nut",
//        "pineapple",
//        "pinto bean",
//        "pipi",
//        "pistachio",
//        "pita",
//        "plantain",
//        "plum",
//        "Popcorn",
//        "Poppy seed",
//        "potato",
//        "prawn",
//        "pretzel",
//        "prune",
//        "pumpkin",
//        "quince",
//        "quinoa",
//        "radish",
//        "raisin",
//        "raspberr",
//        "red cabbage",
//        "rhubarb",
//        "Rice cake",
//        "rice noodle",
//        "Rye flour",
//        "seakale",
//        "seaweed",
//        "semolina",
//        "sesame seed",
//        "sorghum",
//        "soy",
//        "soybean",
//        "soyflour",
//        "spaghetti",
//        "spelt",
//        "spinach",
//        "sprout",
//        "squash",
//        "strawberr",
//        "sultana",
//        "sunflower seed",
//        "swede",
//        "sweet corn",
//        "sweet potato",
//        "sweetened condensed milk",
//        "swiss cheese",
//        "tamarillo",
//        "tangelo",
//        "tangerine",
//        "tapioca",
//        "taro",
//        "tofu",
//        "tortilla",
//        "tostada",
//        "triticale",
//        "turnip",
//        "walnut",
//        "water chestnut",
//        "watercress",
//        "watermelon",
//        "wheat",
//        "white cabbage",
//        "white flour",
//        "white rice",
//        "whole grain rice",
//        "wild rice",
//        "yam",
//        "zucchini"
//    ]
//    
//    let naturalStarchSources = [
//        "Adzuki bean",
//        "All purpose flour",
//        "almond",
//        "amaranth",
//        "Apple",
//        "apricot",
//        "arrowroot",
//        "Artichoke",
//        "Avocado",
//        "Babaco",
//        "Baking powder",
//        "Banana",
//        "Barley",
//        "basil",
//        "Basmati",
//        "Bean sprout",
//        "beet",
//        "Bell pepper",
//        "Black bean",
//        "boysenberr",
//        "Brazil nut",
//        "Broad bean",
//        "broccoli",
//        "Brown rice",
//        "Brussel sprout",
//        "buckwheat",
//        "bulgur",
//        "Butter bean",
//        "cabbage",
//        "Capsicum",
//        "carob",
//        "carrot",
//        "cashew",
//        "cassava",
//        "Cauliflower",
//        "chard",
//        "Cherries",
//        "chestnut",
//        "Chia seed",
//        "chickpea",
//        "Chicory",
//        "Chive",
//        "choko",
//        "Cocoa powder",
//        "Collards",
//        "Corn",
//        "Cornflour",
//        "Cornmeal",
//        "Cornstarch",
//        "couscous",
//        "cress",
//        "croissant",
//        "cucumber",
//        "Edamame",
//        "Egg noodle",
//        "Egg pasta",
//        "eggplant",
//        "English muffin",
//        "Farina",
//        "Fava bean",
//        "Figs",
//        "Flax",
//        "garlic",
//        "gelatin",
//        "Gherkin",
//        "Graham",
//        "Great northern bean",
//        "Green bean",
//        "guava",
//        "Hazelnut",
//        "hominy",
//        "honeydew",
//        "jasmine",
//        "kale",
//        "Kidney bean",
//        "Kumara",
//        "lasagna",
//        "lentil",
//        "Lima bean",
//        "Macadamia",
//        "macaroni",
//        "maize",
//        "mango",
//        "Millet",
//        "miso",
//        "mulberr",
//        "Mung bean",
//        "mushroom",
//        "Mustard green",
//        "mutton",
//        "Navy bean",
//        "nectarine",
//        "Oat bran",
//        "Oat flour",
//        "oatmeal",
//        "oats",
//        "okra",
//        "onion",
//        "Orange",
//        "orzo",
//        "papaya",
//        "parsnip",
//        "Passion fruit",
//        "pasta",
//        "pastry",
//        "pea",
//        "peanut",
//        "pecan",
//        "Persimmon",
//        "Pine nut",
//        "Pinto bean",
//        "Pipi",
//        "Pistachio",
//        "Pita",
//        "plantain",
//        "plum",
//        "polenta",
//        "popcorn",
//        "potato",
//        "Pretzel",
//        "Prune",
//        "pumpkin",
//        "quinoa",
//        "raisin",
//        "Rhubarb",
//        "Rice cake",
//        "Rice flour",
//        "Rice noodle",
//        "Ritz cracker",
//        "rutabaga",
//        "rye",
//        "sago",
//        "Salmon",
//        "Saltine cracker",
//        "seaweed",
//        "semolina",
//        "Sesame",
//        "Sorghum",
//        "Soy flour",
//        "Soybean",
//        "Spaghetti",
//        "Spaghetti",
//        "Spelt",
//        "spinach",
//        "Spring greens",
//        "Squash",
//        "strawberr",
//        "suet",
//        "sunflower",
//        "swede",
//        "Sweet corn",
//        "Sweet potato",
//        "Tamarillo",
//        "Tapioca",
//        "Taro",
//        "tofu",
//        "tortilla",
//        "tostada",
//        "triscuit",
//        "Triticale",
//        "Trout",
//        "turnip",
//        "Udon",
//        "walnut",
//        "Water chestnut",
//        "watercress",
//        "wheat",
//        "Wheat bran",
//        "Wheat thin",
//        "White flour",
//        "White rice",
//        "Wild rice",
//        "yam",
//        "yeast",
//        "Yellow wax bean",
//    ]

    // Function to replace sugar ingredients with unique codes
    private func replaceSugarIngredients(in ingredients: String) -> String {
        var processedIngredients = ingredients.lowercased().replacingOccurrences(of: "sugar free", with: "")
        for (index, sugarKeyword) in sugarKeywords.enumerated() {
            processedIngredients = processedIngredients.replacingOccurrences(of: sugarKeyword, with: sugarReplacements[index])
        }
        return processedIngredients
    }

    // Function to categorize sugar and sugar alternatives
    private func extractSugarCategories(from ingredients: String) -> [[String]] {
        var categorizedIngredients: [[String]] = [[], []] // [Sugars, Alternatives]
        for (index, replacement) in sugarReplacements.enumerated() {
            if ingredients.contains(replacement) {
                if replacement.contains("S") {
                    categorizedIngredients[0].append(sugarKeywords[index]) // Sugars
                } else {
                    categorizedIngredients[1].append(sugarKeywords[index]) // Alternatives
                }
            }
        }
        return categorizedIngredients
    }


    //Future Function to extract natural sucrose sources
//   private func extractNaturalSucrose(from ingredients: String) -> [String] {
//        let charactersToReplace: [String] = ["(", ")", "[", "]", "{", "}", ".", "*", ":"]
//        let sanitizedIngredients = charactersToReplace.reduce(ingredients) { result, character in result.replacingOccurrences(of: character, with: ", ")}
//            .lowercased()
//            .trimmingCharacters(in: .whitespacesAndNewlines)
//            .components(separatedBy: ", ")
//        
//        var naturalSucroseMatches: Set<String> = []
//        for ingredient in sanitizedIngredients {
//            if naturalSucroseSources.contains(where: { ingredient.contains($0.lowercased()) }) {
//                naturalSucroseMatches.insert(ingredient.trimmingCharacters(in: .whitespacesAndNewlines))
//            }
//        }
//        return Array(naturalSucroseMatches).filter { !$0.contains("oil") }.sorted()
//    }
    
    // Future Function to extract natural starch sources
//   private func extractNaturalStarch(from ingredients: String) -> [String] {
//        let charactersToReplace: [String] = ["(", ")", "[", "]", "{", "}", ".", "*", ":"]
//        let sanitizedIngredients = charactersToReplace.reduce(ingredients) { result, character in result.replacingOccurrences(of: character, with: ", ")}
//            .lowercased()
//            .components(separatedBy: ", ")
//        
//        var naturalStarchMatches: Set<String> = []
//        for ingredient in sanitizedIngredients {
//            if naturalStarchSources.contains(where: { ingredient.contains($0.lowercased()) }) {
//                naturalStarchMatches.insert(ingredient.trimmingCharacters(in: .whitespacesAndNewlines))
//            }
//        }
//       return Array(naturalStarchMatches).filter { !$0.contains("oil") }.sorted()
//    }

    // Function to retrieve all sucrose-related ingredients
    func findSucroseIngredients(in ingredients: String) -> [[String]] {
        let replacedIngredients = replaceSugarIngredients(in: ingredients)
        var categorizedIngredients = extractSugarCategories(from: replacedIngredients)
//        let naturalSucrose = extractNaturalSucrose(from: ingredients)
//        let naturalStarch = extractNaturalStarch(from: ingredients)
//        categorizedIngredients.append(naturalSucrose)
//        categorizedIngredients.append(naturalStarch)
        if categorizedIngredients[0].isEmpty {
            categorizedIngredients[0].append("No sucrose detected.\nAs always, check the ingredients")
        }
        
        if categorizedIngredients[1].isEmpty {
            categorizedIngredients[1].append("No other sugars detected.\nAs always check the ingredients")
        }
        
        return categorizedIngredients
    }
}
