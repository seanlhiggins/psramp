
view: num{
  derived_table:{
    sql: SELECT 1 as "n" UNION SELECT 2 as "n";;}

  dimension: n {
     type: number
     sql: ${TABLE}.n ;;
     hidden: yes
    }
}
