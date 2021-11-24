require 'pg'


def create_db(conn) 
  conn.exec(
      "CREATE TYPE office_types AS ENUM (
        'Office',
        'ATM'
    );")

  conn.exec (
      'CREATE TABLE IF NOT EXISTS offices (
        "id" SERIAL PRIMARY KEY NOT NULL,
        "title" varchar UNIQUE NOT NULL,
        "address" text NOT NULL,
        "city" varchar NOT NULL,
        "state" varchar NOT NULL,
        "phone" varchar NOT NULL,
        "lob" varchar NOT NULL,
        "type" office_type NOT NULL
    );')


  conn.exec(
      'CREATE TABLE IF NOT EXISTS "zones" (
          "id" SERIAL PRIMARY KEY NOT NULL,
          "name" varchar NOT NULL,
          "office_id" int NOT NULL
      );
      ALTER TABLE "zones" ADD FOREIGN KEY ("office_id") REFERENCES "offices" ("id") ON DELETE CASCADE;'
  )


  conn.exec(
    'CREATE TABLE IF NOT EXISTS "rooms" (
      "id" SERIAL PRIMARY KEY NOT NULL,
      "name" varchar NOT NULL,
      "area" integer NOT NULL,
      "max_people" integer NOT NULL,
      "office_id" int NOT NULL,
      "zone_id" int NOT NULL
    );
    ALTER TABLE "rooms" ADD FOREIGN KEY ("office_id") REFERENCES "offices" ("id") ON DELETE CASCADE;
    ALTER TABLE "rooms" ADD FOREIGN KEY ("zone_id") REFERENCES "zones" ("id") ON DELETE CASCADE;'
  )


  conn.exec(
    'CREATE TABLE IF NOT EXISTS "fixtures_types" (
      "id" SERIAL PRIMARY KEY NOT NULL,
      "name" varchar NOT NULL
    );'
  )
  conn.exec(
    'CREATE TABLE IF NOT EXISTS "fixtures" (
      "id" SERIAL PRIMARY KEY NOT NULL,
      "name" varchar NOT NULL,
      "room_id" int NOT NULL,
      "type_id" int NOT NULL
    );
    ALTER TABLE "fixtures" ADD FOREIGN KEY ("room_id") REFERENCES "rooms" ("id") ON DELETE CASCADE;
    ALTER TABLE "fixtures" ADD FOREIGN KEY ("type_id") REFERENCES "fixtures_types" ("id") ON DELETE CASCADE;'
  )

  conn.exec(
    'CREATE TABLE IF NOT EXISTS "marketing_materials" (
      "id" SERIAL PRIMARY KEY NOT NULL,
      "name" varchar NOT NULL,
      "fixture_id" int NOT NULL,
      "type" varchar NOT NULL,
      "cost" int NOT NULL
    );
    ALTER TABLE "marketing_materials" ADD FOREIGN KEY ("fixture_id") REFERENCES "fixtures" ("id") ON DELETE CASCADE;'
  )
end