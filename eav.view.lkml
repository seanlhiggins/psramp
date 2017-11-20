view: eav{
  sql_table_name: looker_scratch.kimball ;;

  dimension: delivery_period {
    type: string
    sql: ${TABLE}.delivery_period ;;
  }

  dimension: metric {
    type: string
    sql: ${TABLE}.metric ;;
  }

  dimension: value {
    type: number
    sql: ${TABLE}.value ;;
  }
  measure: total {
    sql: ${value} ;;

    type: sum
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
