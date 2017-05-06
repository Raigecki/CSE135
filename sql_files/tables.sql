CREATE TABLE usert (
  id        SERIAL PRIMARY KEY,
  name      TEXT NOT NULL,
  age       INTEGER NOT NULL,
  state     INTEGER NOT NULL,
  role      INTEGER NOT NULL,
  category  INTEGER REFERENCES category,
);

CREATE TABLE product (
  id        SERIAL PRIMARY KEY,
  name      TEXT NOT NULL,
  sku       TEXT NOT NULL UNIQUE,
  price     DOUBLE PRECISION NOT NULL,
  category  INTEGER REFERENCES category NOT NULL,
  CHECK (price>=0 AND name!="")
);

CREATE TABLE category (
  id          SERIAL PRIMARY KEY,
  userid      INTEGER REFERENCES usert NOT NULL,
  name        TEXT NOT NULL,
  description TEXT NOT NULL
);

CREATE TABLE incategory (
  id        SERIAL PRIMARY KEY,
  product   INTEGER REFERENCES product NOT NULL,
  category  INTEGER REFERENCES category NOT NULL
);

CREATE TABLE cart (
  id        SERIAL PRIMARY KEY,
  userid    INTEGER REFERENCES usert NOT NULL,
  product   INTEGER REFERENCES product NOT NULL,
  quantity  INTEGER NOT NULL
);