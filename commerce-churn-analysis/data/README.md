## 📁 데이터셋 구성

### 1. `customers.csv`
고객의 인적 정보 및 가입 정보 데이터입니다.

- `customer_id`: 고객 식별자  
- `first_name`, `last_name`: 고객 이름  
- `username`, `email`: 계정 정보  
- `gender`: 성별  
- `birthdate`: 생년월일  
- `device_type`, `device_id`, `device_version`: 사용 디바이스 정보  
- `home_location`, `home_country`, `home_location_lat`, `home_location_long`: 고객 거주지 정보  
- `first_join_date`: 최초 가입일  


### 2. `transaction.csv`
상품 결제 및 주문 관련 정보입니다.

- `created_at`: 거래 발생 시각  
- `customer_id`, `session_id`, `booking_id`: 거래 식별 관련 ID  
- `payment_method`, `payment_status`: 결제 방식 및 상태  
- `promo_code`, `promo_amount`: 프로모션 정보  
- `shipment_fee`, `shipment_date_limit`, `shipment_location_lat`, `shipment_location_long`: 배송관련 정보
- `total_amount`: 총 결제 금액  
- `product_id`, `quantity`, `item_price`: 주문 상품 정보  
