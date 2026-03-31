import seaborn as sns
from pyspark.sql import DataFrame


def displot_sns(df_in):
    if isinstance(df_in, DataFrame):
        table = df_in.toPandas()
    sns.displot(table, x="trip_distance")
