-- Gold layer: aggregated metrics by hash feature bucket

CREATE OR REFRESH MATERIALIZED VIEW gold_nyctaxi_pickup_metrics
COMMENT "Aggregated trip metrics per hash feature bucket"
AS SELECT
  hash_feature_0,
  hash_feature_1,
  hash_feature_2,
  hash_feature_3,
  hash_feature_4,
  hash_feature_5,
  hash_feature_6,
  hash_feature_7,
  COUNT(*)                    AS trip_count,
  AVG(fare_amount)            AS avg_fare,
  AVG(trip_distance)          AS avg_distance,
  SUM(fare_amount)            AS total_fare,
  MIN(tpep_pickup_datetime)   AS first_pickup,
  MAX(tpep_pickup_datetime)   AS last_pickup
FROM silver_nyctaxi_trips
GROUP BY
  hash_feature_0,
  hash_feature_1,
  hash_feature_2,
  hash_feature_3,
  hash_feature_4,
  hash_feature_5,
  hash_feature_6,
  hash_feature_7
