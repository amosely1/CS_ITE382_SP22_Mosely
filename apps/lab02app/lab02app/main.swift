//
//  main.swift
//  lab02app
//
//  Created by Alyson Mosely on 2/15/22.
//

import Foundation

let geneSequence = "ACGTGGCTCTCTAACGTACGTACGTACGGGGTTTATATATACCCTAGGACTCCCTTT"
var gene = stringToGene(_s:geneSequence)
let acg: Codon = (.A, .C, .G)
print(geneSequence)
print(gene)

//Linear Code that was refactered with binary search
/*if linearContains(_array:gene, item: acg){
    print("Found it!")
}
else {
    print("Didn't find it")
}*/

//Binary Search
if binaryContains(_array:gene, item: acg){
    print("Found it!")
}
else {
    print("Didn't find it")
}

enum Nucleotide: Character, Comparable
{
    case A = "A", C = "C", G = "G", T = "T"
}

//Override < operator
func <(lhs: Nucleotide, rhs: Nucleotide) -> Bool {
   return (lhs.rawValue < rhs.rawValue)
}

typealias Codon = (Nucleotide, Nucleotide, Nucleotide)
typealias Gene = [Codon]

//Linear search function
func linearContains(_array: Gene, item: Codon) -> Bool {
    for element in _array where item == element {
        return true
    }
    return false
}

//Binary search functon
func binaryContains(_array: Gene, item: Codon) -> Bool {
    var low = 0;
    var high = _array.count - 1
    while low <= high {
        let mid = (low + high)/2
        if _array[mid] < item {
            low = mid + 1
        } else if _array[mid] > item {
            high = mid - 1
        } else {
            return true
        }
    }
    return false
}

//String to gene function
func stringToGene(_s:String) -> Gene {
    var gene = Gene()
    for i in stride(from: 0, to: _s.count, by:3){
    guard (i+2) < _s.count
        else {return gene}
    
        if let n1 = Nucleotide.init(rawValue: _s[_s.index(_s.startIndex, offsetBy: i)
        ]),
           let n2 = Nucleotide.init(rawValue: _s[_s.index(_s.startIndex, offsetBy: i + 1
        )]),
           let n3 = Nucleotide.init(rawValue: _s[_s.index(_s.startIndex, offsetBy: i + 2
        )]) {
            gene.append((n1,n2,n3))
        }
    }
    return gene
}

    
