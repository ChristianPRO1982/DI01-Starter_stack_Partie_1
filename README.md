# DI01-Starter_stack_Partie_1
Starter stack pour Data Engineers - Partie 1

## structure
* n8n_data/
* n8n_files/init
* n8n_files/input
* n8n_files/output
* n8n_files/done
* n8n_files/error

## pour la mise en route
```
sudo chown -R 1000:1000 ./n8n_files
```

```
CREATE TABLE IF NOT EXISTS order_items (
  line_id       BIGSERIAL PRIMARY KEY,
  order_id      TEXT NOT NULL,
  customer_id   TEXT NOT NULL,
  channel       TEXT NOT NULL,
  created_at    TIMESTAMP NOT NULL,
  payment_status TEXT NOT NULL,
  sku           TEXT NOT NULL,
  qty           INTEGER NOT NULL,
  unit_price    NUMERIC(10,2) NOT NULL,
  item_index    INTEGER NOT NULL DEFAULT 1,
  inserted_at   TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS ux_order_items_natural
  ON order_items(order_id, sku, item_index);
```