connection: "red_look"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}

explore: customer_orders_detail {
  join: users {
    type: left_outer
    sql_on: ${users.id}=${customer_orders_detail.user_id} ;;
    relationship: one_to_one
  }
}
explore: order_items {
  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: full_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: order_funnel {
    type: full_outer
    sql_on: ${orders.id}=${order_funnel.first_order_id} ;;
    relationship: one_to_one
  }

  join: order_sequence {
    type: full_outer
    sql_on: ${order_items.id}=${order_sequence.order_id} ;;
    relationship: one_to_one
  }
}

explore: orders {
  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: product_facts {
  join: products {
    type: left_outer
    sql_on: ${product_facts.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}

explore: products {}

explore: users {}

explore: order_funnel {
  join: orders {
    sql_on: ${orders.id}=${order_funnel.first_order_id} ;;
    relationship: one_to_one
  }
}
