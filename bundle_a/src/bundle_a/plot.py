import seaborn as sns
from pyspark.sql import DataFrame


def displot_sns(df_in: DataFrame) -> None:
    """Plot a seaborn displot of trip_distance from a Spark or pandas DataFrame."""
    if isinstance(df_in, DataFrame):
        table = df_in.toPandas()
    else:
        table = df_in
    sns.displot(table, x="trip_distance")
