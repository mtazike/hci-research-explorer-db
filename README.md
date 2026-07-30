# HCI Research Explorer

A simple Flask web application and MySQL database for searching Human-Computer Interaction (HCI) research papers. This project was developed for the Applied Database Technologies course.

**Author:** Mahya Tazike (individual submission)

## Project Overview

This project uses metadata from the arXiv dataset, filters it to Human-Computer Interaction papers, stores the data in a normalized MySQL database, and provides a simple Flask interface for searching, browsing, and managing the data.

Users can:
- Search papers by title keyword
- Search papers by author
- Browse papers by category
- Browse papers by year range
- Add a new paper (Create)
- Edit a paper's title (Update)
- Delete a paper (Delete)
- View analytics (publication trend chart, top authors)

## Repository Contents

| File / Folder | Description |
|---|---|
| `schema.sql` | Creates the database and all five tables (`papers`, `authors`, `categories`, `paper_authors`, `paper_categories`) with primary/foreign keys and constraints. |
| `queries.sql` | The six application queries (search by title, author, category, year range; publication trend; top authors). |
| `full_database.sql` | The complete, reproducible script — combines the schema, sample data, and queries into a single file. Starts with `DROP DATABASE IF EXISTS`, so it can be re-run from a clean state. |
| `app.py` | Flask application implementing CRUD operations, search features, and analytics. |
| `templates/` | HTML templates (`index.html`, `trend.html`, `top_authors.html`, `edit.html`) rendered by Flask. |

## Database Design

The database contains five tables. Since one paper can have multiple authors and categories, two junction tables are used to represent these many-to-many relationships.

- **papers** (paper_id PK)
- **authors** (author_id PK)
- **categories** (category_id PK)
- **paper_authors** (junction table, resolves papers ↔ authors many-to-many)
- **paper_categories** (junction table, resolves papers ↔ categories many-to-many)

## How to Run

### 1. Set up the database
1. Install MySQL (e.g., via MAMP) and open MySQL Workbench.
2. Open `full_database.sql` and execute it. This creates the database, tables, and sample data, and runs the six application queries.

### 2. Set up the Flask application
1. Install dependencies:
```bash
pip install flask mysql-connector-python python-dotenv matplotlib pandas
```
2. Create a `.env` file in the project root with your local database credentials:
```env
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=root
DB_PASSWORD=root
DB_NAME=hci_research_db
```
   (`.env` is intentionally not included in this repository, since it holds local credentials.)
3. Run the app:
```bash
python app.py
```
4. Open `http://127.0.0.1:5000/` in a browser.

## Data Source

Cornell University. (2024). *arXiv Dataset* [Data set]. Kaggle. https://www.kaggle.com/datasets/Cornell-University/arxiv

## AI Assistance

Claude was used to help generate portions of the application code and to debug SQL connection errors. The database design, ER model, normalization, and SQL queries were designed and implemented independently by Mahya Tazike.
