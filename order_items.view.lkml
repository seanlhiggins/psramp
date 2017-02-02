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

# BRAND COMPARE
  filter:brand_select{
    suggest_dimension: products.brand
  }
  dimension: brand_comparitor{
  sql:
  CASE WHEN {% condition brand_select %} ${products.brand} {% endcondition %}
  THEN "(1) "||${products.brand}
  ELSE "(2) All Other Brands"
  END;;
  }

# AVERAGES
  measure: avg_total {
    type: average
    sql:  ;;
  }
#PS Ramp Added dims/meas
  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
  }

  measure: avg_sale_price {
    type: average
    value_format_name: usd
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

  measure: percent_total_count {
    type: percent_of_total
    direction: "column"
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
    sql: ${total_revenue_minus_returns} ;;
  }
#   measure: total_revenue_this_item {
#     type: sum
#     sql: ${sale_price} ;;
#     filters: {
#       field: brand_comparitor
#       value:
#     }
#   }
#   measure: total_revenue_this_brand {
#     type: sum
#     sql: ${sale_price} ;;
#     filters: {
#       field: brand_comparitor
#       value: "(2)%, (1)%"
#     }
#   }
#   measure: share_of_wallet_within_brand {
#     type: number
#     sql: 100.0*${total_revenue_this_item}/nullif(${total_revenue_this_brand},0) ;;
#   }
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

#COMPARITOR MEASURES
#   measure: total_sale_price_this_item{
#     type: sum
#     sql: ${sale_price};;
#     filters:{
#     field: products.item_name
# }
# }
#   measure: total_sale_price_this_brand{
#     type: sum
#     sql: ${sale_price};;
#     filters:{
#       field: products.brand


#       }
#     }
#   measure: share_of_wallet_within_brand{
#     type: number
#     description: "This item sales over all sales for same brand"
#     value_format: "#.00\%"
#     sql: 100.0 *  ${total_sale_price_this_item}*1.0 / nullif(${total_sale_price_this_brand},0)
#     ;;
#     }

#   measure: share_of_wallet_within_company{
#     description: "This item sales over all sales across website"
#     value_format: "#.00\%"
#     type: number
#     sql: 100.0 *  ${total_sale_price_this_item}*1.0 / nullif(${total_sale_price},0);;
# }
#   measure: share_of_wallet_brand_within_company{
#     description: "This brand''s sales over all sales across website"
#     value_format: "#.00\%"
#     type: number
#     sql: 100.0 *  ${total_sale_price_this_brand}*1.0 / nullif(${total_sale_price},0);;
# }
 measure: count {
    type: count
    drill_fields: [id, orders.id, inventory_items.id, products.brand, products.category]
  }
}
