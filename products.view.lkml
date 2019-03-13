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
    required_access_grants: [category_access]
    type: string
    sql: ${TABLE}.category ;;
    suggest_dimension: category
  }

parameter: metric {
  default_value: "Rev"
  type: unquoted
  allowed_value: {value:"Rev"}
  allowed_value: {value:"CPO"}
  allowed_value: {value:"CPC"}
  allowed_value: {value:"CPM"}
  allowed_value: {value:"Cost"}
  allowed_value: {value:"Clicks"}
}

  dimension: test_dimension {
    type: string
    sql: {% if metric._parameter_value == "Rev" %}'How much revenue have we made in the current period?'
    {% elsif metric._parameter_value == "CPO" %}'What is the average Cost per Sale in the current period?'
    {% elsif metric._parameter_value == "CPC" %}'What is the average spent per click in the current period?'
    {% elsif metric._parameter_value == "CPM" %}'How much was spent on every thousand impressions in the current period?'
    {% elsif metric._parameter_value == "Cost" %}'How much total budget have we spentin the current period?'
    {% elsif metric._parameter_value == "Clicks" %}'How many total clicks have we generated in the current period?'
    {% else %} {{ metric._parameter_value}}
    {% endif %}
    ;;
#     html: {{_user_attributes['brand']}} ;;
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
