# PgListener

A PgListener example based on [sqlx PgListener](https://docs.rs/sqlx/0.6.2/sqlx/postgres/struct.PgListener.html) that 
used PgListener to listen the change in a table and update the Arc<HashMap> in real time.

I am using this for managing my dynamic constants around my microservices since I use Django CMS for CRUD operations.

Now I don't have to reload my services every time to reflects the changes in my constant DB table.
 
