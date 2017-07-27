view: ip_sample {
  sql_table_name: looker_scratch.ip_sample ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: last_sign_in_ip {
    type: string
    sql: LEFT(${TABLE}.last_sign_in_ip,10) ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
