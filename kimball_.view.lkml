view: kimball {
  sql_table_name: looker_scratch.eav ;;

  dimension: delivery_period {
    type: string
    sql: ${TABLE}.delivery_period ;;
  }

  dimension: price {
    type: number
    sql: ${TABLE}.price ;;
  }

  dimension: quantity {
    type: number
    sql: ${TABLE}.quantity ;;
  }

  dimension: volume {
    type: number
    sql: ${TABLE}.volume ;;
  }

  measure: total_price {
    sql: ${price} ;;
    type: sum
  }

  measure: total_quantity {
    sql: ${quantity} ;;
    type:sum
  }

  measure: total_volume {
    sql: ${volume};;
    type:sum
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
