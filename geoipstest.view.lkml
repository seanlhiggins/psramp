view: geoipstest {
  sql_table_name: public.geoipstest ;;

  dimension: accuracy_radius {
    type: number
    sql: ${TABLE}.accuracy_radius ;;
  }

  dimension: geoname_id {
    type: number
    sql: ${TABLE}.geoname_id ;;
  }

  dimension: is_anonymous_proxy {
    type: yesno
    sql: ${TABLE}.is_anonymous_proxy ;;
  }

  dimension: is_satellite_provider {
    type: yesno
    sql: ${TABLE}.is_satellite_provider ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }
  dimension: network {
    type: string
    sql: LEFT(split_part(${TABLE}.network,'/',1),10) ;;
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: registered_country_geoname_id {
    type: number
    sql: ${TABLE}.registered_country_geoname_id ;;
  }

  dimension: represented_country_geoname_id {
    type: number
    sql: ${TABLE}.represented_country_geoname_id ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
