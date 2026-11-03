/*
=============================================================
Data Warehouse Setup: Database and Layer Tables (MySQL)
=============================================================
Purpose:
    Sets up the data warehouse for this project in MySQL.
    Creates one database, 'data_warehouse', and organizes it into
    three layers using table-name prefixes:
        bronze_  -> raw data loaded as-is from the CRM and ERP CSV files
        silver_  -> cleaned and standardized data
        gold_    -> business-ready views (customers, products, sales)

Notes:
    - MySQL treats SCHEMA and DATABASE as the same thing, so layers
      are separated by prefix instead of by schema.
    - Gold objects are views and only return data after the
      silver tables are loaded.

WARNING:
    The script drops and recreates the bronze and silver tables if
    they already exist, so any data in them will be permanently
    deleted. Back up your data before running it again.
=============================================================
*/
-- =====================================================
-- Data Warehouse setup (MySQL, one database, layer prefixes)
-- bronze_ = raw, silver_ = cleaned, gold_ = business-ready
-- =====================================================

CREATE DATABASE IF NOT EXISTS data_warehouse;
USE data_warehouse;

-- =====================================================
-- BRONZE LAYER (raw data, loaded as-is from CSV files)
-- =====================================================

DROP TABLE IF EXISTS bronze_crm_cust_info;
CREATE TABLE bronze_crm_cust_info (
    cst_id              INT,
    cst_key             VARCHAR(50),
    cst_firstname       VARCHAR(50),
    cst_lastname        VARCHAR(50),
    cst_marital_status  VARCHAR(50),
    cst_gndr            VARCHAR(50),
    cst_create_date     DATE
);

DROP TABLE IF EXISTS bronze_crm_prd_info;
CREATE TABLE bronze_crm_prd_info (
    prd_id        INT,
    prd_key       VARCHAR(50),
    prd_nm        VARCHAR(100),
    prd_cost      INT,
    prd_line      VARCHAR(50),
    prd_start_dt  DATETIME,
    prd_end_dt    DATETIME
);

DROP TABLE IF EXISTS bronze_crm_sales_details;
CREATE TABLE bronze_crm_sales_details (
    sls_ord_num   VARCHAR(50),
    sls_prd_key   VARCHAR(50),
    sls_cust_id   INT,
    sls_order_dt  INT,
    sls_ship_dt   INT,
    sls_due_dt    INT,
    sls_sales     INT,
    sls_quantity  INT,
    sls_price     INT
);

DROP TABLE IF EXISTS bronze_erp_loc_a101;
CREATE TABLE bronze_erp_loc_a101 (
    cid    VARCHAR(50),
    cntry  VARCHAR(50)
);

DROP TABLE IF EXISTS bronze_erp_cust_az12;
CREATE TABLE bronze_erp_cust_az12 (
    cid    VARCHAR(50),
    bdate  DATE,
    gen    VARCHAR(50)
);

DROP TABLE IF EXISTS bronze_erp_px_cat_g1v2;
CREATE TABLE bronze_erp_px_cat_g1v2 (
    id           VARCHAR(50),
    cat          VARCHAR(50),
    subcat       VARCHAR(50),
    maintenance  VARCHAR(50)
);

-- =====================================================
-- SILVER LAYER (cleaned and standardized data)
-- =====================================================

DROP TABLE IF EXISTS silver_crm_cust_info;
CREATE TABLE silver_crm_cust_info (
    cst_id              INT,
    cst_key             VARCHAR(50),
    cst_firstname       VARCHAR(50),
    cst_lastname        VARCHAR(50),
    cst_marital_status  VARCHAR(50),
    cst_gndr            VARCHAR(50),
    cst_create_date     DATE,
    dwh_create_date     DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS silver_crm_prd_info;
CREATE TABLE silver_crm_prd_info (
    prd_id           INT,
    cat_id           VARCHAR(50),
    prd_key          VARCHAR(50),
    prd_nm           VARCHAR(100),
    prd_cost         INT,
    prd_line         VARCHAR(50),
    prd_start_dt     DATE,
    prd_end_dt       DATE,
    dwh_create_date  DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS silver_crm_sales_details;
CREATE TABLE silver_crm_sales_details (
    sls_ord_num      VARCHAR(50),
    sls_prd_key      VARCHAR(50),
    sls_cust_id      INT,
    sls_order_dt     DATE,
    sls_ship_dt      DATE,
    sls_due_dt       DATE,
    sls_sales        INT,
    sls_quantity     INT,
    sls_price        INT,
    dwh_create_date  DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS silver_erp_loc_a101;
CREATE TABLE silver_erp_loc_a101 (
    cid              VARCHAR(50),
    cntry            VARCHAR(50),
    dwh_create_date  DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS silver_erp_cust_az12;
CREATE TABLE silver_erp_cust_az12 (
    cid              VARCHAR(50),
    bdate            DATE,
    gen              VARCHAR(50),
    dwh_create_date  DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS silver_erp_px_cat_g1v2;
CREATE TABLE silver_erp_px_cat_g1v2 (
    id               VARCHAR(50),
    cat              VARCHAR(50),
    subcat           VARCHAR(50),
    maintenance      VARCHAR(50),
    dwh_create_date  DATETIME DEFAULT CURRENT_TIMESTAMP
);
