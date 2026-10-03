import pandas as pd
from analysis import get_customer_intelligence


def analyze_customers():
    df = get_customer_intelligence()

    # Sort customers by spending
    df = df.sort_values("Total_Spending", ascending=False).copy()

    # Top 10 customers
    top_10_customers = df.head(10)

    # Overall metrics
    total_customers = df["Customer_ID"].nunique()
    average_spending = df["Total_Spending"].mean()
    median_spending = df["Total_Spending"].median()
    total_customer_spending = df["Total_Spending"].sum()

    # Top customer
    top_customer = df.iloc[0]

    # Top 10 spending concentration
    top_10_spending = top_10_customers["Total_Spending"].sum()

    top_10_contribution = (
        top_10_spending / total_customer_spending
    ) * 100

    print("\n--- Customer Analysis ---")

    print(f"Total Customers: {total_customers:,}")
    print(f"Average Customer Spending: ${average_spending:,.2f}")
    print(f"Median Customer Spending: ${median_spending:,.2f}")

    print(
        f"\nHighest Value Customer: "
        f"{top_customer['Customer_Name']}"
    )

    print(
        f"Customer Spending: "
        f"${top_customer['Total_Spending']:,.2f}"
    )

    print(
        f"\nTop 10 Customers Contribution: "
        f"{top_10_contribution:.2f}%"
    )

    print("\n--- Top 10 Customers ---")

    print(
        top_10_customers[
            [
                "Customer_Name",
                "Customer_Type",
                "Total_Spending",
                "Total_Profit"
            ]
        ]
    )

    return df


if __name__ == "__main__":
    analyze_customers()