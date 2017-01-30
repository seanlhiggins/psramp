view: order_items {
  sql_table_name: public.order_items ;;

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
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

#PS Ramp Added dims/meas
  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
  }

  measure: avg_sale_price {
    type: average
    sql: ${sale_price} ;;
  }

  measure: sum_total_sales {
    type: sum
    sql: ${id} ;;
  }
  dimension: gross_margin {
    type: number
    value_format_name: decimal_2
    sql: ${sale_price}-${inventory_items.cost} ;;
  }

  measure: total_gross_margin {
    type: sum
    sql: ${gross_margin} ;;
  }

  measure: average_cost{
    type: average
    sql: ${inventory_items.cost} ;;
  }

  measure: total_cost {
    type: sum
    sql: ${inventory_items.cost} ;;
  }

  dimension: is_completed_sale {
    type: yesno
    sql: IF(${returned_date} IS NULL,'yes','no') ;;
  }

  measure: total_revenue {
    type: sum
    sql: ${sale_price} WHERE is_completed_sale = 'yes' ;;
  }

  measure: gross_margin_percent {
    type: number
    value_format_name: decimal_2
    sql: 100.0*(${total_gross_margin}/NULLIF(${total_revenue},0)) ;;
  }
  measure: cumulative_total_sales {
    type: running_total
    sql: ${count} ;;
  }

  measure: cumulative_total_revenue {
    type: running_total
    sql: ${sale_price} ;;
  }

  measure: total_returned_items {
    type: sum
    sql: ${id} WHERE is_completed_sale ='no' ;;
  }

  measure: item_return_rate {
    type: number
    value_format_name: decimal_2
    sql: 100.0*(${count}/NULLIF(${total_returned_items},0) ;;
  }

  measure: total_customers_returning_items {
    type: count_distinct
    sql: SELECT  ${users.id} WHERE ${returned_date} IS NOT NULL  ;;
  }

  measure: total_customers {
    type: sum
    sql: SELECT COUNT(DISTINCT ${users.id}) FROM users;;
  }
  measure: percent_of_users_returned {
    type: number
    value_format_name: decimal_2
    sql: 100.0*(NULLIF(${total_customers_returning_items},0)/NULLIF(${total_customers})) ;;
  }
  measure: average_spend_per_customer {
    type: number
    value_format_name: decimal_2
    sql: 100.0*(${total_sale_price}/${total_customers}) ;;
  }
  measure: count {
    type: count
    drill_fields: [id, orders.id, inventory_items.id]
  }
}
