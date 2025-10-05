//
//  FoundationNodeExtensions.swift
//  Dagr
//
//  Created by MacBookProMax on 04.10.25.
//
import Foundation

extension FoundationNode.UUID {
    public var string: String {
        "\(String(format: "%02x", a))\(String(format: "%02x", b))\(String(format: "%02x", c))\(String(format: "%02x", d))-\(String(format: "%02x", e))\(String(format: "%02x", f))-\(String(format: "%02x", g))\(String(format: "%02x", h))-\(String(format: "%02x", i))\(String(format: "%02x", j))-\(String(format: "%02x", k))\(String(format: "%02x", l))\(String(format: "%02x", m))\(String(format: "%02x", n))\(String(format: "%02x", o))\(String(format: "%02x", p))"
    }

    public var uuid: UUID {
        UUID(
            uuid:(
                self.a,
                self.b,
                self.c,
                self.d,
                self.e,
                self.f,
                self.g,
                self.h,
                self.i,
                self.j,
                self.k,
                self.l,
                self.m,
                self.n,
                self.o,
                self.p,
            )
        )
    }
}

extension UUID {
    public var uuidNode: FoundationNode.UUID {
        FoundationNode.UUID(
            a: uuid.0,
            b: uuid.1,
            c: uuid.2,
            d: uuid.3,
            e: uuid.4,
            f: uuid.5,
            g: uuid.6,
            h: uuid.7,
            i: uuid.8,
            j: uuid.9,
            k: uuid.10,
            l: uuid.11,
            m: uuid.12,
            n: uuid.13,
            o: uuid.14,
            p: uuid.15
        )
    }
}

extension FoundationNode.UTCTimestamp {
    public var date: Date {
        Date(timeIntervalSince1970: value)
    }
}

extension Date {
    public var utcTimestamp: FoundationNode.UTCTimestamp {
        FoundationNode.UTCTimestamp(value: timeIntervalSince1970)
    }
}

extension URL {
    public var urlNode: FoundationNode.URL {
        FoundationNode.URL(
            scheme: scheme,
            user: user,
            password: password,
            host: host,
            port: port.map{ UInt16($0) },
            path: path,
            query: query,
            fragment: fragment
        )
    }
}

extension FoundationNode.URL {
    public var string: String {
        var schemePart = ""
        if let scheme {
            schemePart = "\(scheme):://"
        }
        var userPasswordPart = ""
        if let user {
            userPasswordPart += user
        }
        if let password, userPasswordPart.isEmpty == false{
            userPasswordPart += ":\(password)"
        }
        if userPasswordPart.isEmpty == false {
            userPasswordPart += "@"
        }
        var portPart = ""
        if let port {
            portPart = ":\(port)"
        }
        var pathPart = ""
        if let path {
            pathPart = "/\(path)"
        }
        var queryPart = ""
        if let query {
            queryPart = "?\(query)"
        }
        var fragmentPart = ""
        if let fragment {
            fragmentPart = "#\(fragment)"
        }
        return "\(schemePart)\(userPasswordPart)\(host ?? "")\(portPart)\(pathPart)\(queryPart)\(fragmentPart)"
    }
    
    public var url: URL? {
        URL.init(string: string)
    }
}
