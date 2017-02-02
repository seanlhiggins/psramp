# - dashboard: brand_comparison
#   title: Brand Comparison
#   layout: tile
#   tile_size: 100

#   filters:

#   elements:
#     - name: Brand Comparison
#       title: Brand Comparison
#       type: field_filter
#       field_name: products.category
#       model: ps_ramp_case_study
#       explore: order_items
#       dimensions: [products.brand, products.category]
#       pivots: [products.category]
#       measures: [order_items.total_revenue, order_items.count]
#       filters:
#         products.brand: Ray-Ban
#         products.category: Accessories
#       sorts: [order_items.total_revenue desc 0, products.category]
#       limit: '25'
#       column_limit: '50'
#       query_timezone: America/Los_Angeles
