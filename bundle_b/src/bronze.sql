-- Bronze layer: raw ingestion from samples.nyctaxi.trips

CREATE OR REFRESH STREAMING TABLE bronze_nyctaxi_trips
COMMENT "Raw NYC taxi trip data from the samples catalog"
AS SELECT
  *
FROM STREAM(samples.nyctaxi.trips)
