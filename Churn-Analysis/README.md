# 세그먼트 및 코호트 기반 유저 이탈 분석 프로젝트

## 📊 프로젝트 개요  
가상의 커머스 플랫폼 데이터를 활용하여 기존 고객의 이탈 구조를 분석하고, 리텐션 개선을 위한 전략을 도출한 프로젝트입니다.  

가입 시점(cohort), 초기 재구매 행동, 누적 구매 횟수 등 유저의 행동 데이터를 기반으로 다양한 세그먼트를 정의하고,  
각 세그먼트의 리텐션 곡선과 이탈률을 비교해 이탈 위험군을 식별했습니다.  

단순 통계 요약을 넘어, 실질적인 실행 전략 수립에 필요한 정량적 인사이트 도출을 목표로 진행했습니다.

---

## 🧾 사용 데이터  
- **데이터 출처**: Kaggle - Fashion Campus  
- **기간**: 2021년 ~ 2022년 7월  
- **주요 테이블**: customers, transactions, products  
- **전처리 및 가공**:  
  - 연령대/가입월 파생  
  - 고객 요약 마트 생성 (첫 구매일, 총 구매 수, 재구매 여부 등)  
  - 리텐션/이탈 주차 계산을 위한 파생 컬럼 추가

---

## ❓ 문제 정의  
기존 고객의 주문 수가 감소하면서 전체 매출이 하락하는 상황에서, 다음과 같은 질문에 답하고자 했습니다:

- 성별, 연령, 디바이스 유형 등 속성별로 이탈률에 차이가 있을까?  
- 가입 시점(cohort)에 따라 리텐션 패턴은 어떻게 달라질까?  
- 첫 구매 이후 2주 이내 재구매 여부는 장기 리텐션과 어떤 관련이 있을까?  
- 누적 구매 횟수는 이탈률과 어떤 관계가 있을까?  

---

## 🔍 분석 과정 요약  

**1. 유저 요약 마트 생성**  
- 고객 속성 및 행동 기반 변수(총 구매 수, 2주 내 재구매 여부 등) 생성  
- 코호트 기준(가입월) 리텐션 주차 계산  

**2. 가설 기반 세그먼트 분석 및 리텐션 비교**  
- 가설별로 그룹을 나누어 주차별 리텐션 곡선 생성  
- 평균 이탈 주차, 평균 잔존 주차 계산  

**3. 통계적 유의성 검증**  
- t-test, 카이제곱 검정 등 활용  
- 재구매 여부, 누적 구매 횟수와 이탈 간 유의미한 상관관계 확인  

**4. 실행 전략 도출**  
- 위험군 타겟팅 기준 수립  
- 재구매 유도 캠페인 및 리워드 구조 설계 제안  

---

## 🛠️ 사용 기술 & 도구  
- **Python**: Pandas, Seaborn, Matplotlib  
- **SQL (BigQuery)**: 고객 행동 마트 및 파생 변수 생성  
- **Tableau Public**: 분석 결과 요약 및 리텐션 지표 시각화
