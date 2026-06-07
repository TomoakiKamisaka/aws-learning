# AWS 1-Year Learning Roadmap

AWS 認定資格の取得と、実務で使えるインフラスキルの習得を目的とした1年間の学習記録です。

## 目標

- SAA保有を前提に、1年で Associate / Professional / Specialty を計7-8本取得
- 試験のためだけでなく、実装力・現場力を伴った状態を目指す
- Terraform / CloudFormation の両方で IaC を扱えるようになる

## 学習ロードマップ

| Phase   | 期間        | 内容                                 | 取得目標資格      |
| ------- | ----------- | ------------------------------------ | ----------------- |
| Phase 0 | Month 1-2   | 手を動かす土台（VPC / TCP/IP / IaC） | —                 |
| Phase 1 | Month 3-5   | Associate 2本                        | DVA-C02 / SOA-C03 |
| Phase 2 | Month 6-7   | DevOps Pro                           | DOP-C02           |
| Phase 3 | Month 8-9   | Architect Pro                        | SAP-C02           |
| Phase 4 | Month 10-12 | Specialty 2本                        | SCS-C02 / ANS-C01 |

## ディレクトリ構成

\`\`\`
aws-learning/
├── month01/
│ ├── terraform-vpc-v2/ # Terraform で書いた VPC + IGW + Subnet + NAT GW + SG
│ └── cloudformation-vpc/ # CloudFormation で同じ構成を YAML で記述
└── README.md
\`\`\`

## Month 1 で構築したVPC構成

\`\`\`
VPC: 10.0.0.0/16
├── Internet Gateway
├── Public Subnet AZ-a (10.0.1.0/24)
├── Public Subnet AZ-c (10.0.2.0/24)
├── Private Subnet AZ-a (10.0.10.0/24)
├── Private Subnet AZ-c (10.0.11.0/24)
├── NAT Gateway (Public Subnet AZ-a に配置)
├── Public ルートテーブル → IGW
├── Private ルートテーブル → NAT Gateway
├── Public Security Group (SSH 許可)
└── Private Security Group (Public SG からの SSH のみ許可)
\`\`\`

## 学んだこと（Month 1）

### ネットワーク基礎

- TCP/IP の通信フロー、OSI参照モデルの理解
- CIDR、サブネットマスク、プライベートIPアドレス範囲
- NAT、DNS、TLS/HTTPSのハンドシェイク仕組み

### AWS VPC構築

- VPC・サブネット・IGW・NAT Gateway・ルートテーブル・SG の役割と関係
- Public/Private サブネットの本質（ルートテーブル次第）
- セキュリティグループの粒度設計（役割ごとに1つ）

### IaC

- CLI で手作業 → CloudFormation → Terraform の段階的習得
- Terraform の依存関係解決と並列処理
- CloudFormation との違い（記法、状態管理、ロールバック）

## 使用ツール

- AWS CLI v2
- Terraform 1.15.5
- Visual Studio Code
- macOS
