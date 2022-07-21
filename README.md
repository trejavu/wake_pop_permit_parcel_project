# Wake County Population, Permits, and Parcels

The goal of this project is the use Wake County building permit and parcel data and US Census data to look at the relationship between population growth and
land use allocation and buiding activity over the previous decade.

The resulting dashboard can be viewed with the following link:

[Google Data Studio Dashboard](https://datastudio.google.com/reporting/03d34a26-3d7c-480c-b3b8-73dc1291b180)

## Ingestion
The ingestion process uses Docker to manage an airflow instance to gather data using the Wake County ArcGIS API, tp save the data in parquet format, to upload
the data into Google Cloud Storage and to create an external table using those files in BigQuery.

## Warehousing and Transformation
The data transformation process is managed by dbt cloud does the following: 
- sums the total number of building permits by date, jurisdiction, type, and status
- sums the total number of parcels and units (for multifamily land use a single parcel will have multiple units) by jurisdiction, land use, and building type data
- creates dimension tables for the municipalities providing geolocation data and annual populaiton data
