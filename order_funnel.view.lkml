view: order_funnel {
  derived_table: {
    distribution_style: all
    sortkeys: ["id"]
    sql_trigger_value: SELECT 0 ;;
    sql: SELECT a.id,
    COUNT(b.id) AS subsequent_orders,
    min(b.created_at) AS second_order_date,
    min(b.id) AS second_order_id
    FROM orders a
    JOIN orders b
    ON a.id=b.id
    AND a.created_at < b.created_at
    GROUP BY 1
    ;;
  }

  dimension:  first_order_id{
    type: number
    primary_key: yes
    sql: ${TABLE}.id ;;
  }

  dimension:  second_order_id{
    type: number
    sql: ${TABLE}.second_order_id ;;
  }

  dimension_group:  second_order_date{
    type: time
    sql: ${TABLE}.second_order_date ;;
    timeframes: [date, month, year]
  }

  dimension: has_2nd_order {
    type: yesno
    sql: ${second_order_id}>0 ;;
  }

  dimension:  days_between_1st_2nd{
    type: number
    sql: DATEDIFF('day',${orders.created_date},${TABLE}.second_order_date) ;;
  }
  dimension: 2nd_order_in_60_days {
    type: yesno
    sql: ${days_between_1st_2nd}<=60 ;;
  }

  measure: count_orders_60_days {
    type: count
    filters: {
      field: 2nd_order_in_60_days
      value: "yes"
    }
  }
  measure: 60_day_repeat_purchase_rate {
    type: number
    value_format_name: decimal_2
    sql: 1.0*${count_orders_60_days}/(nullif({orders.count},0)) ;;
  }

  measure: average_days_between_orders {
    type: average
    sql: ${days_between_1st_2nd} ;;
  }


}
