SELECT * from creditcard

-- checking basic statistics
SELECT min (amount) as min_amount, max (amount) as max_amount, avg(amount) as avg_amount
from creditcard

SELECT min(time) as min_time, max(time) as max_time
from creditcard;

SELECT DISTINCT class
FROM creditcard;

-- Check Class Distribution (Fraudulent vs Non-Fraudulent Transactions)
SELECT class, count(*) as count_tsn
from creditcard
group by class;

-- Analyze Transactions by Hour or Day
SELECT floor(time / 3600) as hour, count(*) as count_tsn
from creditcard
group by hour
order by count_tsn DESC;

SELECT FLOOR(time / 3600) AS hour, AVG(amount) AS avg_amount
FROM creditcard
GROUP BY hour
ORDER BY hour;

-- Fraudulent Transaction per hour
SELECT floor(time / 3600) as hour, COUNT(*) as fraud_count
from creditcard
where class = 1
Group by hour
GROUP by hour;

-- Average Transaction Amount by Time of Day
SELECT FLOOR(time / 3600) AS hour, AVG(amount) AS avg_amount
FROM creditcard
WHERE class = 0
GROUP BY hour;

-- Analyze distribution of amount
SELECT amount, count(*) as count_tsn
from creditcard
GROUP by amount
order by count_tsn desc;

--Identify Anomalies in Amounts
WITH
    -- Step 1: Calculate the mean (average)
    avg_amount AS (
        SELECT AVG(amount) AS mean_amount
        FROM creditcard
    ),
    
    -- Step 2: Calculate the standard deviation manually
    stddev_amount AS (
        SELECT SQRT(AVG((amount - mean_amount) * (amount - mean_amount))) AS stddev_amount
        FROM creditcard, avg_amount
    )

-- Step 3: Apply the 3-sigma rule (mean + 3 * stddev)
SELECT amount
FROM creditcard
WHERE amount > (
    SELECT mean_amount + 3 * stddev_amount
    FROM avg_amount, stddev_amount
);

--Find Common Transaction Amounts for Fraudulent Transactions
SELECT amount, COUNT(*) as fraud_count
from creditcard
where class = 1
group by amount
order by fraud_count DESC;

-- Compare Fraudulent vs Non-Fraudulent Transactions:
SELECT class, AVG(amount) AS avg_amount, COUNT(*) AS num_tsn
FROM creditcard
GROUP BY class;

-- Differences Between Fraudulent and Non-Fraudulent
SELECT class, AVG(v1) AS avg_v1, AVG(v2) AS avg_v2, AVG(v3) AS avg_v3
FROM creditcard
GROUP BY class;

-- Correlation Between v1 to v2, v3
SELECT AVG(amount) AS avg_amount, AVG(v1) AS avg_v1, AVG(v2) AS avg_v2, AVG(v3) AS avg_v3
FROM creditcard;

--Group Transactions Based on Certain Features
SELECT AVG(v1) AS avg_v1, AVG(v2) AS avg_v2, AVG(v3) AS avg_v3, COUNT(*) AS transaction_count
FROM creditcard
GROUP BY FLOOR(v1), FLOOR(v2), FLOOR(v3)
ORDER BY transaction_count DESC;

--Fraud Percentage Over Time
SELECT FLOOR(time / 3600) AS hour,
       SUM(CASE WHEN class = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS fraud_percentage
FROM creditcard
GROUP BY hour
ORDER BY hour;

--Compare Fraudulent vs. Non-Fraudulent Transactions
SELECT class, AVG(amount) as avg_amount, count(*) as num_tsn
from creditcard
GROUP by class;

SELECT 'V1' as feature, avg(v1) as avg_value, count (*)
FROM creditcard
GROUP by class
union ALL
SELECT 'V2', AVG(v2), count(*)
from creditcard
group by class;

SELECT 'V2' as feature, avg(v2) as avg_value, count (*)
FROM creditcard
GROUP by class
union ALL
SELECT 'V3', AVG(v3), count(*)
from creditcard
group by class;

SELECT 'V3' as feature, avg(v3) as avg_value, count (*)
FROM creditcard
GROUP by class
union ALL
SELECT 'V4', AVG(v4), count(*)
from creditcard
group by class;

SELECT v1, AVG(amount) as avg_count, count (*) as count_fraud
from creditcard
group by v1
having AVG(amount) > (SELECT AVG (amount) from creditcard);