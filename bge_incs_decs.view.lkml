view: bge_incs_decs {
  derived_table: {
    sql: SELECT * FROM bge_incs_decs
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: inc_qty {
    type: number
    sql: ${TABLE}.inc_qty ;;
  }

  dimension: inc_price {
    type: number
    sql: ${TABLE}.inc_price ;;
  }

  dimension: dec_qty {
    type: number
    sql: ${TABLE}.dec_qty ;;
  }

  dimension: dec_price {
    type: number
    sql: ${TABLE}.dec_price ;;
  }

  set: detail {
    fields: [inc_qty, inc_price, dec_qty, dec_price]
  }
}
