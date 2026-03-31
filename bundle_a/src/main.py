from bundle_a import plot

df_in = spark.table("samples.nyctaxi.trips").select("trip_distance").limit(100)

plot(df_in)
