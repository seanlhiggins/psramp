view: order_items {
  sql_table_name: demo_db.order_items ;;

#####################################################
###################### Dimensions ###################
#####################################################

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;

  }

  dimension_group: returned {
    type: time
    timeframes: [time, date, week, minute30, month]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }


#####################################################
###################### Measures######################
#####################################################

  measure: lifetime_revenue {
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
  }


  measure: average_spend_per_user {
    type: number
    value_format_name: usd
    sql: 1.0 * ${lifetime_revenue} / NULLIF(${users.count},0) ;;
  }

  measure: count {
    type: count
    label: "Metrics"
#     html: Count:{{value}} and Avg Spend: {{ average_spend_per_user._value }} ;;
    drill_fields: [id, inventory_items.id, orders.id]
  }
}
