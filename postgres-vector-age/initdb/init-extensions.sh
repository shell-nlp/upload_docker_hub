#!/bin/bash

# 确保脚本在出错时立即退出
set -e

# 使用 psql 执行 SQL 命令
# "$POSTGRES_USER" 和 "$POSTGRES_DB" 是从 docker-compose 继承的环境变量
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL

    --- 1. 启用 知识图谱 (Apache AGE) ---
    CREATE EXTENSION IF NOT EXISTS age;
    LOAD 'age';
    -- 设置默认的图搜索路径
    SET search_path = ag_catalog, "\$user", public;
    
    --- 2. 启用 向量存储 (pgvector) ---
    CREATE EXTENSION IF NOT EXISTS vector;

    --- 3. 启用 全文检索辅助 (pg_trgm) ---
    -- PostgreSQL 内置了全文检索 (tsvector/tsquery)
    -- pg_trgm 提供了额外的模糊查询和相似度搜索 (例如: %, LIKE)
    CREATE EXTENSION IF NOT EXISTS pg_trgm;

EOSQL

echo "✅ 成功启用 AGE, pgvector, 和 pg_trgm 扩展。"