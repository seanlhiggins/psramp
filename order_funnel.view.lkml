view: order_funnel {
  derived_table: {
    distribution_style: all
    sortkeys: ["id"]
    sql_trigger_value: SELECT current_date ;;
    sql: SELECT orders.id,orders.user_id,orders.created_at,
    COUNT(b.id) AS subsequent_orders,
    min(b.created_at) AS second_order_date,
    min(b.id) AS second_order_id,
    row_number() over(partition by orders.user_id order by orders.created_at) as sequence
    FROM orders
    LEFT JOIN orders b
    ON orders.user_id=b.user_id
    AND orders.created_at < b.created_at
    GROUP BY 1,2,3
    ;;
  }
  dimension: sequence {
    type: number
    sql: ${TABLE}.sequence ;;
  }
  dimension:  first_order_id{
    type: number
    primary_key: yes
    sql: ${TABLE}.id ;;
  }

  dimension: subsequent_orders {
    type: number
    sql: ${TABLE}.subsequent_orders ;;
  }
  dimension:  second_order_id{
    type: number
    sql: ${TABLE}.second_order_id ;;
  }

  dimension_group:  second_order_date_raw{

    sql: ${TABLE}.second_order_date ;;
  }

  dimension: has_2nd_order {
    type: yesno
    sql: ${TABLE}.subsequent_orders>0 ;;
  }

  dimension:  days_between_1st_2nd{
    type: number
    sql: DATEDIFF('day',nullif(${TABLE}.created_at,0),nullif(${TABLE}.second_order_date,0)) ;;
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
    value_format: "#.#\%"
    sql: 100.0*${count_orders_60_days}/(${orders.count},0) ;;
  }

  measure: average_days_between_orders {
    type: average
    sql: ${days_between_1st_2nd} ;;
  }

  measure: count_repeats {
    type: count
    filters: {
      field: has_2nd_order
      value: "yes"
    }
    }
   measure: count_non_repeats {
    type: count
    filters: {
      field: has_2nd_order
      value: "no"
    }
    }
    measure: repeat_differential_rate {
      type: number
      value_format_name: percent_2
      sql: ${count}/nullif(${count_non_repeats},0) ;;
    }

  measure: count {
    type: count
  }

}
