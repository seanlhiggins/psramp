view: products {
  sql_table_name: public.products ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    drill_fields: [item_name,brand_select, category, users.gender,users.age]
    link:{
    label:"Google"
    url: "http://www.google.com/search?q={{ value }}"
    icon_url: "http://google.com/favicon.ico"
    }
    link: {
    label:"Facebook"
    url:"http://www.facebook.com/q?={{value}}"
    icon_url: "http://www.sacredperuadventures.com/images/facebook.jpg"
    }
    sql: ${TABLE}.brand ;;
  }


  filter: brand_select{
    suggest_dimension: brand
    }

  dimension: brand_comparitor {
    sql:
      CASE WHEN {% condition brand_select %} ${brand} {% endcondition %}  AND ${num.n} = 1
      THEN ${brand}
      ELSE 'All Other Brands'
      END;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
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
  measure: count_sku{
    type: count_distinct
    sql: ${sku} ;;
    }


  measure: percent_of_total{
    type: percent_of_total
    direction: "column"
    sql: ${count_sku};;
    }


  measure: count {
    type: count
    drill_fields: [id, item_name, inventory_items.count, product_facts.count, brand, category]
  }
}
