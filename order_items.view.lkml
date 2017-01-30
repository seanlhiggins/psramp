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

  measure: average_cost{
    type: average
    value_format_name: usd_0
    sql: ${inventory_items.cost} ;;
  }
  measure: total_cost {
    type: sum
    value_format_name: usd_0
    sql: ${inventory_items.cost} ;;
  }

  dimension: is_completed_sale {
    type: yesno
    sql: ${returned_date} IS NULL ;;
  }
  #MARGIN
  dimension: gross_margin {
    type: number
    value_format_name: usd_0
    sql: ${sale_price}-${inventory_items.cost} ;;
  }
  measure: total_gross_margin_amount {
    type: sum
    value_format_name: usd_0
    drill_fields: [products.brand,products.category]
    sql: ${gross_margin} ;;
  }
  measure: percent_total_gm {
    type: percent_of_total
    value_format_name: decimal_2
    sql: ${total_gross_margin_amount} ;;
  }
  measure: gross_margin_percent {
    type: number
    value_format_name: decimal_2
    sql: ${total_gross_margin_amount}/${total_revenue_minus_returns} ;;
  }
  measure: cumulative_total_sales {
    type: running_total
    sql: ${count} ;;
  }

  #Revenue
  measure: total_revenue_minus_returns {
    type: sum
    sql: ${sale_price};;
    value_format_name: usd
    filters: {
      field: is_completed_sale
      value: "yes"
    }
  }
  measure: total_revenue {
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
  }
  measure: cumulative_total_revenue {
    type: running_total
    sql: ${sale_price} ;;
  }
  measure: total_revenue_percent {
    type: percent_of_total
    value_format_name: decimal_4
    sql: ${total_revenue} ;;
  }
  measure: total_returned_items {
    type: sum
    sql: ${id} WHERE is_completed_sale ='no' ;;
  }

  #RETURNS
  measure: item_return_rate {
    type: number
    value_format_name: decimal_2
    sql: 1.0*(${count}/NULLIF(${total_returned_items},0) ;;
  }

  measure: total_customers_returning_items {
    type: count_distinct
    sql: ${users.id} WHERE ${returned_date} IS NOT NULL  ;;
  }

  measure: total_customers {
    type: count_distinct
    sql:  ${users.id} ;;
  }

  measure: percent_of_users_returned {
    type: number
    value_format_name: decimal_2
    sql: 1.0*(NULLIF(${total_customers_returning_items},0)/NULLIF(${total_customers})) ;;
  }

  measure: average_spend_per_customer {
    type: number
    value_format_name: decimal_2
    sql: 1.0*(NULLIF(${total_sale_price},0)/(NULLIF(${total_customers},0))) ;;
  }

  measure: count {
    type: count
    drill_fields: [id, orders.id, inventory_items.id, products.brand, products.category]
  }
}
