print("DATABASE CONNECTION FILE STARTED")

import os
import pyodbc

from pathlib import Path
from sqlalchemy import create_engine
from urllib.parse import quote_plus
from dotenv import load_dotenv


# --------------------------------
# Load .env from project root
# --------------------------------

BASE_DIR = Path(__file__).resolve().parent.parent
ENV_FILE = BASE_DIR / ".env"

load_dotenv(ENV_FILE)


SERVER = os.getenv("DB_SERVER")
DATABASE = os.getenv("DB_NAME")
DRIVER = os.getenv("DB_DRIVER")


# --------------------------------
# Validate configuration
# --------------------------------

if not SERVER:
    raise ValueError("DB_SERVER was not found in .env")

if not DATABASE:
    raise ValueError("DB_NAME was not found in .env")

if not DRIVER:
    raise ValueError("DB_DRIVER was not found in .env")


def get_connection():

    connection_string = (
        f"DRIVER={{{DRIVER}}};"
        f"SERVER={SERVER};"
        f"DATABASE={DATABASE};"
        "Trusted_Connection=yes;"
        "TrustServerCertificate=yes;"
    )

    return pyodbc.connect(connection_string)


def get_engine():

    connection_string = quote_plus(
        f"DRIVER={{{DRIVER}}};"
        f"SERVER={SERVER};"
        f"DATABASE={DATABASE};"
        "Trusted_Connection=yes;"
        "TrustServerCertificate=yes;"
    )

    return create_engine(
        f"mssql+pyodbc:///?odbc_connect={connection_string}"
    )


if __name__ == "__main__":

    print("SERVER:", SERVER)
    print("DATABASE:", DATABASE)
    print("DRIVER:", DRIVER)
    print("Installed ODBC Drivers:", pyodbc.drivers())

    print("\nTesting database connection...")

    connection = get_connection()

    print("Database connection successful.")

    connection.close()