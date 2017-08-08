view: users  {
    sql_table_name: demo_db.users;;

#####################################################
###################### Dimensions ###################
#####################################################

  dimension: id {
#     primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: pseudo_primary {
  type: string
  sql: CONCAT(${TABLE}.city) ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: age_tier {
    type: tier
    tiers: [18,35,50,85]
    sql:  ${age};;
    style: integer
  }

  dimension: is_user_under_30 {
    type: yesno
    sql: ${age} < 30 ;;
  }


  dimension: city {
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }
  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension_group: created {
    type: time
    timeframes: [time, date, week, month, day_of_week, day_of_week_index,second]
    sql: ${TABLE}.created_at ;;
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

  dimension: signup_diff {
    type: number
    sql: DATEDIFF(NOW(),${created_date}) ;;
    hidden: yes
  }
  dimension: is_signup_diff_less_30 {
    type: yesno
    sql: ${signup_diff} < 30 ;;
    hidden: yes
  }
#####################################################
###################### Measures #####################
#####################################################

  measure: count_users_signup_last_30_days {
    type: count
    filters: {
      field: is_signup_diff_less_30
      value: "yes"
    }
  }

  measure: count_users_under_30 {
    type: count
    filters: {
      field: is_user_under_30
      value: "yes"
    }
    drill_fields: [detail*]
  }

  measure: count_distinct_ages {
    type: count_distinct
    sql:  ${age};;
  }

  measure: utilization{
    type: number
    value_format: "0.00%"
    sql: CASE WHEN ${count_users_under_30}=0 THEN 0 ELSE ${num_orders_active_measure}/${slot_maximum_actual_measure} end;;
    html:
    {% if value >= 0.75 %}
    <p style = "color: darkgreen; background-color: lightgreen;"><a href="https://localhost:9999/looks/56"> {{ rendered_value }}</a></p>
    {% elsif value < 0.6 %}
    <p style = "color: darkred; background-color: lightcoral;"><a href="https://localhost:9999/looks/56"> {{ rendered_value }}</a></p>
    {% else %}
    <p style = "color: darkgoldenrod; background-color: lightgoldenrodyellow;"><a href="https://localhost:9999/looks/56"> {{ rendered_value }}</a></p>
    {% endif %};;

      drill_fields: [created_date, slot_maximum_actual_measure, num_orders_active_measure, utilization]
      link: {
        label: "Utilization Explore"
        url: "https://localhost:9999/looks/56"
      }
    }


    measure: num_orders_active_measure {
      type: sum
#value_format: "0.00"
      drill_fields: [created_date, slot_maximum_actual_measure, num_orders_active_measure]

      sql: ${age};;
      link: {
        label: "Daily Explore"
        url: "https://localhost:9999/looks/57"
      }
    }

    measure: slot_maximum_actual_measure {
      type: sum
      sql: ${age} +1  ;;
      drill_fields: [created_date, slot_maximum_actual_measure, num_orders_active_measure]

      link: {
        label: "Daily Explore"
        url: "https://localhost:9999/looks/57"
      }
    }

  measure: count {
    type: count
    drill_fields: [detail*]
  }
  measure: count_distinct_users_age {
    type: count_distinct
    sql:  ${age};;
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
