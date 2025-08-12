## 📁 데이터셋 구성

### 1. `click_stream.csv`
유저의 웹/앱 내 행동 로그 데이터입니다.

- `session_id`: 세션 식별자  
- `event_name`: 발생한 이벤트 유형 (예: `ITEM_DETAIL`, `ADD_TO_CART`, `BOOKING` 등)  
- `event_time`: 이벤트 발생 시각
- `event_id`: 이벤트 고유 ID  
- `traffic_source`: 유입 경로 (예: 웹, 모바일 등)  
- `product_id`: 이벤트와 연관된 상품 ID (장바구니 or 구매에만 존재) 
- `quantity`: 수량
- `item_price`: 상품 단가  
- `payment_status`: 결제 상태  
- `search_keywords`: 검색 키워드  
- `promo_code`: 적용된 프로모션 코드  
- `promo_amount`: 프로모션 할인 금액  

---

### 2. `customers.csv`
고객의 인적 정보 및 가입 정보 데이터입니다.

- `customer_id`: 고객 식별자  
- `first_name`, `last_name`: 고객 이름  
- `username`, `email`: 계정 정보  
- `gender`: 성별  
- `birthdate`: 생년월일  
- `device_type`, `device_id`, `device_version`: 사용 디바이스 정보  
- `home_location`, `home_country`, `home_location_lat`, `home_location_long`: 고객 거주지 정보  
- `first_join_date`: 최초 가입일  

---

### 3. `products.csv`
상품 관련 메타데이터입니다.

- `id`: 상품 ID  
- `gender`: 타겟 성별  
- `masterCategory`, `subCategory`: 상품 대분류/소분류  
- `articleType`: 상품 유형 (예: 티셔츠, 바지 등)  
- `baseColour`: 대표 색상  
- `season`, `year`: 출시 시즌 및 연도  
- `usage`: 사용 목적 (예: 스포츠, 캐주얼 등)  
- `productDisplayName`: 상품명  

---

### 4. `transaction.csv`
상품 결제 및 주문 관련 정보입니다.

- `created_at`: 거래 발생 시각  
- `customer_id`, `session_id`, `booking_id`: 거래 식별 관련 ID  
- `payment_method`, `payment_status`: 결제 방식 및 상태  
- `promo_code`, `promo_amount`: 프로모션 정보  
- `shipment_fee`, `shipment_date_limit`, `shipment_location_lat`, `shipment_location_long`: 배송관련 정보
- `total_amount`: 총 결제 금액  
- `product_id`, `quantity`, `item_price`: 주문 상품 정보  
