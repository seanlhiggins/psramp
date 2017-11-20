view: events {
  sql_table_name: demo_db.events ;;

  dimension: id {
    # primary_key: yes
    type: number
    sql: ${TABLE}.id_2 ;;
  }

  dimension_group: created {
    type: time
    timeframes: [time, date, week, month]
    sql: ${TABLE}.created_at ;;
  }

  dimension: type_id {
    type: number
    sql: ${TABLE}.type ;;

  }

#This is a comment
  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: value {
    type: string
    sql: ${TABLE}.value ;;
  }

  measure: percent_cancelled {type: number sql: round(1.0*${cancelled_count}/${count},3);;
  value_format_name: percent_2
  html: <div style="float: left
    ; width:{{ value | times:100}}%
    ; background-color: rgba(42,50,86,{{ value | times:100 }})
    ; text-align:left
    ;border-radius: 25px"> <p style="margin-bottom: 0; margin-left: 4px;">{{ value | times:100 }}</p>
    </div>
    <div style="float: left
    ; width:{{ 1| minus:value|times:100}}%
    ; background-color: rgba(42,50,86,0.1)
    ; text-align:right
    ;border-radius: 25px"> <p style="margin-bottom: 0; margin-left: 0px; color:rgba(77,166,201,0.0" )>{{100.0 | minus:value }} </p>
    </div>
;;
}

  measure: count {
    type: count
    drill_fields: [id, users.last_name, users.first_name, users.id]
  }
}
