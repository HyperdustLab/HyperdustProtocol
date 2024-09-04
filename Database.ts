import mysql from 'mysql2/promise'

export class Database {
  private connection: mysql.Connection

  constructor(
    private host: string,
    private user: string,
    private database: string,
    private password: string
  ) {}

  async connect() {
    this.connection = await mysql.createConnection({
      host: this.host,
      user: this.user,
      database: this.database,
      password: this.password,
    })
  }

  async query(sql: string, params?: any[]) {
    const [rows] = await this.connection.execute(sql, params)
    return rows
  }

  async close() {
    await this.connection.end()
  }
}
