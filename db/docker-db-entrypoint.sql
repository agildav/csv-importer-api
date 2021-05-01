DROP DATABASE IF EXISTS csv_importer_development;
DROP DATABASE IF EXISTS csv_importer_test;

CREATE DATABASE csv_importer_development;
CREATE DATABASE csv_importer_test;

GRANT ALL PRIVILEGES ON DATABASE csv_importer_development TO postgres;
GRANT ALL PRIVILEGES ON DATABASE csv_importer_test TO postgres;

CREATE ROLE admin WITH LOGIN ENCRYPTED PASSWORD 'postgres';
