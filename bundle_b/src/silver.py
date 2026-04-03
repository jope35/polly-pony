"""Silver layer: cleaned and feature-engineered taxi trip data."""

from bundle_b.featurize import hash_featurize
from pyspark import pipelines as dp
from pyspark.sql import functions as F


@dp.table(
    name="silver_nyctaxi_trips",
    comment="Cleaned taxi trips with hash-featurized pickup_zip",
)
def silver_nyctaxi_trips():
    bronze = spark.readStream.table("bronze_nyctaxi_trips")  # noqa: F821

    cleaned = (
        bronze.filter(F.col("pickup_zip").isNotNull())
        .filter(F.col("dropoff_zip").isNotNull())
        .filter(F.col("fare_amount") > 0)
        .filter(F.col("trip_distance") > 0)
    )

    return hash_featurize(cleaned, input_col="pickup_zip", num_features=8)
