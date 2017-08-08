view: orders {
  sql_table_name: demo_db.orders ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.created_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }


#################### MIN AND MAX ORDER DATES####################

  measure: first_order_date {
    type: date
    sql:  MIN(NULLIF(orders.created_at,0));;
}
  measure: last_order_date {
    type: date
    sql:  MAX(NULLIF(orders.created_at,0));;
  }

  measure: conditional_count {
    type: count_distinct
    sql: {% if orders.status._in_query %}
      ${status}
      {% elsif orders.user_id._in_query %}
      ${user_id}
      {% else %}
      NULL
      {% endif %};;
  }


  measure: count {
    type: count
    drill_fields: [id, users.last_name, users.first_name, users.id, order_items.count]
  }
}
