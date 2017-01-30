view: customer_orders_detail {

  derived_table: {
    sql:SELECT orders.user_id as user_id,
    COUNT(*) as lifetime_orders,
    MIN(NULLIF(orders.created_at,0)) as first_order,
    MAX(NULLIF(orders.created_at,0)) as last_order,
    DATEDIFF('day',CURRENT_DATE,MAX(NULLIF(orders.created_at,0))) AS days_since_last_order,
    DATEDIFF('day',MIN(NULLIF(orders.created_at,0)),users.created_at) AS days_until_first_order,
    DATEDIFF('day',MAX(NULLIF(orders.created_at,0)),MIN(NULLIF(orders.created_at,0))) AS days_between_first_last_order,
    COUNT(DISTINCT MONTH(NULLIF(orders.created_at,0))) AS distinct_months_orders,
    order_items.sale_price as revenue

      FROM users
      JOIN orders
      ON users.id=orders.user_id
      JOIN order_items
      ON orders.id=order_items.order_id
      GROUP BY user_id;;
    indexes: ["user_id"]
    sql_trigger_value: SELECT 0 ;;
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
    sql: ${TABLE}.revenue ;;
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
    sql: ${TABLE}.revenue ;;
  }
  measure: total_orders_amount {
    type: sum
    sql: ${lifetime_orders} ;;
  }
  measure: average_lifetime_orders {
    type: average
    sql: ${lifetime_orders} ;;
  }
  # # You can specify the table name if it's different from the view name:
  # sql_table_name: my_schema_name.tester ;;
  #
  # # Define your dimensions and measures here, like this:
  # dimension: user_id {
  #   description: "Unique ID for each user that has ordered"
  #   type: number
  #   sql: ${TABLE}.user_id ;;
  # }
  #
  # dimension: lifetime_orders {
  #   description: "The total number of orders for each user"
  #   type: number
  #   sql: ${TABLE}.lifetime_orders ;;
  # }
  #
  # dimension_group: most_recent_purchase {
  #   description: "The date when each user last ordered"
  #   type: time
  #   timeframes: [date, week, month, year]
  #   sql: ${TABLE}.most_recent_purchase_at ;;
  # }
  #
  # measure: total_lifetime_orders {
  #   description: "Use this for counting lifetime orders across many users"
  #   type: sum
  #   sql: ${lifetime_orders} ;;
  # }
}

# view: customer_orders_detail {
#   # Or, you could make this view a derived table, like this:
#   derived_table: {
#     sql: SELECT
#         user_id as user_id
#         , COUNT(*) as lifetime_orders
#         , MAX(orders.created_at) as most_recent_purchase_at
#       FROM orders
#       GROUP BY user_id
#       ;;
#   }
#
#   # Define your dimensions and measures here, like this:
#   dimension: user_id {
#     description: "Unique ID for each user that has ordered"
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
