require 'bundler/setup'
require 'pg'
require 'pry'

conn = PG.connect(dbname: "forum")

table = "users"

conn.exec("DROP TABLE IF EXISTS users CASCADE")
conn.exec("DROP TABLE IF EXISTS topics CASCADE")
conn.exec("DROP TABLE IF EXISTS posts CASCADE")

conn.exec("CREATE TABLE users(
    id SERIAL PRIMARY KEY,
    email VARCHAR,
    password VARCHAR
  )")

conn.exec("CREATE TABLE topics(
    id SERIAL PRIMARY KEY,
    topic_name VARCHAR,
    email VARCHAR,
    user_id INTEGER REFERENCES users(id)
    )"
  )

conn.exec("CREATE TABLE posts(
    id SERIAL PRIMARY KEY,
    text VARCHAR,
    topic_name VARCHAR,
    email VARCHAR,
    user_id INTEGER REFERENCES users(id),
    topic_id INTEGER REFERENCES topics(id)
  )")
