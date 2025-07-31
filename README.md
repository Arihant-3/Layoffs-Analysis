# 🧠 Layoffs Analysis

This project explores and visualizes global layoffs data using SQL for data cleaning and exploration, and Power BI for building an interactive dashboard.

📌 **Dataset:**  
[Layoffs Dataset on Kaggle](https://www.kaggle.com/datasets/swaptr/layoffs-2022) — contains records of major layoffs in the industry from 2020 to 2025.

---

## 📊 Key Objectives

- Perform **data cleaning** and formatting using SQL
- Conduct **exploratory data analysis (EDA)** to identify trends
- Build an **interactive dashboard** in Power BI to present insights

---

## 🛠 Tools Used

- **SQL (MySQL)** – For cleaning, formatting, and aggregating the data
- **Power BI** – For building a clean and interactive dashboard
- **Kaggle** – For sourcing the raw data

---

## 🧼 Data Cleaning Steps

- Removed duplicates using `ROW_NUMBER()`
- Standardized inconsistent entries (e.g., trimming, merging UAE variations)
- Converted fields to appropriate formats (`DATE`, `INT`, etc.)
- Handled missing values and empty strings
- Renamed and cleaned columns like `percentage_laid_off`, `funds_raised`

> All steps are documented in [`Data_Cleaning.sql`](./sql/Data_Cleaning.sql)

---

## 📈 Exploratory Data Analysis (EDA)

Key questions explored:

- Companies with the **highest total layoffs**
- **Industries** and **countries** most affected
- Year-over-year layoff trends (2020–2025)
- **Rolling totals** and month-wise patterns
- Startups with **100% layoffs** despite high funding

> All queries are available in [`EDA.sql`](./sql/EDA.sql)

---

## 📊 Power BI Dashboard

The final dashboard includes:

- KPIs: Total layoffs, companies affected, years in data
- Bar chart: Layoffs by year and industry
- Treemap: Companies with highest layoffs
- Line graph: Monthly layoffs trend (rolling total)
- Filters: Country, industry, year

📸 **[Screenshot Preview](./assets/dashboard_screenshot.png)**  
📁 **Power BI File:** [`Layoffs Dashboard`](./powerbi/layoffs_dashboard.pbix)

---

## ⚙️ How to Reproduce This Project

1. **Download the dataset** from [Kaggle - Layoffs Dataset](https://www.kaggle.com/datasets/swaptr/layoffs-2022)
2. **Create a table** named `layoffs` using the CSV file (import or manually create) in MySQL
3. Run the SQL scripts in this order:
   - `Data_Cleaning.sql`: Creates and populates a cleaned staging table called `layoffs_stagging2`
        - Includes intermediate steps via `layoffs_stagging` and `layoffs_stagging2` for best practices
   - `EDA.sql`: Performs analysis on the cleaned table

> The table `layoffs_stagging2` is the result of cleaning and formatting operations applied to the raw `layoffs` table. You don’t need to manually create it — the SQL file handles it step-by-step.

---

## 📁 Folder Structure
```
layoffs-analysis/
│
├── data/
│   ├── layoffs_cleaned.csv           # Cleaned/exported dataset (if applicable)
│   └── layoffs.sql
|
├── sql/
│   ├── Data_Cleaning.sql           # SQL queries for data cleaning
│   └── EDA.sql                     # SQL queries for exploration
│
├── powerbi/
│   └── layoffs_dashboard.pbix      # Power BI project file
│
├── assets/
│   ├── dashboard_screenshot.png      # Screenshot of your Power BI dashboard
│   └── schema_diagram.png            # Optional: ERD or structure image
│
├── README.md                         
└── LICENSE                          
```

---

## 📄 License

This project is licensed under the MIT License.  
Feel free to reuse the code with proper attribution.  
**Dataset credit:** [Kaggle - Layoffs Dataset by swaptr](https://www.kaggle.com/datasets/swaptr/layoffs-2022)

---

## 🙌 Acknowledgements

- [swaptr on Kaggle](https://www.kaggle.com/swaptr)
- SQL formatting inspired by Alex The Analyst
- Dashboarding with Power BI best practices

---

## 🚀 Future Improvements

- Build similar dashboards in Tableau and Streamlit
- Add ML layer to predict future layoffs (experimental)
- Automate data pull + refresh with APIs


