DO $$ BEGIN
    CREATE TYPE order_status AS ENUM ('created', 'paid', 'shipped', 'delivered', 'canceled');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;