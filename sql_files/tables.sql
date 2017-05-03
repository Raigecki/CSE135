CREATE TABLE user (
  ID        SERIAL PRIMARY KEY,
  name      TEXT NOT NULL,
  age       INTEGER NOT NULL,
  state     INTEGER NOT NULL,
  role      INTEGER NOT NULL,
  category  INTEGER REFERENCES category,
)

CREATE TABLE product (
  ID        SERIAL PRIMARY KEY,
  name      TEXT NOT NULL,
  sku       TEXT NOT NULL,
  price     DOUBLE PRECISION NOT NULL,
  category  INTEGER REFERENCES category NOT NULL
)

CREATE TABLE category (
  ID          SERIAL PRIMARY KEY,
  user        INTEGER REFERENCES user NOT NULL,
  name        TEXT NOT NULL,
  description TEXT NOT NULL
)

CREATE TABLE inCategory (
  ID        SERIAL PRIMARY KEY,
  product   INTEGER REFERENCES product NOT NULL,
  category  INTEGER REFERENCES category NOT NULL
)

CREATE TABLE cart (
  ID        SERIAL PRIMARY KEY,
  user      INTEGER REFERENCES user NOT NULL,
  product   INTEGER REFERENCES product NOT NULL,
  quantity  INTEGER NOT NULL
)
