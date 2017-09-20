view: user_facts_view {
  derived_table: {
    sql: SELECT
        orders.user_id  AS `orders.user_id`,
        DATE(MIN(NULLIF(orders.created_at,0))) AS `orders.first_order_date`,
        DATE(MAX(NULLIF(orders.created_at,0))) AS `orders.last_order_date`,
        COALESCE(SUM(order_items.sale_price ), 0) AS `order_items.lifetime_revenue`
      FROM demo_db.order_items  AS order_items
      LEFT JOIN demo_db.orders  AS orders ON order_items.order_id = orders.id

      GROUP BY 1
      ORDER BY DATE(MIN(NULLIF(orders.created_at,0))) DESC

       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: orders_user_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.`orders.user_id` ;;
  }

  dimension: orders_first_order_date {
    type: date
    sql: ${TABLE}.`orders.first_order_date` ;;
  }

  dimension: orders_last_order_date {
    type: date
    sql: ${TABLE}.`orders.last_order_date` ;;
  }

  dimension: order_items_lifetime_revenue {
    type: number
    sql: ${TABLE}.`order_items.lifetime_revenue` ;;
  }
  measure: average_lifetime_revenue_all_users {
    sql: ${order_items_lifetime_revenue} ;;
    type: average
  }

  set: detail {
    fields: [orders_user_id, orders_first_order_date, orders_last_order_date, order_items_lifetime_revenue]
  }
}
