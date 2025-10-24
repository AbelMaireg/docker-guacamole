# 🌀 Apache Guacamole — Docker Compose Setup

This repository provides a **ready-to-run Docker setup** for [Apache Guacamole](https://guacamole.apache.org/), a *clientless remote desktop gateway* that supports RDP, SSH, and VNC — all accessible through your web browser.

Once set up, Guacamole will be available at:
👉 **[http://localhost:8080/guacamole](http://localhost:8080/guacamole)**

---

## 🚀 Quick Start

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/yourusername/guacamole-docker.git
cd guacamole-docker
```

### 2️⃣ Configure Environment (Optional)

Copy the example environment file and edit if needed:

```bash
cp .example.env .env
```

Default values:

```env
DB_NAME="guacamole_db"
DB_USER="admin"
DB_PASS="password"
```

You can safely use the defaults for local testing.
For production, **change these credentials** to strong unique values.

---

### 3️⃣ Start the Stack

Run the entire Guacamole setup with a single command:

```bash
docker compose up -d
```

That’s it!
Docker will automatically:

1. Build a PostgreSQL 18 database pre-initialized with the Guacamole schema.
2. Start the Guacamole daemon (`guacd`).
3. Launch the Guacamole web app (`guacamole`) connected to both services.

Once done, open your browser and visit:
👉 [http://localhost:8080/guacamole](http://localhost:8080/guacamole)

---

## 🔑 Default Login

| Username    | Password    |
| ----------- | ----------- |
| `guacadmin` | `guacadmin` |

> ⚠️ **Security Note:**
> Change the default password immediately after first login.

---

## 🧠 How It Works

### 🧱 Docker Compose Services

| Service       | Description                                                                              |
| ------------- | ---------------------------------------------------------------------------------------- |
| **db**        | Custom PostgreSQL 18 image with Guacamole schema preloaded (built from `db.Dockerfile`). |
| **guacd**     | Guacamole daemon — handles remote desktop protocols (RDP, SSH, VNC).                     |
| **guacamole** | The web frontend accessible from your browser.                                           |

### 🔗 Network and Volume

| Resource  | Purpose                                            |
| --------- | -------------------------------------------------- |
| `net`     | Internal Docker network connecting all containers. |
| `pg_data` | Persistent storage for PostgreSQL data.            |

---

## ⚙️ File Overview

```
.
├── docker-compose.yml        # Defines the Guacamole stack
├── db.Dockerfile             # Multi-stage Dockerfile to build the PostgreSQL + schema image
├── .example.env              # Example environment configuration
└── README.md                 # This file
```

---

## 🧩 How the Database Build Works

### Stage 1 — Generate Schema

The build uses the **Guacamole 1.6.0 image** to create the database schema file:

```dockerfile
FROM guacamole/guacamole:1.6.0 AS schema-generator
RUN /opt/guacamole/bin/initdb.sh --postgresql > /tmp/initdb.sql
```

### Stage 2 — Initialize PostgreSQL

The second stage uses **PostgreSQL 18**, copying the schema into the database initialization directory:

```dockerfile
FROM postgres:18 AS runtime
COPY --from=schema-generator /tmp/initdb.sql /docker-entrypoint-initdb.d/initdb.sql
```

At startup, PostgreSQL runs this SQL file automatically, preparing all required Guacamole tables and permissions.

---

## 🧰 Useful Commands

| Action                 | Command                                                       |
| ---------------------- | ------------------------------------------------------------- |
| Start all containers   | `docker compose up -d`                                        |
| Stop containers        | `docker compose down`                                         |
| View logs              | `docker compose logs -f`                                      |
| Rebuild database image | `docker compose build db`                                     |
| Access database shell  | `docker exec -it <db_container> psql -U $DB_USER -d $DB_NAME` |

---

## 🧠 Notes

* PostgreSQL data persists in the named volume `pg_data`.
* The database schema auto-initializes on first startup only.
* To reset the database, remove the volume:

  ```bash
  docker volume rm guacamole_pg_data
  ```
* Always back up your database before making changes.

---

## 🧾 License

This setup uses:

* [Apache Guacamole (Apache License 2.0)](https://www.apache.org/licenses/LICENSE-2.0)
* [PostgreSQL 18 (PostgreSQL License)](https://www.postgresql.org/about/licence/)

---

### 🎉 You’re Ready to Go!

Your Guacamole instance should now be running locally.
You can connect to RDP, SSH, or VNC servers **directly from your browser** — no client software needed.
