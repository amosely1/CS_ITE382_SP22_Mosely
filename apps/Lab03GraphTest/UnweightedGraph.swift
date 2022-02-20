//
//  UnweightedGraph.swift
//  Lab03GraphTest
//
//  Created by Alyson Mosely on 2/19/22.
//

import Foundation

open class UnweightedEdge: Edge {
    public var u: Int //"from" vertex
    public var v: Int //"to" vertex
    public var reversed: Edge {
        return UnweightedEdge(u: v, v: u)
    }
    
    public init(u: Int, v: Int) {
        self.u = u
        self.v = v
    }
    
    //MARK: CustomStringConvertable
    public var description: String {
        return "\(u) <-> \(v)"
    }
}

open class UnweightedGraph<V: Equatable>: Graph {
    var vertices: [V] = [V]()
    var edges: [[UnweightedEdge]] = [[UnweightedEdge]]() //adjacency lists
    //Empty initializer
    public init() {
    }
        //List initiliaer
        public init(vertices: [V]) {
            for vertex in vertices {
                _ = self.addVertex(vertex)
            }
        }
        ///This is a conveniece method that adds an unweighted edge
        ///
        ///- parameter from: The starting vertex's index
        ///- parameter to: the ending vertex's index
        public func addEdge(from: Int, to: Int) {
                addEdge(_e:UnweightedEdge(u: from, v: to))
            }
            
            ///This is a convenience method that adds an unweighted, undirected edge between the first
            ///occurence of two vertices
            ///
            ///- parameter from: the starting vertex
            /// - parameter to: the ending vertex
            public func addEdge(from: V, to: V) {
                if let u = indexOfVertex(from) {
                    if let v = indexOfVertex(to) {
                        addEdge(_e:UnweightedEdge(u: u, v: v))
                    }
                }
            }
            ///MARK: Implement CustomStringConvertible
    public var description: String {
        var d: String = " "
        for i in 0..<vertices.count {
            d += "\(vertices[i]) -> \neighborsForIndex(i))\n"
        }
        return d
        }
    }
