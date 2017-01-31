view: order_sequence {
 derived_table: {
   sql: SELECT id as order_id, ROW_NUMBER() OVER (partition by user_id ORDER BY created_at) user_order_sequence_number
  FROM orders;;
 }
dimension: order_id {
  primary_key: yes
  sql: ${TABLE}.order_id ;;
  }
dimension: user_order_sequence_number {
  type: number
  sql: ${TABLE}.user_order_sequence_number ;;
  }
}
