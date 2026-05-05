use sqlx::SqlitePool;
use std::path::PathBuf;

pub async fn init_db() -> Result<SqlitePool, Box<dyn std::error::Error + Send + Sync>> {
    let db_path = get_db_path();
    if let Some(parent) = db_path.parent() {
        std::fs::create_dir_all(parent)?;
    }
    let url = format!("sqlite://{}?mode=rwc", db_path.display());
    let pool = SqlitePool::connect(&url).await?;
    sqlx::migrate!("./migrations").run(&pool).await?;
    Ok(pool)
}

fn get_db_path() -> PathBuf {
    let home = dirs::home_dir().expect("home directory not found");
    home.join(".pelica").join("db")
}
