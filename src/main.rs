use std::{
    collections::HashMap,
    sync::{Arc, RwLock},
};

use psql_listener_handler::{start_listening, Payload};

#[tokio::main]
async fn main() {
    let pool = sqlx::PgPool::connect(
        "postgres://passforyourbot:passforyourbot@localhost:5432/passforyourbot",
    )
    .await
    .unwrap();
    // let _ = "gush jfre".split(" ");

    let channels = vec!["table_update"];

    let hm: HashMap<String, String> = HashMap::new();
    let constants = Arc::new(RwLock::new(hm));

    let call_back = |payload: Payload| {
        match payload.action_type {
            psql_listener_handler::ActionType::INSERT => {
                let mut constants = constants.write().unwrap();
                constants.insert(payload.key, payload.value);
            }
            psql_listener_handler::ActionType::UPDATE => {
                let mut constants = constants.write().unwrap();
                constants.insert(payload.key, payload.value);
            }
            psql_listener_handler::ActionType::DELETE => {
                let mut constants = constants.write().unwrap();
                constants.remove(&payload.key);
            }
        };
        println!("constants: {:?}", constants);
        println!(" ");
    };

    let _ = start_listening(&pool, channels, call_back).await;
}
