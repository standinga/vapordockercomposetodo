import FluentMySQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentMySQLProvider())
    
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    let config = databaseConfig()
    let database = MySQLDatabase(config: config)
    
    // Register the configured MySQL database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: database, as: .mysql)
    services.register(databases)
    
    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Todo.self, database: .mysql)
    services.register(migrations)
}

func databaseConfig() -> MySQLDatabaseConfig {
    // read environemnt vars and print them for debugging:
    let envHost = Environment.get("DATABASE_HOST")
    let envPort = Environment.get("MYSQL_PORT")
    let envUserName = Environment.get("MYSQL_USER")
    let envPass = Environment.get("MYSQL_PASSWORD")
    let evnDBName = Environment.get("MYSQL_DATABASE")
    
    print("envHost: \(String(describing: envHost)) envPort: \(String(describing: envPort)) envUserName: \(String(describing: envUserName)) envPass: \(String(describing: envPass)) evnDBName: \(String(describing: evnDBName))")
    
    let hostName = envHost ?? "0.0.0.0"
    let databasePort = Int(envPort ?? "3306") ?? 3306
    let userName = envUserName ?? "test"
    let password = envPass ?? "test"
    let databaseName = evnDBName ?? "apps"
    
    let config = MySQLDatabaseConfig(hostname: hostName, port: databasePort, username: userName, password: password, database: databaseName)
    return config
}
