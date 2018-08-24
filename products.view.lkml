view: products {
  sql_table_name: demo_db.products ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
    suggest_dimension: brand
    }

  parameter: image_url {
    type: unquoted
  }
  dimension: product_image {
    sql: 1;;
    html: <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSq7OyHRIDa1t4Mnbk6U4Ac3U_{{ products.image_url._parameter_value }}" ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
    suggest_dimension: category
  }

  dimension: test_dimension {
    type: string
    sql: ${brand} ;;
    html: {{_user_attributes['brand']}} ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: item_name {
    type: string
    sql: ${TABLE}.item_name ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  measure: count {
    type: count
    drill_fields: [id, item_name, inventory_items.count]
  }
}
