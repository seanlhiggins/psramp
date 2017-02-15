view: users {
  sql_table_name: demo_db.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: is_under_30 {
    type: yesno
    sql: ${age} < 30 ;;
  }


  dimension: age_tier {
    type: tier
    sql: ${age} ;;
    tiers: [18,35,50]
    style: integer
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
    type: time
    timeframes: [time, date, week, month, day_of_week]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: 1_week_ago {
    type: string
    sql:  DATE_DIFF('day',CURRENT_DATE()-7,CURRENT_DATE());;
  }

  dimension: is_more_than_one_week_ago {
    type: yesno
    sql: ${1_week_ago} < 7 ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: zip {
    type: number
    sql: ${TABLE}.zip ;;
  }

  measure: count_users_under_30 {
    type: count
    filters: {
      field: age
      value: "<30"
    }
    drill_fields: [detail*]
  }
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      last_name,
      first_name,
      events.count,
      orders.count,
      user_data.count
    ]
  }
}
