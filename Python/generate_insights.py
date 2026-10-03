print("GENERATE INSIGHTS FILE STARTED")

import json
from pathlib import Path

from analysis import (
    get_revenue_performance,
    get_customer_intelligence,
    get_product_performance,
    get_regional_performance,
)


def generate_business_insights():

    print("Loading revenue data...")
    revenue_df = get_revenue_performance()

    print("Loading customer data...")
    customer_df = get_customer_intelligence()

    print("Loading product data...")
    product_df = get_product_performance()

    print("Loading regional data...")
    regional_df = get_regional_performance()

    # -------------------------
    # Revenue insights
    # -------------------------

    revenue_df = revenue_df.sort_values(
        ["Year", "Month"]
    ).copy()

    highest_revenue_month = revenue_df.loc[
        revenue_df["Total_Revenue"].idxmax()
    ]

    highest_profit_month = revenue_df.loc[
        revenue_df["Total_Profit"].idxmax()
    ]

    # -------------------------
    # Customer insights
    # -------------------------

    top_customer = customer_df.loc[
        customer_df["Total_Spending"].idxmax()
    ]

    average_customer_spend = (
        customer_df["Total_Spending"].mean()
    )

    # -------------------------
    # Product insights
    # -------------------------

    top_product_revenue = product_df.loc[
        product_df["Revenue"].idxmax()
    ]

    top_product_profit = product_df.loc[
        product_df["Profit"].idxmax()
    ]

    lowest_product_profit = product_df.loc[
        product_df["Profit"].idxmin()
    ]

    # Category analysis
    category_summary = (
        product_df
        .groupby("Category", dropna=False)
        .agg(
            Revenue=("Revenue", "sum"),
            Profit=("Profit", "sum")
        )
        .reset_index()
    )

    best_category = category_summary.loc[
        category_summary["Revenue"].idxmax()
    ]

    # -------------------------
    # Regional insights
    # -------------------------

    best_region_revenue = regional_df.loc[
        regional_df["Revenue"].idxmax()
    ]

    best_region_profit = regional_df.loc[
        regional_df["Profit"].idxmax()
    ]

    # -------------------------
    # Print business summary
    # -------------------------

    print("\n======================================")
    print("     BUSINESS INTELLIGENCE SUMMARY")
    print("======================================")

    print("\n--- Revenue Insights ---")

    print(
        f"Highest Revenue Month: "
        f"{highest_revenue_month['Month_Name']} "
        f"{highest_revenue_month['Year']} "
        f"(${highest_revenue_month['Total_Revenue']:,.2f})"
    )

    print(
        f"Highest Profit Month: "
        f"{highest_profit_month['Month_Name']} "
        f"{highest_profit_month['Year']} "
        f"(${highest_profit_month['Total_Profit']:,.2f})"
    )

    print("\n--- Customer Insights ---")

    print(
        f"Highest Value Customer: "
        f"{top_customer['Customer_Name']} "
        f"(${top_customer['Total_Spending']:,.2f})"
    )

    print(
        f"Average Customer Spending: "
        f"${average_customer_spend:,.2f}"
    )

    print("\n--- Product Insights ---")

    print(
        f"Highest Revenue Product: "
        f"{top_product_revenue['Product_Name']} "
        f"(${top_product_revenue['Revenue']:,.2f})"
    )

    print(
        f"Highest Profit Product: "
        f"{top_product_profit['Product_Name']} "
        f"(${top_product_profit['Profit']:,.2f})"
    )

    print(
        f"Lowest Profit Product: "
        f"{lowest_product_profit['Product_Name']} "
        f"(${lowest_product_profit['Profit']:,.2f})"
    )

    print(
        f"Highest Revenue Category: "
        f"{best_category['Category']} "
        f"(${best_category['Revenue']:,.2f})"
    )

    print("\n--- Regional Insights ---")

    print(
        f"Highest Revenue Region: "
        f"{best_region_revenue['Region']} "
        f"(${best_region_revenue['Revenue']:,.2f})"
    )

    print(
        f"Highest Profit Region: "
        f"{best_region_profit['Region']} "
        f"(${best_region_profit['Profit']:,.2f})"
    )

    # -------------------------
    # Save insights to JSON
    # -------------------------

    insights = {
        "revenue": {
            "highest_revenue_month": (
                f"{highest_revenue_month['Month_Name']} "
                f"{int(highest_revenue_month['Year'])}"
            ),
            "highest_revenue": float(
                highest_revenue_month["Total_Revenue"]
            ),
            "highest_profit_month": (
                f"{highest_profit_month['Month_Name']} "
                f"{int(highest_profit_month['Year'])}"
            ),
            "highest_profit": float(
                highest_profit_month["Total_Profit"]
            ),
        },

        "customers": {
            "highest_value_customer": top_customer["Customer_Name"],
            "highest_customer_spending": float(
                top_customer["Total_Spending"]
            ),
            "average_customer_spending": float(
                average_customer_spend
            ),
        },

        "products": {
            "highest_revenue_product": top_product_revenue["Product_Name"],
            "highest_revenue_product_revenue": float(
                top_product_revenue["Revenue"]
            ),
            "highest_profit_product": top_product_profit["Product_Name"],
            "highest_profit_product_profit": float(
                top_product_profit["Profit"]
            ),
            "lowest_profit_product": lowest_product_profit["Product_Name"],
            "lowest_profit_product_profit": float(
                lowest_product_profit["Profit"]
            ),
            "highest_revenue_category": best_category["Category"],
            "highest_revenue_category_revenue": float(
                best_category["Revenue"]
            ),
        },

        "regions": {
            "highest_revenue_region": best_region_revenue["Region"],
            "highest_revenue": float(
                best_region_revenue["Revenue"]
            ),
            "highest_profit_region": best_region_profit["Region"],
            "highest_profit": float(
                best_region_profit["Profit"]
            ),
        },
    }

    project_root = Path(__file__).resolve().parent.parent
    output_folder = project_root / "output"

    output_folder.mkdir(exist_ok=True)

    output_file = output_folder / "business_insights.json"

    with open(output_file, "w", encoding="utf-8") as file:
        json.dump(insights, file, indent=4)

    print(f"\nInsights saved to: {output_file}")
    
    print("\n======================================")
    print("        ANALYSIS COMPLETE")
    print("======================================")


if __name__ == "__main__":
    print("RUNNING BUSINESS INSIGHT GENERATOR")
    generate_business_insights()