---
name: sql-optimization
Description: "SQL query optimization and database best practices. Use when writing queries, optimizing performance, designing schemas, or troubleshooting slow queries."
metadata:
  {
    "openclaw":
      {
        "emoji": "🗄️",
        "requires": {},
        "install": [],
      },
  }
---

# SQL Optimization Skill

SQL query optimization and database best practices for PostgreSQL, MySQL, and SQLite.

## When to Use

- Writing SQL queries
- Optimizing query performance
- Designing database schemas
- Troubleshooting slow queries
- Index optimization

## Query Optimization

### SELECT Optimization

```sql
-- Bad: SELECT *
SELECT * FROM users WHERE created_at > '2024-01-01';

-- Good: Select only needed columns
SELECT id, name, email FROM users WHERE created_at > '2024-01-01';

-- Good: Use LIMIT for pagination
SELECT id, name FROM users ORDER BY created_at DESC LIMIT 20 OFFSET 0;
```

### Index Usage

```sql
-- Check if query uses index
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'test@example.com';

-- Create index for frequent lookups
CREATE INDEX idx_users_email ON users(email);

-- Composite index for multi-column queries
CREATE INDEX idx_users_name_created ON users(name, created_at);

-- Partial index for filtered queries
CREATE INDEX idx_active_users ON users(email) WHERE status = 'active';
```

### JOIN Optimization

```sql
-- Bad: Implicit join
SELECT * FROM users, orders WHERE users.id = orders.user_id;

-- Good: Explicit JOIN with proper conditions
SELECT u.id, u.name, o.total
FROM users u
INNER JOIN orders o ON u.id = o.user_id
WHERE o.created_at > '2024-01-01';

-- Good: Use appropriate JOIN type
SELECT u.name, COUNT(o.id) as order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;
```

### Aggregation Optimization

```sql
-- Bad: Filtering after aggregation
SELECT user_id, COUNT(*) as count
FROM orders
GROUP BY user_id
HAVING count > 5;

-- Good: Use WHERE before aggregation when possible
SELECT user_id, COUNT(*) as count
FROM orders
WHERE created_at > '2024-01-01'
GROUP BY user_id;

-- Good: Index for aggregation queries
CREATE INDEX idx_orders_user_created ON orders(user_id, created_at);
```

## Schema Design

### Normalization

```sql
-- First Normal Form (1NF): Atomic values
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

-- Separate table for multiple values
CREATE TABLE user_phones (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    phone_number VARCHAR(20),
    phone_type VARCHAR(20)
);

-- Third Normal Form (3NF): No transitive dependencies
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    category_id INTEGER REFERENCES categories(id),
    price DECIMAL(10,2)
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255)
);
```

### Data Types

```sql
-- Use appropriate types
CREATE TABLE optimized_table (
    id SERIAL PRIMARY KEY,
    
    -- Use INTEGER for IDs
    user_id INTEGER NOT NULL,
    
    -- Use VARCHAR with length
    email VARCHAR(255),
    
    -- Use TEXT for long content
    description TEXT,
    
    -- Use DECIMAL for money
    price DECIMAL(10,2),
    
    -- Use BOOLEAN for flags
    is_active BOOLEAN DEFAULT true,
    
    -- Use TIMESTAMP WITH TIME ZONE
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Use ENUM for fixed values (PostgreSQL)
    status VARCHAR(20) CHECK (status IN ('active', 'inactive', 'pending'))
);
```

### Constraints

```sql
-- Primary key
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Foreign key with cascade
ALTER TABLE orders
ADD CONSTRAINT fk_orders_user
FOREIGN KEY (user_id) REFERENCES users(id)
ON DELETE CASCADE;

-- Unique constraints
ALTER TABLE users
ADD CONSTRAINT uk_users_email
UNIQUE (email);

-- Check constraints
ALTER TABLE products
ADD CONSTRAINT chk_product_price
CHECK (price >= 0);
```

## Performance Monitoring

### Finding Slow Queries

```sql
-- PostgreSQL: Find slow queries
SELECT query, calls, mean_time, total_time
FROM pg_stat_statements
ORDER BY mean_time DESC
LIMIT 10;

-- MySQL: Enable slow query log
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 2;
```

### Analyzing Query Plans

```sql
-- PostgreSQL EXPLAIN
EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT u.name, COUNT(o.id)
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id;

-- Look for:
-- - Seq Scan (should use Index Scan)
-- - High cost values
-- - Large row counts
```

### Index Maintenance

```sql
-- Find unused indexes (PostgreSQL)
SELECT schemaname, tablename, indexname, idx_scan
FROM pg_stat_user_indexes
WHERE idx_scan = 0;

-- Find missing indexes
SELECT schemaname, tablename, attname as column,
       n_tup_read, n_tup_fetch
FROM pg_stats
WHERE schemaname = 'public'
ORDER BY n_tup_read DESC;

-- Reindex for performance
REINDEX INDEX idx_users_email;
```

## Common Patterns

### Pagination

```sql
-- Offset pagination (simple but slow for large offsets)
SELECT * FROM users
ORDER BY created_at DESC
LIMIT 20 OFFSET 1000;

-- Cursor-based pagination (faster)
SELECT * FROM users
WHERE created_at < '2024-01-01'
ORDER BY created_at DESC
LIMIT 20;
```

### Soft Deletes

```sql
-- Add deleted_at column
ALTER TABLE users ADD COLUMN deleted_at TIMESTAMP;

-- Query excluding soft-deleted
SELECT * FROM users WHERE deleted_at IS NULL;

-- Soft delete
UPDATE users SET deleted_at = NOW() WHERE id = 1;

-- Restore
UPDATE users SET deleted_at = NULL WHERE id = 1;
```

### Full-Text Search

```sql
-- PostgreSQL full-text search
ALTER TABLE articles ADD COLUMN search_vector tsvector;

UPDATE articles
SET search_vector = to_tsvector('english', title || ' ' || content);

CREATE INDEX idx_articles_search ON articles USING GIN(search_vector);

-- Search
SELECT * FROM articles
WHERE search_vector @@ to_tsquery('english', 'database & optimization');
```

## Best Practices

1. **Use indexes wisely**: Don't over-index
2. **Avoid N+1 queries**: Use JOINs
3. **Use transactions**: For data consistency
4. **Parameterize queries**: Prevent SQL injection
5. **Monitor performance**: Use EXPLAIN ANALYZE
6. **Regular maintenance**: Vacuum, analyze
7. **Connection pooling**: Reuse connections
8. **Read replicas**: For read-heavy workloads
