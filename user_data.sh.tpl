#!/bin/bash

echo "🚀 Bastion 초기화 시작: PostgreSQL client 설치 중..."
sudo dnf update -y
sudo dnf install -y postgresql15

echo "🔐 RDS 접속을 위한 환경변수 설정"
export PGPASSWORD="${db_password}"

echo "📡 RDS에 연결하여 pgvector 확장 및 테이블 생성 시작..."

psql -h ${rds_endpoint} -U ${db_username} -d ${db_name} <<EOF
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE IF NOT EXISTS embeddings (
    id TEXT PRIMARY KEY,
    service_id TEXT NOT NULL,
    source TEXT,
    content TEXT NOT NULL,
    embedding VECTOR(1536) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
EOF

echo "📌 Cosine 유사도 기반 벡터 검색 인덱스를 생성합니다..."
psql -h ${rds_endpoint} -U ${db_username} -d ${db_name} <<EOF
CREATE INDEX IF NOT EXISTS embeddings_embedding_idx 
ON embeddings 
USING ivfflat (embedding vector_cosine_ops) 
WITH (lists = 100);
EOF

if [ $? -eq 0 ]; then
  echo "✅ 인덱스 생성 완료!"
else
  echo "❌ 인덱스 생성 실패"
  exit 1
fi