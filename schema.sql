-- ============================================================
-- HCI Research Explorer - Database Schema
-- Author: Mahya Tazike
-- Description: Creates the database and all tables required
--              for the HCI Research Explorer project.
-- ============================================================

-- Author: Mahya Tazike
-- Recreates the database for a clean, reproducible run
DROP DATABASE IF EXISTS hci_research_db;
CREATE DATABASE hci_research_db;
USE hci_research_db;

-- ============================================================
-- Core entity tables (created first, no dependencies)
-- ============================================================

-- Author: Mahya Tazike
-- Creates the Papers table, storing core metadata for each research paper
CREATE TABLE papers (
    paper_id     VARCHAR(20)   NOT NULL,
    title        VARCHAR(1000) NOT NULL,
    abstract     TEXT,
    doi          VARCHAR(100),
    journal_ref  VARCHAR(255),
    update_date  DATE          NOT NULL,
    PRIMARY KEY (paper_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Author: Mahya Tazike
-- Creates the Authors table, storing unique author names
CREATE TABLE authors (
    author_id    INT           NOT NULL AUTO_INCREMENT,
    last_name    VARCHAR(100)  NOT NULL,
    first_name   VARCHAR(100),
    PRIMARY KEY (author_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Author: Mahya Tazike
-- Creates the Categories table, storing unique subject category codes
CREATE TABLE categories (
    category_id    INT          NOT NULL AUTO_INCREMENT,
    category_code  VARCHAR(20)  NOT NULL,
    PRIMARY KEY (category_id),
    UNIQUE (category_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- Junction tables (created after core tables, since their
-- foreign keys depend on papers, authors, and categories)
-- ============================================================

-- Author: Mahya Tazike
-- Creates the Paper_Authors junction table, resolving the
-- many-to-many relationship between papers and authors
CREATE TABLE paper_authors (
    paper_id      VARCHAR(20)  NOT NULL,
    author_id     INT          NOT NULL,
    author_order  INT          NOT NULL,
    PRIMARY KEY (paper_id, author_id),
    FOREIGN KEY (paper_id) REFERENCES papers(paper_id),
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Author: Mahya Tazike
-- Creates the Paper_Categories junction table, resolving the
-- many-to-many relationship between papers and categories
CREATE TABLE paper_categories (
    paper_id     VARCHAR(20)  NOT NULL,
    category_id  INT          NOT NULL,
    PRIMARY KEY (paper_id, category_id),
    FOREIGN KEY (paper_id) REFERENCES papers(paper_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
