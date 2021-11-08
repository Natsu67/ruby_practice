require 'pg'

conn = PG.connect(:dbname => 'task_1', :password => '', :port => 5432, :user => 'ntnshpig')

conn.exec(
  "CREATE TYPE material_type AS ENUM (
    'Brochure',
    'Poster',
    'Print',
    'Flag'
);")

conn.exec(
  "CREATE TYPE fixture_types AS ENUM (
    'Standing desk',
    'Door',
    'Window',
    'Wall poster',
    'Table',
    'Computer',
    'ATM Wall'
);")

conn.exec(
  "CREATE TYPE office_lob AS ENUM (
    'Commercial',
    'Charity'
);")

conn.exec(
    "CREATE TYPE office_type AS ENUM (
      'Office',
      'ATM'
  );")

conn.exec (
    'CREATE TABLE IF NOT EXISTS offices (
        "id" SERIAL PRIMARY KEY,
        "title" varchar NOT NULL,
        "address" text NOT NULL,
        "city" varchar NOT NULL,
        "state" varchar NOT NULL,
        "phone" varchar NOT NULL,
        "lob" office_lob NOT NULL,
        "type" office_type NOT NULL
  );')


conn.exec(
    'CREATE TABLE IF NOT EXISTS "zones" (
        "id" SERIAL PRIMARY KEY,
        "name" varchar NOT NULL,
        "office_id" int NOT NULL
    );
    ALTER TABLE "zones" ADD FOREIGN KEY ("office_id") REFERENCES "offices" ("id");'
)


conn.exec(
  'CREATE TABLE IF NOT EXISTS "rooms" (
  "id" SERIAL PRIMARY KEY,
  "name" varchar NOT NULL,
  "area" integer NOT NULL,
  "max_people" integer NOT NULL,
  "office_id" integer NOT NULL,
  "zone_id" integer NOT NULL
  );
  ALTER TABLE "rooms" ADD FOREIGN KEY ("zone_id") REFERENCES "zones" ("id");
  ALTER TABLE "rooms" ADD FOREIGN KEY ("office_id") REFERENCES "offices" ("id");'
)

conn.exec(
  'CREATE TABLE IF NOT EXISTS "fixtures" (
    "id" SERIAL PRIMARY KEY,
    "name" varchar NOT NULL,
    "type" fixture_types NOT NULL,
    "room_id" integer NOT NULL
  );
  ALTER TABLE "fixtures" ADD FOREIGN KEY ("room_id") REFERENCES "rooms" ("id");'
)


conn.exec(
  'CREATE TABLE IF NOT EXISTS "marketing_materials" (
    "id" SERIAL PRIMARY KEY,
    "name" varchar NOT NULL,
    "fixture_id" int NOT NULL,
    "type" material_type NOT NULL,
    "cost" integer NOT NULL
  );
  ALTER TABLE "marketing_materials" ADD FOREIGN KEY ("fixture_id") REFERENCES "fixtures" ("id");'
)