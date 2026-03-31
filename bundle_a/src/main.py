from bundle_a import displot_sns

df_in = spark.table("samples.nyctaxi.trips").select("trip_distance").limit(100)  # noqa: F821

displot_sns(df_in)
