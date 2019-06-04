connection: "thelook"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"
#synctest
explore: events {
  access_filter: {
    field: users.email
    user_attribute: email
  }
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}


# access_grant: category_access {
#   user_attribute: brand_name
#   allowed_values: ["Allegra K"]
# }



datagroup:  default{
  sql_trigger: SELECT CURRENTDATE() ;;
}

datagroup: items {
  sql_trigger: SELECT max(id) FROM etl_jobs ;;
}

#test comment

explore: user_orders_facts {}

explore: inventory_items {
#   persist_with: items
#   access_filter: {
#     field: products.brand
#     user_attribute: brand
#   }
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {

  join: inventory_items {
    type: left_outer
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id}  ;;
    relationship: many_to_one
  }

  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: orders {
  join: users {
    type: left_outer
    sql_on: ${users.id}=${orders.user_id} ;;
    relationship: many_to_one
  }
  join: user_orders_facts {
    type: left_outer
    sql_on: ${user_orders_facts.user_id}=${users.id} ;;
    relationship: one_to_one
  }
}

# explore: products {
#   access_filter: {
#     field: products.brand
#     user_attribute: brand
#   }
# }

explore: schema_migrations {}

explore: users {
  join: user_facts_view {
    sql_on: ${users.id} = ${user_facts_view.orders_user_id} ;;
    relationship: one_to_one
  }
}

# explore: users_new {
#   extends: [users]
#   from: users
#   sql_always_where: ${users.age} >18 ;;
#   join: orders {
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }
