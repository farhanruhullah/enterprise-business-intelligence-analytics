import pandas as pd
from database_connection import get_engine


def get_revenue_performance():
    engine = get_engine()

    query = """
    SELECT *
    FROM vw_Revenue_Performance
    ORDER BY Year, Month;
    """

    return pd.read_sql(query, engine)


def get_customer_intelligence():
    engine = get_engine()

    query = """
    SELECT TOP 5 *
    FROM vw_Customer_Intelligence;
    """

    return pd.read_sql(query, engine)


def get_product_performance():
    engine = get_engine()

    query = """
    SELECT *
    FROM vw_Product_Performance;
    """

    return pd.read_sql(query, engine)


def get_regional_performance():
    engine = get_engine()

    query = """
    SELECT *
    FROM vw_Regional_Performance;
    """

    return pd.read_sql(query, engine)


if __name__ == "__main__":

    print("\n--- Revenue Performance ---")
    print(get_revenue_performance().head())

    print("\n--- Customer Intelligence ---")
    print(get_customer_intelligence().head())

    print("\n--- Product Performance ---")
    print(get_product_performance().head())

    print("\n--- Regional Performance ---")
    print(get_regional_performance().head())

if __name__ == "__main__":
    print("\n--- Customer Intelligence ---")
    df = get_customer_intelligence()
    print(df)