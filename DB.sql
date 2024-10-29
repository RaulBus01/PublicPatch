CREATE TABLE "users" (
  "id" integer PRIMARY KEY,
  "username" varchar,
  "email" varchar,
  "password" varchar,
  "role" varchar,
  "phone_number" varchar,
  "created_at" timestamp,
  "updated_at" timestamp
);

CREATE TABLE "reports" (
  "id" integer PRIMARY KEY,
  "title" varchar,
  "location_id" integer,
  "category_id" integer,
  "description" text,
  "user_id" integer,
  "status_id" integer,
  "created_at" timestamp,
  "updated_at" timestamp,
  "resolved_at" timestamp,
  "upvotes" integer,
  "downvotes" integer
);

CREATE TABLE "category" (
  "id" integer PRIMARY KEY,
  "name" varchar,
  "description" text
);

CREATE TABLE "status" (
  "id" integer PRIMARY KEY,
  "name" varchar,
  "description" text
);

CREATE TABLE "location" (
  "id" integer PRIMARY KEY,
  "longitude" decimal,
  "latitude" decimal,
  "street_adress" varchar,
  "postal_code" varchar
);

CREATE TABLE "report_images" (
  "id" integer PRIMARY KEY,
  "report_id" integer NOT NULL,
  "image_url" varchar NOT NULL
);

COMMENT ON COLUMN "reports"."description" IS 'Content of the post';

ALTER TABLE "reports" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "category" ADD FOREIGN KEY ("id") REFERENCES "reports" ("category_id");

ALTER TABLE "status" ADD FOREIGN KEY ("id") REFERENCES "reports" ("status_id");

ALTER TABLE "location" ADD FOREIGN KEY ("id") REFERENCES "reports" ("location_id");

ALTER TABLE "report_images" ADD FOREIGN KEY ("report_id") REFERENCES "reports" ("id");
