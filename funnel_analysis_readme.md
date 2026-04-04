# E-commerce Funnel Analysis

This project analyses user behaviour across an e-commerce funnel to identify drop-offs, measure conversion rates, and evaluate revenue performance.
The goal is to optimise the customer journey and improve overall business performance.

**Funnel Stages**

The funnel consists of the following stages:
1. Page View
2. Add to Cart
3. Checkout
4. Payment Info
5. Purchase

**Data Preparation**
- Imported raw event data into the analysis environment
- Cleaned the dataset by:
       - Handling missing/null values
        - Standardising funnel stage labels
- Ensured accurate user tracking across stages

Data set used: user_events.csv

**Business Questions**
1. How can we define the e-commerce sales funnel and determine the number of users at each stage?
2. What are the conversion rates between each stage of the funnel?
3. How does funnel performance vary across different traffic sources?
4. What is the average time taken by users at each stage of the funnel?
5. What are the key revenue metrics such as total revenue, AOV, and revenue per visitor?

**Key Findings**

**1. Funnel Distribution**

<img width="629" height="49" alt="{3FBBAD54-0412-4A27-9A7D-8120D85A11B8}" src="https://github.com/user-attachments/assets/15a65de2-22b4-4059-b63e-98456189392f" />

_Significant drop-off observed at the top of the funnel._

**2. Conversion Rates**

<img width="1035" height="52" alt="{39EA667D-E877-40D0-B0DE-94C3A7316FBE}" src="https://github.com/user-attachments/assets/472c700a-fbe4-4104-a0da-be1b278bc97d" />
<img width="312" height="43" alt="{FF54793C-77AD-4C5E-BF5C-1D3B6090B60A}" src="https://github.com/user-attachments/assets/08256e4f-7c8d-4d00-81b2-e7e43cbde9c2" />

_Strong performance in lower funnel stages._

**3. Traffic Source Analysis**

<img width="923" height="106" alt="{36DB723E-D8AB-444D-8F9B-598720C0667D}" src="https://github.com/user-attachments/assets/4ea154bd-df51-4cba-85ca-a4ae68f0b2a1" />
<img width="710" height="105" alt="{CF31C560-ABA3-4091-AA0E-7C9D9DC8D38D}" src="https://github.com/user-attachments/assets/93223828-ce8a-4861-ba7c-363b93b26efc" />

_Email shows the highest efficiency, while social traffic underperforms._

**4. Time-BAsed Analysis**

<img width="1031" height="50" alt="{746BAF66-5F3B-4619-803D-5E89F0DBAE24}" src="https://github.com/user-attachments/assets/3b06b562-e27d-442a-8824-d836e8b68a2e" />
  
_Users spend the most time at the decision stage (top of funnel)._

**5. Revenue Analysis**

<img width="697" height="53" alt="{678D433C-E3FB-400F-9D10-F38D57114715}" src="https://github.com/user-attachments/assets/f73830eb-5c35-44b3-a95e-ca8452d8d731" />
   
_No repeat purchases observed (1 order per buyer)._

**Key Insights**
- Major drop-off occurs at the top of the funnel
- Strong conversion in checkout and payment stages
- Email traffic is the most efficient channel
- Users spend the most time before adding to cart
- Revenue is limited by low conversion and lack of repeat purchases

# Final Recommendations
**1. UX & Website Optimisation**
- Improve Top Funnel Conversion (Page View → Add to Cart)

Page View → Add to Cart conversion is only 31.06%, and users spend the highest time (11.15 mins) at this stage. This indicates hesitation in product selection or weak product page experience.

Action: Optimise product pages with better images, clear descriptions, customer reviews, and strong call-to-action (CTA). Run A/B tests on layout and messaging.

- Do Not Disrupt Checkout & Payment Flow
Conversion rates from Checkout → Purchase (~80–90%) are very high, and time to complete purchase is low (3.03 mins). This indicates a smooth and efficient payment process.

Action: Avoid major changes to checkout or payment flow. Focus only on minor UX improvements if needed.

**2. Marketing Strategy**
- Reduce Dependence on Low-Converting Social Traffic
Social media drives a significant portion of traffic but has the lowest conversion efficiency across funnel stages.

Action: Optimise targeting and creatives for social campaigns. Shift focus from awareness to retargeting high-intent users.

- Double Down on High-Converting Channels (Email & Organic)
Email shows the highest conversion efficiency, while organic drives the highest volume of users.

Action: 
      - Increase investment in email marketing campaigns 
      - Capture more leads via pop-ups, sign-ups, and offers

**3. Revenue & Growth Strategy**
- Improve Revenue per Visitor
Revenue per visitor is only 17.6, primarily due to low top-funnel conversion.

Action: Focus on improving early-stage conversion (Page View → Add to Cart), which will directly increase revenue.

**4. Funnel Efficiency Optimisation**
- Reduce Decision Time at Product Stage
Users spend the most time before adding items to cart, indicating decision friction.

Action:
      - Add urgency (limited stock, offers)
      - Highlight bestsellers and recommendations
      - Simplify product comparison
