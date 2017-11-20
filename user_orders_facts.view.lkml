view: user_orders_facts {
  derived_table: {
    sql: SELECT orders.user_id as user_id
        , COUNT(DISTINCT orders.id) as lifetime_orders
        , SUM(order_items.sale_price) AS lifetime_revenue
        , MIN(NULLIF(orders.created_at,0)) as first_order
        , MAX(NULLIF(orders.created_at,0)) as latest_order
        , SUM(COALESCE(order_items.sale_price,0)) as lifetime_revenue
        , COUNT(DISTINCT EXTRACT(YEAR_MONTH FROM orders.created_at)) as number_of_distinct_months_with_orders
      FROM orders
      JOIN order_items
      ON orders.id = order_items.order_id
      WHERE {% condition order_ids %} orders.id {% endcondition %}
      GROUP BY user_id
       ;;
#       persist_for: "24 hours"
      # sql_trigger_value: SELECT CURRENT_DATE() ;;
      indexes: ["user_id"]
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  filter: order_ids {}

  dimension: user_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension: first_order {
    type: string
    sql: ${TABLE}.first_order ;;
  }

  dimension_group: latest_order {
    type: time
    timeframes: [date,week,month,year]
    sql: ${TABLE}.latest_order ;;
  }

  dimension: number_of_distinct_months_with_orders {
    type: number
    sql: ${TABLE}.number_of_distinct_months_with_orders ;;
  }

  measure: avg_lifetime_revenue_by_user {
    type: average
    sql: ${lifetime_revenue} ;;
  }

  set: detail {
    fields: [
      user_id,
      lifetime_orders,
      lifetime_revenue,
      first_order,
      latest_order_date,
      number_of_distinct_months_with_orders
    ]
  }
}
