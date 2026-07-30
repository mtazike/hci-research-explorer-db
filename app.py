# Author: Mahya Tazike
# Flask application for the HCI Research Explorer project

from flask import Flask, render_template, request
import mysql.connector
import os
from dotenv import load_dotenv
import matplotlib
matplotlib.use('Agg')  # Use non-interactive backend (no GUI needed)
import matplotlib.pyplot as plt
import io
import base64

# Load environment variables from the .env file
load_dotenv()

app = Flask(__name__)

def get_db_connection():
    """Creates and returns a new MySQL database connection using .env credentials."""
    connection = mysql.connector.connect(
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        database=os.getenv("DB_NAME")
    )
    return connection

@app.route("/")
def home():
    """Displays the homepage with the search form (no results yet)."""
    return render_template(
        "index.html",
        papers=None, searched=False,
        authors_results=None, author_searched=False,
        category_results=None, category_searched=False,
        year_results=None, year_searched=False,
        add_message=None
    )

@app.route("/search")
def search():
    """
    Query 1: Search papers by a keyword in the title.
    Application functionality: Allows users to search for research papers
    whose titles contain a specified keyword.
    """
    keyword = request.args.get("keyword", "")

    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute(
        "SELECT paper_id, title, update_date FROM papers WHERE title LIKE %s ORDER BY update_date DESC",
        (f"%{keyword}%",)
    )
    results = cursor.fetchall()
    cursor.close()
    connection.close()

    return render_template(
        "index.html",
        papers=results, searched=True,
        authors_results=None, author_searched=False,
        category_results=None, category_searched=False,
        year_results=None, year_searched=False,
        add_message=None
    )

@app.route("/search-author")
def search_author():
    """
    Query 2: Search papers by author name.
    Application functionality: Allows users to find all papers
    written by a specified author.
    """
    lastname = request.args.get("lastname", "")

    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("""
        SELECT a.first_name, a.last_name, p.paper_id, p.title, p.update_date
        FROM papers p
        JOIN paper_authors pa ON p.paper_id = pa.paper_id
        JOIN authors a ON pa.author_id = a.author_id
        WHERE a.last_name LIKE %s
        ORDER BY p.update_date DESC
    """, (f"%{lastname}%",))
    results = cursor.fetchall()
    cursor.close()
    connection.close()

    return render_template(
        "index.html",
        papers=None, searched=False,
        authors_results=results, author_searched=True,
        category_results=None, category_searched=False,
        year_results=None, year_searched=False,
        add_message=None
    )

@app.route("/search-category")
def search_category():
    """
    Query 3: Search papers by category.
    Application functionality: Allows users to browse all papers
    assigned to a specified subject category.
    """
    category = request.args.get("category", "")

    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("""
        SELECT c.category_code, p.paper_id, p.title, p.update_date
        FROM papers p
        JOIN paper_categories pc ON p.paper_id = pc.paper_id
        JOIN categories c ON pc.category_id = c.category_id
        WHERE c.category_code = %s
        ORDER BY p.update_date DESC
    """, (category,))
    results = cursor.fetchall()
    cursor.close()
    connection.close()

    return render_template(
        "index.html",
        papers=None, searched=False,
        authors_results=None, author_searched=False,
        category_results=results, category_searched=True,
        year_results=None, year_searched=False,
        add_message=None
    )

@app.route("/search-year")
def search_year():
    """
    Query 4: Retrieve papers within a year range of last update.
    Application functionality: Allows users to browse papers
    updated between a start year and an end year (inclusive).
    """
    start_year = request.args.get("start_year", "")
    end_year = request.args.get("end_year", "")

    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute(
        "SELECT paper_id, title, update_date FROM papers WHERE YEAR(update_date) BETWEEN %s AND %s ORDER BY update_date ASC",
        (start_year, end_year)
    )
    results = cursor.fetchall()
    cursor.close()
    connection.close()

    return render_template(
        "index.html",
        papers=None, searched=False,
        authors_results=None, author_searched=False,
        category_results=None, category_searched=False,
        year_results=results, year_searched=True,
        add_message=None
    )

@app.route("/trend")
def trend():
    """
    Query 5: Publication trend over time.
    Application functionality: Powers a visualization showing how many
    HCI papers were updated in each year, revealing growth trends
    in the field over time.
    """
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("""
        SELECT YEAR(update_date) AS year, COUNT(*) AS paper_count
        FROM papers
        GROUP BY YEAR(update_date)
        ORDER BY year
    """)
    results = cursor.fetchall()
    cursor.close()
    connection.close()

    years = [str(row[0]) for row in results]
    counts = [row[1] for row in results]

    fig, ax = plt.subplots()
    ax.bar(years, counts, color="steelblue")
    ax.set_xlabel("Year")
    ax.set_ylabel("Number of Papers")
    ax.set_title("HCI Paper Publication Trend")

    buffer = io.BytesIO()
    fig.savefig(buffer, format="png")
    plt.close(fig)
    buffer.seek(0)
    image_base64 = base64.b64encode(buffer.getvalue()).decode("utf-8")

    return render_template("trend.html", chart_image=image_base64)

@app.route("/top-authors")
def top_authors():
    """
    Query 6: Top authors by number of papers.
    Application functionality: Powers a "most active researchers" view,
    helping users identify who publishes most frequently in HCI.
    """
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("""
        SELECT a.first_name, a.last_name, COUNT(*) AS paper_count
        FROM authors a
        JOIN paper_authors pa ON a.author_id = pa.author_id
        GROUP BY a.author_id, a.first_name, a.last_name
        ORDER BY paper_count DESC, a.last_name ASC, a.first_name ASC
        LIMIT 10
    """)
    results = cursor.fetchall()
    cursor.close()
    connection.close()

    return render_template("top_authors.html", authors=results)

@app.route("/add-paper", methods=["POST"])
def add_paper():
    """
    Create: Adds a new paper to the database, along with its category link.
    Application functionality: Lets users add a new paper record directly
    from the web interface.
    """
    paper_id = request.form.get("paper_id")
    title = request.form.get("title")
    update_date = request.form.get("update_date")
    category = request.form.get("category")

    connection = get_db_connection()
    cursor = connection.cursor()
    try:
        cursor.execute(
            "INSERT INTO papers (paper_id, title, update_date) VALUES (%s, %s, %s)",
            (paper_id, title, update_date)
        )
        cursor.execute(
            "SELECT category_id FROM categories WHERE category_code = %s",
            (category,)
        )
        cat_row = cursor.fetchone()
        if cat_row:
            cursor.execute(
                "INSERT INTO paper_categories (paper_id, category_id) VALUES (%s, %s)",
                (paper_id, cat_row[0])
            )
        connection.commit()
        message = f"Paper '{title}' added successfully."
    except mysql.connector.Error as err:
        connection.rollback()
        message = f"Error adding paper: {err}"
    finally:
        cursor.close()
        connection.close()

    return render_template(
        "index.html",
        papers=None, searched=False,
        authors_results=None, author_searched=False,
        category_results=None, category_searched=False,
        year_results=None, year_searched=False,
        add_message=message
    )

@app.route("/delete-paper", methods=["POST"])
def delete_paper():
    """
    Delete: Removes a paper and its related junction-table rows from the database.
    Application functionality: Lets users delete a paper record directly
    from the search results.
    """
    paper_id = request.form.get("paper_id")

    connection = get_db_connection()
    cursor = connection.cursor()
    try:
        cursor.execute("DELETE FROM paper_authors WHERE paper_id = %s", (paper_id,))
        cursor.execute("DELETE FROM paper_categories WHERE paper_id = %s", (paper_id,))
        cursor.execute("DELETE FROM papers WHERE paper_id = %s", (paper_id,))
        connection.commit()
        message = f"Paper '{paper_id}' deleted successfully."
    except mysql.connector.Error as err:
        connection.rollback()
        message = f"Error deleting paper: {err}"
    finally:
        cursor.close()
        connection.close()

    return render_template(
        "index.html",
        papers=None, searched=False,
        authors_results=None, author_searched=False,
        category_results=None, category_searched=False,
        year_results=None, year_searched=False,
        add_message=message
    )

@app.route("/edit-paper", methods=["GET"])
def edit_paper_form():
    """
    Update (step 1): Displays a form pre-filled with the paper's current title,
    so the user can edit it.
    """
    paper_id = request.args.get("paper_id")

    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT paper_id, title FROM papers WHERE paper_id = %s", (paper_id,))
    paper = cursor.fetchone()
    cursor.close()
    connection.close()

    return render_template("edit.html", paper=paper)

@app.route("/edit-paper", methods=["POST"])
def edit_paper_save():
    """
    Update (step 2): Saves the edited title back to the database.
    Application functionality: Lets users update a paper's title
    directly from the web interface.
    """
    paper_id = request.form.get("paper_id")
    new_title = request.form.get("title")

    connection = get_db_connection()
    cursor = connection.cursor()
    try:
        cursor.execute(
            "UPDATE papers SET title = %s WHERE paper_id = %s",
            (new_title, paper_id)
        )
        connection.commit()
        message = f"Paper '{paper_id}' updated successfully."
    except mysql.connector.Error as err:
        connection.rollback()
        message = f"Error updating paper: {err}"
    finally:
        cursor.close()
        connection.close()

    return render_template(
        "index.html",
        papers=None, searched=False,
        authors_results=None, author_searched=False,
        category_results=None, category_searched=False,
        year_results=None, year_searched=False,
        add_message=message
    )

if __name__ == "__main__":
    app.run(debug=True)
