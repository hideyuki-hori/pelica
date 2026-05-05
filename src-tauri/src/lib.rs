mod db;

use sqlx::SqlitePool;
use tauri::Manager;

struct AppState {
    db: SqlitePool,
}

#[tauri::command]
fn greet(name: &str) -> String {
    format!("Hello, {}! You've been greeted from Rust!", name)
}

#[tauri::command]
async fn db_health_check(state: tauri::State<'_, AppState>) -> Result<i32, String> {
    let row: (i32,) = sqlx::query_as("SELECT 1")
        .fetch_one(&state.db)
        .await
        .map_err(|e| e.to_string())?;
    Ok(row.0)
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_opener::init())
        .setup(|app| {
            let pool = tauri::async_runtime::block_on(db::init_db())
                .expect("failed to initialize database");
            app.manage(AppState { db: pool });
            Ok(())
        })
        .invoke_handler(tauri::generate_handler![greet, db_health_check])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
