print("PRODUCT ANALYSIS FILE STARTED")

import pandas as pd
from analysis import get_product_performance


def analyze_products():
    df = get_product_performance()

    # Remove rows where revenue is zero to avoid division problems
    df = df.copy()
    df["Profit_Margin_%"] = (
        df["Profit"] / df["Revenue"].replace(0, pd.NA)
    ) * 100

    # Sort by revenue and profit
    top_revenue_products = (
        df.sort_values("Revenue", ascending=False)
        .head(10)
    )

    bottom_profit_products = (
        df.sort_values("Profit", ascending=True)
        .head(10)
    )

    # Overall metrics
    total_revenue = df["Revenue"].sum()
    total_profit = df["Profit"].sum()
    total_units = df["Units_Sold"].sum()
    total_products = df["Product_Name"].nunique()

    # Best product by revenue
    best_revenue_product = df.loc[df["Revenue"].idxmax()]

    # Best product by profit
    best_profit_product = df.loc[df["Profit"].idxmax()]

    # Worst product by profit
    worst_profit_product = df.loc[df["Profit"].idxmin()]

    # Category summary
    category_summary = (
        df.groupby("Category", dropna=False)
        .agg(
            Revenue=("Revenue", "sum"),
            Profit=("Profit", "sum"),
            Units_Sold=("Units_Sold", "sum")
        )
        .reset_index()
    )

    category_summary["Profit_Margin_%"] = (
        category_summary["Profit"]
        / category_summary["Revenue"].replace(0, pd.NA)
    ) * 100

    category_summary = category_summary.sort_values(
        "Revenue",
        ascending=False
    )

    print("\n--- Product Analysis ---")

    print(f"Total Product Revenue: ${total_revenue:,.2f}")
    print(f"Total Product Profit: ${total_profit:,.2f}")
    print(f"Total Units Sold: {total_units:,.0f}")
    print(f"Total Products: {total_products:,}")

    print(
        f"\nHighest Revenue Product: "
        f"{best_revenue_product['Product_Name']} "
        f"(${best_revenue_product['Revenue']:,.2f})"
    )

    print(
        f"Highest Profit Product: "
        f"{best_profit_product['Product_Name']} "
        f"(${best_profit_product['Profit']:,.2f})"
    )

    print(
        f"Lowest Profit Product: "
        f"{worst_profit_product['Product_Name']} "
        f"(${worst_profit_product['Profit']:,.2f})"
    )

    print("\n--- Top 10 Products by Revenue ---")

    print(
        top_revenue_products[
            [
                "Product_Name",
                "Category",
                "Revenue",
                "Profit",
                "Profit_Margin_%"
            ]
        ]
    )

    print("\n--- Bottom 10 Products by Profit ---")

    print(
        bottom_profit_products[
            [
                "Product_Name",
                "Category",
                "Revenue",
                "Profit",
                "Profit_Margin_%"
            ]
        ]
    )

    print("\n--- Category Performance ---")

    print(category_summary)

    return df, category_summary


if __name__ == "__main__":
    analyze_products()
    
if __name__ == "__main__":
    print("RUNNING PRODUCT ANALYSIS")
    analyze_products()