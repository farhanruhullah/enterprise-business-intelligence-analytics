print("REGIONAL ANALYSIS FILE STARTED")

import pandas as pd
from analysis import get_regional_performance


def analyze_regions():
    df = get_regional_performance().copy()

    # Overall metrics
    total_revenue = df["Revenue"].sum()
    total_profit = df["Profit"].sum()
    total_orders = df["Orders"].sum()

    # Best / worst regions
    best_revenue_region = df.loc[df["Revenue"].idxmax()]
    best_profit_region = df.loc[df["Profit"].idxmax()]
    lowest_revenue_region = df.loc[df["Revenue"].idxmin()]

    # Profit margin
    df["Profit_Margin_%"] = (
        df["Profit"] / df["Revenue"].replace(0, pd.NA)
    ) * 100

    # Sort by revenue
    regional_summary = df.sort_values(
        "Revenue",
        ascending=False
    )

    print("\n--- Regional Analysis ---")

    print(f"Total Regional Revenue: ${total_revenue:,.2f}")
    print(f"Total Regional Profit: ${total_profit:,.2f}")
    print(f"Total Orders: {total_orders:,.0f}")

    print(
        f"\nHighest Revenue Region: "
        f"{best_revenue_region['Region']} "
        f"(${best_revenue_region['Revenue']:,.2f})"
    )

    print(
        f"Highest Profit Region: "
        f"{best_profit_region['Region']} "
        f"(${best_profit_region['Profit']:,.2f})"
    )

    print(
        f"Lowest Revenue Region: "
        f"{lowest_revenue_region['Region']} "
        f"(${lowest_revenue_region['Revenue']:,.2f})"
    )

    print("\n--- Regional Performance ---")

    print(
        regional_summary[
            [
                "Region",
                "Country",
                "Revenue",
                "Profit",
                "Orders",
                "Profit_Margin_%"
            ]
        ]
    )

    return regional_summary


if __name__ == "__main__":
    analyze_regions()

if __name__ == "__main__":
    print("RUNNING REGIONAL ANALYSIS")
    analyze_regions()