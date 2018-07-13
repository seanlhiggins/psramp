explore: users_localised {}
view: users_localised {
  view_label: "users_label"
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    label: "age_label"
    description: "age_description"
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: gender {
    label: "gender_label"
    type: string
    sql: case
            when '{{ _user_attributes['locale'] }}' = 'en' then ${TABLE}.gender
            when '{{ _user_attributes['locale'] }}' = 'es_AR' then
              case when ${TABLE}.gender = 'Male' then 'Hombre'
                   when ${TABLE}.gender = 'Female' then 'Mujer'
                    else null
                    end
            else null
            end;;
  }

  dimension: first_name {
    label: "first_name_label"
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: date {
    label: "date_label"
    type: date
    sql: ${TABLE}.created_at ;;
    group_label: "date_group_label"
  }

  dimension: week {
    label: "week_label"
    type: date_week
    sql: ${TABLE}.created_at ;;
    group_label: "date_group_label"
  }

  dimension: month {
    label: "month_label"
    type: date_month
    sql: ${TABLE}.created_at ;;
    group_label: "date_group_label"
  }

  measure: amount {
    label: "amount_label"
    type: count
    html:
      {% if _user_attributes['locale'] == "es_AR" %}
        ARS $ {{value}}
      {% elsif _user_attributes['locale'] == "ga_IE" %}
        € {{value}}
        {% else %}
        $ {{value}}
      {% endif %}
        ;;
  }
}
