connection: "red_look"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

explore: inventory_items {
  fields: [ALL_FIELDS*,-products.brand_comparitor]
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
  fields: [ALL_FIELDS*,-products.brand_comparitor,-users.id]
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
  join: order_sequence {
    type: full_outer
    relationship: one_to_one
    sql_on: ${order_sequence.order_id}=${orders.id} ;;
  }
}

explore: product_facts {
  fields: [ALL_FIELDS*,-products.brand_comparitor]
  join: products {
    type: left_outer
    sql_on: ${product_facts.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}

explore: products {
  fields: [ALL_FIELDS*,-order_items.total_customers,-order_items.total_customers_returning_items]

  join: num {
    type: cross
    relationship: one_to_many
  }
  join: inventory_items {
    type: left_outer
    relationship: one_to_many
    sql_on:  ${products.id}=${inventory_items.product_id};;
  }

join: order_items {
  type: full_outer
  sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
  relationship: many_to_one
}
}

explore: users {}

explore: order_funnel {
  join: orders {
    sql_on: ${orders.id}=${order_funnel.first_order_id} ;;
    relationship: one_to_one
  }
}
