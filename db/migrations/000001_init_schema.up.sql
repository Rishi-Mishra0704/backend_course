CREATE TABLE "accounts" (
    "id" BIGSERIAL PRIMARY KEY,
    "owner" VARCHAR(255) NOT NULL,
    "balance" BIGINT NOT NULL,
    "currency" VARCHAR NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT (now())
);

CREATE TABLE "entries" (
    "id" BIGSERIAL PRIMARY KEY,
    "account_id" BIGINT,
    "amount" BIGINT NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT (now())
);

CREATE TABLE "transfers" (
    "id" BIGSERIAL PRIMARY KEY,
    "from_account_id" BIGINT,
    "to_account_id" BIGINT,
    "amount" BIGINT NOT NULL,
    "created_at" TIMESTAMP NOT NULL DEFAULT (now())
);

ALTER TABLE "entries"
ADD FOREIGN KEY ("account_id") REFERENCES "accounts"("id");

ALTER TABLE "transfers"
ADD FOREIGN KEY ("from_account_id") REFERENCES "accounts"("id");

ALTER TABLE "transfers"
ADD FOREIGN KEY ("to_account_id") REFERENCES "accounts"("id");

CREATE INDEX ON "accounts" ("owner");
CREATE INDEX ON "entries" ("account_id");
CREATE INDEX ON "transfers" ("from_account_id");
CREATE INDEX ON "transfers" ("to_account_id");
CREATE INDEX ON "transfers" ("from_account_id", "to_account_id");
