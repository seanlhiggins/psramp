- dashboard: criteo_localization_tests
  title: table_calc_label
  layout: newspaper
  elements:
  - title: table_calc_label
    name: Table Calc
    model: ecommerce
    explore: order_items
    type: table
    fields: [users.age_tier, users.count]
    fill_fields: [users.age_tier]
    sorts: [users.age_tier]
    limit: 500
    dynamic_fields: [{table_calculation: table_calc_label, label: table_calc_label, expression: "${users.count}* 50", value_format: !!null '',
        value_format_name: !!null '', _kind_hint: measure, _type_hint: number}]
    query_timezone: Europe/Dublin
    row: 0
    col: 0
    width: 8
    height: 6
