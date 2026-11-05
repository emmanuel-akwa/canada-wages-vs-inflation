-- 01_create_raw_tables.sql
-- Creates two "raw" staging tables that mirror the Statistics Canada CSV files.
-- Every column is TEXT on purpose: StatCan files can contain blanks, footnote
-- symbols and odd formats, and loading everything as text means the import
-- never fails. Types are fixed later, in SQL, in 03_create_view.sql.
--
-- Load step (done outside SQL): import each CSV with DBeaver (right-click the
-- table > Import Data > CSV). Map every CSV column to the EXISTING table
-- column; DBeaver matches by name, so a header like "Products and product
-- groups" must be mapped by hand to "products".

CREATE TABLE raw_cpi (
    ref_date      TEXT,
    geo           TEXT,
    dguid         TEXT,
    products      TEXT,
    uom           TEXT,
    uom_id        TEXT,
    scalar_factor TEXT,
    scalar_id     TEXT,
    vector        TEXT,
    coordinate    TEXT,
    value         TEXT,
    status        TEXT,
    symbol        TEXT,
    terminated    TEXT,
    decimals      TEXT
);

CREATE TABLE raw_wages (
    ref_date      TEXT,
    geo           TEXT,
    dguid         TEXT,
    employee_type TEXT,
    overtime      TEXT,
    naics         TEXT,
    uom           TEXT,
    uom_id        TEXT,
    scalar_factor TEXT,
    scalar_id     TEXT,
    vector        TEXT,
    coordinate    TEXT,
    value         TEXT,
    status        TEXT,
    symbol        TEXT,
    terminated    TEXT,
    decimals      TEXT
);
