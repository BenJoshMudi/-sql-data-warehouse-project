# Data Dictionary for Gold Layer 

## Overview
The Gold Layer is the business-level data representation, structured to support analytical use consists of **dimension tables** and **fact tables** for business metrics.

---

### 1. **gold.dim_customers**
- **Purpose:** Store customer details enriched with demographic and geographic data.
- **Columns:**

| **Column Name**      | **Data Type**            | **Description**                                                                                 |
|----------------------|--------------------------|-------------------------------------------------------------------------------------------------|
| Customer Key         | INT                      | Surrrogate key uiquely identifying each customer record in the dimension table.                 |
| customer_id          | INT                      | Unique numerical identifier assigned to each customer.                                          |
| customer_number      | NVARCHAR(50)             | Alphanumeric identifier representing the customer, used for tracking and referencing.           |
| first_name           | NVARCHAR(50)             | The Customer's first name, as recorded in the system'                                           |          
| last_name            | NVARCHAR(50)             | The Customer's last name or family name.                                                        |
| country              | NVARCHAR(50)             | The Country of residence for the customer (e.g., 'Australia')                                   |
| marital_status       | NVARCHAR (50)            | The marital status of the customer (e.g. 'Married', 'single').                                  |
| gender               | NVARCHAR(50)             | The gender of the customer e.g., 'Male', 'Female', 'n/a').                                      |
| birthddate           | DATE                     | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-26)                   |
| create_date          | DATE                     | The date and time when the customer record was created in the system                            |

---
  
 
      
 
