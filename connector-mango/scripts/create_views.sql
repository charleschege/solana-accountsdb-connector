-- Views for raw accounts
CREATE VIEW account_rooted AS
    SELECT
        DISTINCT ON(pubkey)
        *
        FROM account_write
        INNER JOIN slot USING(slot)
        WHERE slot.status = 'rooted'
        ORDER BY pubkey, slot DESC, write_version DESC;
CREATE VIEW account_committed AS
    SELECT
        DISTINCT ON(pubkey)
        *
        FROM account_write
        INNER JOIN slot USING(slot)
        WHERE (slot.status = 'committed' AND NOT slot.uncle) OR slot.status = 'rooted'
        ORDER BY pubkey, slot DESC, write_version DESC;
CREATE VIEW account_processed AS
    SELECT
        DISTINCT ON(pubkey)
        *
        FROM account_write
        INNER JOIN slot USING(slot)
        WHERE ((slot.status = 'committed' OR slot.status = 'processed') AND NOT slot.uncle) OR slot.status = 'rooted'
        ORDER BY pubkey, slot DESC, write_version DESC;

CREATE VIEW mango_account_rooted AS
    SELECT
        DISTINCT ON(pubkey)
        *
        FROM mango_account_write
        INNER JOIN slot USING(slot)
        WHERE slot.status = 'rooted'
        ORDER BY pubkey, slot DESC, write_version DESC;
CREATE VIEW mango_account_committed AS
    SELECT
        DISTINCT ON(pubkey)
        *
        FROM mango_account_write
        INNER JOIN slot USING(slot)
        WHERE (slot.status = 'committed' AND NOT slot.uncle) OR slot.status = 'rooted'
        ORDER BY pubkey, slot DESC, write_version DESC;
CREATE VIEW mango_account_processed AS
    SELECT
        DISTINCT ON(pubkey)
        *
        FROM mango_account_write
        INNER JOIN slot USING(slot)
        WHERE ((slot.status = 'committed' OR slot.status = 'processed') AND NOT slot.uncle) OR slot.status = 'rooted'
        ORDER BY pubkey, slot DESC, write_version DESC;

CREATE VIEW mango_account_processed_balance AS
    SELECT
        pubkey,
        unnest(array['MNGO', 'BTC', 'ETH', 'SOL', 'USDT', 'SRM', 'RAY', 'COPE', 'FTT', 'ADA', 'unused10', 'unused11', 'unused12', 'unused13', 'unused14', 'USDC']) as token,
        unnest(deposits) as deposit,
        unnest(borrows) as borrow
    FROM mango_account_processed;

CREATE VIEW mango_account_processed_perp AS
    SELECT
        pubkey,
        perp,
        (q.perp_account).*
    FROM (
        SELECT
            pubkey,
            unnest(array['MNGO', 'BTC', 'ETH', 'SOL', 'unused_USDT', 'SRM', 'RAY', 'unused_COPE', 'FTT', 'ADA', 'unused10', 'unused11', 'unused12', 'unused13', 'unused14']) as perp,
            unnest(perp_accounts) as perp_account
        FROM mango_account_processed
    ) q;