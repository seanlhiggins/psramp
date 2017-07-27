connection: "test"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

explore: geoipstest {}
explore: ip_sample {
  join: geoipstest {
    sql_on: ${ip_sample.last_sign_in_ip} = ${geoipstest.network} ;;
    relationship: one_to_one
    type: inner
  }
}
