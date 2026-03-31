"""Hash featurization utilities for categorical columns."""

from pyspark.sql import DataFrame
from pyspark.sql import functions as F


def hash_featurize(
    df: DataFrame,
    input_col: str,
    num_features: int = 8,
    output_prefix: str = "hash_feature",
) -> DataFrame:
    """Apply feature hashing to a categorical column.

    Converts a categorical string column into ``num_features`` binary indicator
    columns using modular hashing.  Each row gets exactly one output column set
    to 1 (the bucket its value hashes into); the rest are 0.

    Args:
        df: Input PySpark DataFrame.
        input_col: Name of the categorical column to hash.
        num_features: Number of hash buckets (output features).
        output_prefix: Prefix for the generated column names.

    Returns:
        DataFrame with ``num_features`` additional integer columns appended.
    """
    hash_bucket = F.abs(F.hash(F.col(input_col))) % F.lit(num_features)
    return df.withColumns(
        {
            f"{output_prefix}_{i}": F.when(hash_bucket == i, 1).otherwise(0)
            for i in range(num_features)
        }
    )
