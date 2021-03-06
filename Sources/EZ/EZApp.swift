// (c) 2019-2020 Trevör Anne Denise
// This code is licensed under MIT license (see LICENSE for details)

#if canImport(UIKit)
import UIKit
import FluentKit

public protocol EZApp {
    var database: EZDatabase { get }
    var migrations: [Migration] { get }
}

extension EZApp {
    public func configureDatabase() throws {
        let migrationsObject = Migrations()
        for migration in self.migrations {
            migrationsObject.add(migration)
        }
        let migrator = Migrator(databases: database.dbs, migrations: migrationsObject, logger: database.logger, on: database.eventLoop)
        try migrator.setupIfNeeded().wait()
        try migrator.prepareBatch().wait()
        // FIXME: This isn't a good approach
        EZDatabase._shared = self.database
    }
}

#endif
