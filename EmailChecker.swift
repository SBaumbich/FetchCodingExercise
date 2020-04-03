
// MARK: - Assumptions
// The HTTP Request was successful & the data is valid (list of email addresses) and not nil
// Email domain will always be the full text after the last @ symbol
typealias signature = ([String]) -> Int


import Foundation

let testData = ["test.email@gmail.com",
            "test.email+spam@gmail.com",
            "testemail@gmail.com",
            "s.baumbich@gmail.com",
            "sbaumbich@gmail.com",
            "s.b.a.u.m.b.i.c.h.@gmail.com",
            "sbaumbich.+@gmail.com",
            "sbaum@bich@gmail.com",
            "sbaumbich.+@as;lj!@#$%^&*()_fa; + ;askldj+ @gmail.com",
            "s.baumbich@fetchrewards.com",
            "sbaumbich@fetchrewards.com",
            "l.siegel@fetchrewards.com",
            "lsiegel@fetchrewards.com",
            "l.s.i.e.g.e.l.+.+.+.+.+.+@fetchrewards.com"
            //"@",
            //"",
            //".",
            //"@@"
            //"test"
]

// MARK: - Solution
//------------------------------------------------------------------

let numberOfUniqueEmailAddresses = uniqueEmailAddresses(from: testData)
print("\(numberOfUniqueEmailAddresses)")

//------------------------------------------------------------------

struct EmailAddresse: Hashable {
    var userName: String
    let symbol: String = "@"
    let domain: String
}

// MARK: - Helper Methods

func parseEmailAddress(list: [String]) -> [EmailAddresse] {
    var parseEmailAddresses: [EmailAddresse] = []
    
    for email in testData {
        
        //Revers the email string to find the last "@" symbol
        let reversedEmail = String(email.reversed())
        
        //Grab the index location of the last ("first") "@"symbol
        let endIndex = reversedEmail.range(of: "@")!.lowerBound
        
        //Remove username & "@" symbol and "re" revers the string
        let domain =  String((reversedEmail[..<endIndex]).reversed())
        
        //Essentially do the same as above in 1 line to get the username Only and remove the "@" symbol
        let userName = String(String((reversedEmail[endIndex...]).reversed()).dropLast())
        
        //Add parsed email address to new array of type: emailAddresse
        parseEmailAddresses.append(EmailAddresse(userName: userName, domain: domain))
    }
    return parseEmailAddresses
}

func removeDuplicateUserNames(from list: [EmailAddresse]) -> [EmailAddresse] {
    var cleanedEmailAddresses: [EmailAddresse] = []
    
    for email in list {
        //Remove all the "." characters in the username
        let charToRemove: Set<Character> = ["."]
        var userName = email.userName
        userName.removeAll(where: { charToRemove.contains($0) })
        
        //Remove any portion of the username after a "+" symbol
        //Grab the index location of the first "+" symbol for usernames with a "+"
        if let endIndex = userName.range(of: "+")?.lowerBound {
            
            //Remove everything after "+" symbol
            userName =  String(userName[..<endIndex])
        } 
        cleanedEmailAddresses.append(EmailAddresse(userName: userName, domain: email.domain))
    }
    return cleanedEmailAddresses
}

func uniqueEmailAddresses(from data: [String]) -> Int {
    
    // My assumption is the list of email addresses are valid and not nil
    // We should never hit this but error handling will need to be implemented further.
    for email in data {
        if email == "" {
        print("Bad data encounntered UserName: \(email)\nEmail address contains a nil value\n"); fatalError()
        } else if email.count <= 1 {
        print("Bad data encounntered UserName: \(email)\nEmail address contains too few characters\n"); fatalError()
        } else if  email.rangeOfCharacter(from: CharacterSet(charactersIn: "@")) == nil {
        print("Bad data encounntered UserName: \(email)\nEmail address contains no @ symbol\n"); fatalError()
        }
    }
    let parsedEmails = parseEmailAddress(list: data)
    let purgedEmails = removeDuplicateUserNames(from: parsedEmails)
    let uniqueEmails = Set(purgedEmails)
    //for item in uniqueEmails { print("\(item.userName + item.symbol + item.domain)") }
    return uniqueEmails.count
}

