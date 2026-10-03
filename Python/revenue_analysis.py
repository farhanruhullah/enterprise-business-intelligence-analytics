import pandas as pd
from analysis import get_revenue_performance


def analyze_revenue():
    df = get_revenue_performance()

    # Sort correctly by year and month
    df = df.sort_values(["Year", "Month"]).copy()

    # Calculate month-over-month revenue growth
    df["Revenue_Growth_%"] = (
        df["Total_Revenue"]
        .pct_change() * 100
    )

    # Find highest revenue month
    highest_revenue_row = df.loc[
        df["Total_Revenue"].idxmax()
    ]

    # Find lowest revenue month
    lowest_revenue_row = df.loc[
        df["Total_Revenue"].idxmin()
    ]

    # Find highest profit month
    highest_profit_row = df.loc[
        df["Total_Profit"].idxmax()
    ]

    # Overall statistics
    total_revenue = df["Total_Revenue"].sum()
    total_profit = df["Total_Profit"].sum()
    average_monthly_revenue = df["Total_Revenue"].mean()

    print("\n--- Revenue Analysis ---")

    print(f"Total Revenue: ${total_revenue:,.2f}")
    print(f"Total Profit: ${total_profit:,.2f}")
    print(
        f"Average Monthly Revenue: "
        f"${average_monthly_revenue:,.2f}"
    )

    print(
        f"\nHighest Revenue Month: "
        f"{highest_revenue_row['Month_Name']} "
        f"{highest_revenue_row['Year']} "
        f"(${highest_revenue_row['Total_Revenue']:,.2f})"
    )

    print(
        f"Lowest Revenue Month: "
        f"{lowest_revenue_row['Month_Name']} "
        f"{lowest_revenue_row['Year']} "
        f"(${lowest_revenue_row['Total_Revenue']:,.2f})"
    )

    print(
        f"Highest Profit Month: "
        f"{highest_profit_row['Month_Name']} "
        f"{highest_profit_row['Year']} "
        f"(${highest_profit_row['Total_Profit']:,.2f})"
    )

    print("\n--- Monthly Growth Preview ---")

    print(
        df[
            [
                "Year",
                "Month_Name",
                "Total_Revenue",
                "Revenue_Growth_%"
            ]
        ].head(10)
    )

    return df


if __name__ == "__main__":
    analyze_revenue()