view: customer_orders_detail {

  derived_table: {
    sql:SELECT orders.user_id as user_id,
    COUNT(*) as lifetime_orders,
    MIN(NULLIF(orders.created_at,0)) as first_order,
    MAX(NULLIF(orders.created_at,0)) as last_order,

    DATEDIFF('day',CURRENT_DATE,MAX(NULLIF(orders.created_at,0))) AS days_since_last_order,
    DATEDIFF('day',MIN(NULLIF(orders.created_at,0)),users.created_at) AS days_until_first_order,
    DATEDIFF('day',MAX(NULLIF(orders.created_at,0)),MIN(NULLIF(orders.created_at,0))) AS days_between_first_last_order,
    order_items.sale_price as sale_price,
    products.brand as brand,
    products.category as category,
    users.created_at as signup_date,
    DATEDIFF('day',NULLIF(users.created_at,0),CURRENT_DATE) AS days_since_signup,
    DATEDIFF('month',NULLIF(users.created_at,0),CURRENT_DATE) AS months_since_signup


      FROM orders
      LEFT JOIN users
      ON users.id=orders.user_id
      LEFT JOIN order_items
      ON orders.id=order_items.order_id
      LEFT JOIN inventory_items
      ON inventory_items.id=order_items.inventory_item_id
      LEFT JOIN products
      ON products.id=inventory_items.product_id
      GROUP BY user_id,users.created_at,8,9,10;;
    indexes: ["user_id"]
    sql_trigger_value: SELECT 0 ;;
    distribution_style: all
  }

  dimension:  days_since_signup{
    type: number
    sql: ${TABLE}.days_since_signup ;;
  }
  dimension:  months_since_signup{
    type: number
    sql: ${TABLE}.months_since_signup ;;
  }
  measure: average_days_since_signup {
    type: average
    sql: ${days_since_signup} ;;
  }
  measure: average_months_since_signup {
    type: average
    sql: ${months_since_signup} ;;
  }

  dimension: brand {
    sql: ${TABLE}.brand ;;
  }
  dimension: category {
    sql: ${TABLE}.category ;;
  }

  dimension: days_since_last_order {
    type: number
    sql: ${TABLE}.days_since_last_order ;;
  }
  dimension_group: first_order {
    type: time
    timeframes: [date,week,month,year]
    sql: ${TABLE}.first_order ;;
  }
  dimension_group: last_order {
    type: time
    timeframes: [date,week,month,year]
    sql: ${TABLE}.last_order ;;
  }
  dimension: user_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.user_id ;;
  }
  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }
  dimension: lifetime_orders_group {
    type: tier
    tiers: [1,2,3,5,9,10]
    style: integer
    sql: ${TABLE}.lifetime_orders ;;
  }
  dimension: sale_price {
    type: number
    value_format_name: usd
    sql: ${TABLE}.sale_price ;;
  }
  dimension: sale_price_groups {
    type: tier
    tiers: [50,100,150,200,250,300,350,400,450,500]
    sql: ${sale_price} ;;
  }
  dimension: is_active {
    type: yesno
    sql: ${TABLE}.days_since_last_order <90 ;;
  }
  measure: total_lifetime_revenue {
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
  }
  measure: average_days_since_last_order {
    type: average
    value_format_name: decimal_2
    sql: ${TABLE}.days_since_last_order ;;
  }

  dimension: is_repeat_customer {
    type: yesno
    sql: ${lifetime_orders}>1 ;;
  }
  dimension: total_revenue_tier {
    type: tier
    value_format_name: usd
    tiers: [4.99,19.99,49.99,99.99,499.99,999.99,1000]
    sql: ${TABLE}.sale_price ;;
  }
  measure: total_orders_amount {
    type: sum
    sql: ${lifetime_orders} ;;
  }
  measure: total_repeat_orders {
    type: sum
    filters: {
      field: is_repeat_customer
      value: "yes"
    }
    sql: ${lifetime_orders} ;;
  }
  measure: percent_of_total {
    type: percent_of_total
    value_format_name: decimal_2
    sql: ${lifetime_orders} ;;
  }
  measure: average_lifetime_orders {
    type: average
    sql: ${lifetime_orders} ;;
  }
}
