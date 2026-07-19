-- ============================================================
-- HCI Research Explorer
-- Complete Database Script
-- Author: Mahya Tazike
-- Description: Full reproducible script that creates the database,
--              defines all tables with constraints, inserts sample
--              data, and runs the application's core queries.
--
--              Part 1: Schema (CREATE DATABASE + CREATE TABLE)
--              Part 2: Sample Data (INSERT statements)
--              Part 3: Application Queries (SELECT statements)
-- ============================================================


-- ============================================================
-- PART 1: SCHEMA
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


-- ============================================================
-- PART 2: SAMPLE DATA
-- ============================================================

-- Author: Mahya Tazike
-- Sample data for the Papers table
INSERT INTO papers (paper_id, title, abstract, doi, journal_ref, update_date) VALUES ('0704.1353', 'Supporting Knowledge and Expertise Finding within Australia''s Defence Science and Technology Organisation', 'This paper reports on work aimed at supporting knowledge and expertise finding within a large Research and Development (R&D) organisation. The paper first discusses the nature of knowledge important to R&D organisations and presents a prototype information system developed to support knowledge and expertise finding. The paper then discusses a trial of the system within an R&D organisation, the implications and limitations of the trial, and discusses future research questions.', NULL, NULL, '2007-05-23');
INSERT INTO papers (paper_id, title, abstract, doi, journal_ref, update_date) VALUES ('0704.1676', 'Personalizing Image Search Results on Flickr', 'The social media site Flickr allows users to upload their photos, annotate them with tags, submit them to groups, and also to form social networks by adding other users as contacts. Flickr offers multiple ways of browsing or searching it. One option is tag search, which returns all images tagged with a specific keyword. If the keyword is ambiguous, e.g., ``beetle'''' could mean an insect or a car, tag search results will include many images that are not relevant to the sense the user had in mind when executing the query. We claim that users express their photography interests through the metadata they add in the form of contacts and image annotations. We show how to exploit this metadata to personalize search results for the user, thereby improving search performance. First, we show that we can significantly improve search precision by filtering tag search results by user''s contacts or a larger social network that includes those contact''s contacts. Secondly, we describe a probabilistic model that takes advantage of tag information to discover latent topics contained in the search results. The users'' interests can similarly be described by the tags they used for annotating their images. The latent topics found by the model are then used to personalize search results by finding images on topics that are of interest to the user.', NULL, NULL, '2007-05-23');
INSERT INTO papers (paper_id, title, abstract, doi, journal_ref, update_date) VALUES ('0704.2542', 'Narratives within immersive technologies', 'The main goal of this project is to research technical advances in order to enhance the possibility to develop narratives within immersive mediated environments. An important part of the research is concerned with the question of how a script can be written, annotated and realized for an immersive context. A first description of the main theoretical framework and the ongoing work and a first script example is provided. This project is part of the program for presence research, and it will exploit physiological feedback and Computational Intelligence within virtual reality.', NULL, NULL, '2007-05-23');
INSERT INTO papers (paper_id, title, abstract, doi, journal_ref, update_date) VALUES ('0704.3643', 'Sabbath Day Home Automation: "It''s Like Mixing Technology and Religion"', 'We present a qualitative study of 20 American Orthodox Jewish families'' use of home automation for religious purposes. These lead users offer insight into real-life, long-term experience with home automation technologies. We discuss how automation was seen by participants to contribute to spiritual experience and how participants oriented to the use of automation as a religious custom. We also discuss the relationship of home automation to family life. We draw design implications for the broader population, including surrender of control as a design resource, home technologies that support long-term goals and lifestyle choices, and respite from technology.', NULL, NULL, '2007-05-23');
INSERT INTO papers (paper_id, title, abstract, doi, journal_ref, update_date) VALUES ('0704.3647', 'Evaluating Personal Archiving Strategies for Internet-based Information', 'Internet-based personal digital belongings present different vulnerabilities than locally stored materials. We use responses to a survey of people who have recovered lost websites, in combination with supplementary interviews, to paint a fuller picture of current curatorial strategies and practices. We examine the types of personal, topical, and commercial websites that respondents have lost and the reasons they have lost this potentially valuable material. We further explore what they have tried to recover and how the loss influences their subsequent practices. We found that curation of personal digital materials in online stores bears some striking similarities to the curation of similar materials stored locally in that study participants continue to archive personal assets by relying on a combination of benign neglect, sporadic backups, and unsystematic file replication. However, we have also identified issues specific to Internet-based material: how risk is spread by distributing the files among multiple servers and services; the circular reasoning participants use when they discuss the safety of their digital assets; and the types of online material that are particularly vulnerable to loss. The study reveals ways in which expectations of permanence and notification are violated and situations in which benign neglect has far greater consequences for the long-term fate of important digital assets.', NULL, NULL, '2007-05-23');
INSERT INTO papers (paper_id, title, abstract, doi, journal_ref, update_date) VALUES ('0704.3653', 'The Long Term Fate of Our Digital Belongings: Toward a Service Model for Personal Archives', 'We conducted a preliminary field study to understand the current state of personal digital archiving in practice. Our aim is to design a service for the long-term storage, preservation, and access of digital belongings by examining how personal archiving needs intersect with existing and emerging archiving technologies, best practices, and policies. Our findings not only confirmed that experienced home computer users are creating, receiving, and finding an increasing number of digital belongings, but also that they have already lost irreplaceable digital artifacts such as photos, creative efforts, and records. Although participants reported strategies such as backup and file replication for digital safekeeping, they were seldom able to implement them consistently. Four central archiving themes emerged from the data: (1) people find it difficult to evaluate the worth of accumulated materials; (2) personal storage is highly distributed both on- and offline; (3) people are experiencing magnified curatorial problems associated with managing files in the aggregate, creating appropriate metadata, and migrating materials to maintainable formats; and (4) facilities for long-term access are not supported by the current desktop metaphor. Four environmental factors further complicate archiving in consumer settings: the pervasive influence of malware; consumer reliance on ad hoc IT providers; an accretion of minor system and registry inconsistencies; and strong consumer beliefs about the incorruptibility of digital forms, the reliability of digital technologies, and the social vulnerability of networked storage.', NULL, NULL, '2007-05-23');
INSERT INTO papers (paper_id, title, abstract, doi, journal_ref, update_date) VALUES ('0704.3662', 'An Automated Evaluation Metric for Chinese Text Entry', 'In this paper, we propose an automated evaluation metric for text entry. We also consider possible improvements to existing text entry evaluation metrics, such as the minimum string distance error rate, keystrokes per character, cost per correction, and a unified approach proposed by MacKenzie, so they can accommodate the special characteristics of Chinese text. Current methods lack an integrated concern about both typing speed and accuracy for Chinese text entry evaluation. Our goal is to remove the bias that arises due to human factors. First, we propose a new metric, called the correction penalty (P), based on Fitts'' law and Hick''s law. Next, we transform it into the approximate amortized cost (AAC) of information theory. An analysis of the AAC of Chinese text input methods with different context lengths is also presented.', NULL, 'Jiang, Mike Tian-Jian, et al. "Robustness analysis of adaptive chinese input methods." Advances in Text Input Methods (WTIM 2011) (2011): 53', '2013-10-29');
INSERT INTO papers (paper_id, title, abstract, doi, journal_ref, update_date) VALUES ('0704.3665', 'On the Development of Text Input Method - Lessons Learned', 'Intelligent Input Methods (IM) are essential for making text entries in many East Asian scripts, but their application to other languages has not been fully explored. This paper discusses how such tools can contribute to the development of computer processing of other oriental languages. We propose a design philosophy that regards IM as a text service platform, and treats the study of IM as a cross disciplinary subject from the perspectives of software engineering, human-computer interaction (HCI), and natural language processing (NLP). We discuss these three perspectives and indicate a number of possible future research directions.', NULL, NULL, '2007-05-23');
INSERT INTO papers (paper_id, title, abstract, doi, journal_ref, update_date) VALUES ('0705.0025', 'Can the Internet cope with stress?', 'When will the Internet become aware of itself? In this note the problem is approached by asking an alternative question: Can the Internet cope with stress? By extrapolating the psychological difference between coping and defense mechanisms a distributed software experiment is outlined which could reject the hypothesis that the Internet is not a conscious entity.', NULL, NULL, '2007-05-23');
INSERT INTO papers (paper_id, title, abstract, doi, journal_ref, update_date) VALUES ('0705.0599', 'NodeTrix: Hybrid Representation for Analyzing Social Networks', 'The need to visualize large social networks is growing as hardware capabilities make analyzing large networks feasible and many new data sets become available. Unfortunately, the visualizations in existing systems do not satisfactorily answer the basic dilemma of being readable both for the global structure of the network and also for detailed analysis of local communities. To address this problem, we present NodeTrix, a hybrid representation for networks that combines the advantages of two traditional representations: node-link diagrams are used to show the global structure of a network, while arbitrary portions of the network can be shown as adjacency matrices to better support the analysis of communities. A key contribution is a set of interaction techniques. These allow analysts to create a NodeTrix visualization by dragging selections from either a node-link or a matrix, flexibly manipulate the NodeTrix representation to explore the dataset, and create meaningful summary visualizations of their findings. Finally, we present a case study applying NodeTrix to the analysis of the InfoVis 2004 coauthorship dataset to illustrate the capabilities of NodeTrix as both an exploration tool and an effective means of communicating results.', '10.1109/TVCG.2007.70582', NULL, '2020-08-04');
INSERT INTO papers (paper_id, title, abstract, doi, journal_ref, update_date) VALUES ('0705.1395', 'Subjective Evaluation of Forms in an Immersive Environment', 'User''s perception of product, by essence subjective, is a major topic in marketing and industrial design. Many methods, based on users'' tests, are used so as to characterise this perception. We are interested in three main methods: multidimensional scaling, semantic differential method, and preference mapping. These methods are used to built a perceptual space, in order to position the new product, to specify requirements by the study of user''s preferences, to evaluate some product attributes, related in particular to style (aesthetic). These early stages of the design are primordial for a good orientation of the project. In parallel, virtual reality tools and interfaces are more and more efficient for suggesting to the user complex feelings, and creating in this way various levels of perceptions. In this article, we present on an example the use of multidimensional scaling, semantic differential method and preference mapping for the subjective assessment of virtual products. These products, which geometrical form is variable, are defined with a CAD model and are proposed to the user with a spacemouse and stereoscopic glasses. Advantages and limitations of such evaluation is next discussed..', NULL, 'Virtual Concept (2003) 1-6', '2007-05-23');
INSERT INTO papers (paper_id, title, abstract, doi, journal_ref, update_date) VALUES ('0705.3644', 'Subjective Information Measure and Rate Fidelity Theory', 'Using fish-covering model, this paper intuitively explains how to extend Hartley''s information formula to the generalized information formula step by step for measuring subjective information: metrical information (such as conveyed by thermometers), sensory information (such as conveyed by color vision), and semantic information (such as conveyed by weather forecasts). The pivotal step is to differentiate condition probability and logical condition probability of a message. The paper illustrates the rationality of the formula, discusses the coherence of the generalized information formula and Popper''s knowledge evolution theory. For optimizing data compression, the paper discusses rate-of-limiting-errors and its similarity to complexity-distortion based on Kolmogorov''s complexity theory, and improves the rate-distortion theory into the rate-fidelity theory by replacing Shannon''s distortion with subjective mutual information. It is proved that both the rate-distortion function and the rate-fidelity function are equivalent to a rate-of-limiting-errors function with a group of fuzzy sets as limiting condition, and can be expressed by a formula of generalized mutual information for lossy coding, or by a formula of generalized entropy for lossless coding. By analyzing the rate-fidelity function related to visual discrimination and digitized bits of pixels of images, the paper concludes that subjective information is less than or equal to objective (Shannon''s) information; there is an optimal matching point at which two kinds of information are equal; the matching information increases with visual discrimination (defined by confusing probability) rising; for given visual discrimination, too high resolution of images or too much objective information is wasteful.', NULL, NULL, '2007-07-13');
INSERT INTO papers (paper_id, title, abstract, doi, journal_ref, update_date) VALUES ('0706.0507', 'A collaborative framework to exchange and share product information within a supply chain context', 'The new requirement for "collaboration" between multidisciplinary collaborators induces to exchange and share adequate information on the product, processes throughout the products'' lifecycle. Thus, effective capture of information, and also its extraction, recording, exchange, sharing, and reuse become increasingly critical. These lead companies to adopt new improved methodologies in managing the exchange and sharing of information. The aim of this paper is to describe a collaborative framework system to exchange and share information, which is based on: (i) The Product Process Collaboration Organization model (PPCO) which defines product and process information, and the various collaboration methods for the organizations involved in the supply chain. (ii) Viewpoint model describes relationships between each actor and the comprehensive Product/Process model, defining each actor''s "domain of interest" within the evolving product definition. (iii) A layer which defines the comprehensive organization and collaboration relationships between the actors within the supply chain. (iv) Based on the above relationships, the last layer proposes a typology of exchanged messages. A communication method, based on XML, is developed that supports optimal exchange/sharing of information. To illustrate the proposed framework system, an example is presented related to collaborative design of a new piston for an automotive engine. The focus is on user-viewpoint integration to ensure that the adequate information is retrieved from the PPCO.', NULL, NULL, '2011-11-10');
INSERT INTO papers (paper_id, title, abstract, doi, journal_ref, update_date) VALUES ('0706.1087', 'On Anomalies in Annotation Systems', 'Today''s computer-based annotation systems implement a wide range of functionalities that often go beyond those available in traditional paper-and-pencil annotations. Conceptually, annotation systems are based on thoroughly investigated psycho-sociological and pedagogical learning theories. They offer a huge diversity of annotation types that can be placed in textual as well as in multimedia format. Additionally, annotations can be published or shared with a group of interested parties via well-organized repositories. Although highly sophisticated annotation systems exist both conceptually as well as technologically, we still observe that their acceptance is somewhat limited. In this paper, we argue that nowadays annotation systems suffer from several fundamental problems that are inherent in the traditional paper-and-pencil annotation paradigm. As a solution, we propose to shift the annotation paradigm for the implementation of annotation system.', NULL, NULL, '2007-06-11');
INSERT INTO papers (paper_id, title, abstract, doi, journal_ref, update_date) VALUES ('0706.1127', 'Redesigning Computer-based Learning Environments: Evaluation as Communication', 'In the field of evaluation research, computer scientists live constantly upon dilemmas and conflicting theories. As evaluation is differently perceived and modeled among educational areas, it is not difficult to become trapped in dilemmas, which reflects an epistemological weakness. Additionally, designing and developing a computer-based learning scenario is not an easy task. Advancing further, with end-users probing the system in realistic settings, is even harder. Computer science research in evaluation faces an immense challenge, having to cope with contributions from several conflicting and controversial research fields. We believe that deep changes must be made in our field if we are to advance beyond the CBT (computer-based training) learning model and to build an adequate epistemology for this challenge. The first task is to relocate our field by building upon recent results from philosophy, psychology, social sciences, and engineering. In this article we locate evaluation in respect to communication studies. Evaluation presupposes a definition of goals to be reached, and we suggest that it is, by many means, a silent communication between teacher and student, peers, and institutional entities. If we accept that evaluation can be viewed as set of invisible rules known by nobody, but somehow understood by everybody, we should add anthropological inquiries to our research toolkit. The paper is organized around some elements of the social communication and how they convey new insights to evaluation research for computer and related scientists. We found some technical limitations and offer discussions on how we relate to technology at same time we establish expectancies and perceive others work.', NULL, NULL, '2007-06-11');

-- Author: Mahya Tazike
-- Sample data for the Authors table
INSERT INTO authors (author_id, last_name, first_name) VALUES (1, 'Prekop', 'Paul');
INSERT INTO authors (author_id, last_name, first_name) VALUES (2, 'Lerman', 'Kristina');
INSERT INTO authors (author_id, last_name, first_name) VALUES (3, 'Plangprasopchok', 'Anon');
INSERT INTO authors (author_id, last_name, first_name) VALUES (4, 'Wong', 'Chio');
INSERT INTO authors (author_id, last_name, first_name) VALUES (5, 'Llobera', 'Joan');
INSERT INTO authors (author_id, last_name, first_name) VALUES (6, 'Woodruff', 'Allison');
INSERT INTO authors (author_id, last_name, first_name) VALUES (7, 'Augustin', 'Sally');
INSERT INTO authors (author_id, last_name, first_name) VALUES (8, 'Foucault', 'Brooke');
INSERT INTO authors (author_id, last_name, first_name) VALUES (9, 'Marshall', 'Catherine C.');
INSERT INTO authors (author_id, last_name, first_name) VALUES (10, 'McCown', 'Frank');
INSERT INTO authors (author_id, last_name, first_name) VALUES (11, 'Nelson', 'Michael L.');
INSERT INTO authors (author_id, last_name, first_name) VALUES (12, 'Bly', 'Sara');
INSERT INTO authors (author_id, last_name, first_name) VALUES (13, 'Brun-Cottan', 'Francoise');
INSERT INTO authors (author_id, last_name, first_name) VALUES (14, 'Jiang', 'Mike Tian-Jian');
INSERT INTO authors (author_id, last_name, first_name) VALUES (15, 'Zhan', 'James');
INSERT INTO authors (author_id, last_name, first_name) VALUES (16, 'Lin', 'Jaimie');
INSERT INTO authors (author_id, last_name, first_name) VALUES (17, 'Lin', 'Jerry');
INSERT INTO authors (author_id, last_name, first_name) VALUES (18, 'Hsu', 'Wen-Lien');
INSERT INTO authors (author_id, last_name, first_name) VALUES (19, 'Liu', 'Deng');
INSERT INTO authors (author_id, last_name, first_name) VALUES (20, 'Hsieh', 'Meng-Juei');
INSERT INTO authors (author_id, last_name, first_name) VALUES (21, 'Lisewski', 'Andreas Martin');
INSERT INTO authors (author_id, last_name, first_name) VALUES (22, 'Henry', 'Nathalie');
INSERT INTO authors (author_id, last_name, first_name) VALUES (23, 'Fekete', 'Jean-Daniel');
INSERT INTO authors (author_id, last_name, first_name) VALUES (24, 'Mcguffin', 'Michael');
INSERT INTO authors (author_id, last_name, first_name) VALUES (25, 'Petiot', 'Jean-François');
INSERT INTO authors (author_id, last_name, first_name) VALUES (26, 'Chablat', 'Damien');
INSERT INTO authors (author_id, last_name, first_name) VALUES (27, 'Lu', 'Chenguang');
INSERT INTO authors (author_id, last_name, first_name) VALUES (28, 'Geryville', 'Hichem');
INSERT INTO authors (author_id, last_name, first_name) VALUES (29, 'Ouzrout', 'Yacine');
INSERT INTO authors (author_id, last_name, first_name) VALUES (30, 'Bouras', 'Abdelaziz');
INSERT INTO authors (author_id, last_name, first_name) VALUES (31, 'Sapidis', 'Nikolaos');
INSERT INTO authors (author_id, last_name, first_name) VALUES (32, 'Brust', 'Matthias R.');
INSERT INTO authors (author_id, last_name, first_name) VALUES (33, 'Rothkugel', 'Steffen');
INSERT INTO authors (author_id, last_name, first_name) VALUES (34, 'Adriano', 'Christian M.');
INSERT INTO authors (author_id, last_name, first_name) VALUES (35, 'Ricarte', 'Ivan M. L.');

-- Author: Mahya Tazike
-- Sample data for the Categories table
INSERT INTO categories (category_id, category_code) VALUES (1, 'cs.OH');
INSERT INTO categories (category_id, category_code) VALUES (2, 'cs.DB');
INSERT INTO categories (category_id, category_code) VALUES (3, 'cs.DL');
INSERT INTO categories (category_id, category_code) VALUES (4, 'cs.HC');
INSERT INTO categories (category_id, category_code) VALUES (5, 'cs.IR');
INSERT INTO categories (category_id, category_code) VALUES (6, 'cs.AI');
INSERT INTO categories (category_id, category_code) VALUES (7, 'cs.CY');
INSERT INTO categories (category_id, category_code) VALUES (8, 'cs.CL');
INSERT INTO categories (category_id, category_code) VALUES (9, 'cs.RO');
INSERT INTO categories (category_id, category_code) VALUES (10, 'cs.IT');
INSERT INTO categories (category_id, category_code) VALUES (11, 'math.IT');

-- Author: Mahya Tazike
-- Sample data for the Paper_Authors junction table
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.1353', 1, 1);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.1676', 2, 1);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.1676', 3, 2);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.1676', 4, 3);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.2542', 5, 1);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.3643', 6, 1);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.3643', 7, 2);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.3643', 8, 3);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.3647', 9, 1);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.3647', 10, 2);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.3647', 11, 3);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.3653', 9, 1);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.3653', 12, 2);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.3653', 13, 3);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.3662', 14, 1);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.3662', 15, 2);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.3662', 16, 3);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.3662', 17, 4);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.3662', 18, 5);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.3665', 14, 1);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.3665', 19, 2);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.3665', 20, 3);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0704.3665', 18, 4);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0705.0025', 21, 1);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0705.0599', 22, 1);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0705.0599', 23, 2);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0705.0599', 24, 3);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0705.1395', 25, 1);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0705.1395', 26, 2);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0705.3644', 27, 1);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0706.0507', 28, 1);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0706.0507', 29, 2);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0706.0507', 30, 3);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0706.0507', 31, 4);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0706.1087', 32, 1);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0706.1087', 33, 2);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0706.1127', 32, 1);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0706.1127', 34, 2);
INSERT INTO paper_authors (paper_id, author_id, author_order) VALUES ('0706.1127', 35, 3);

-- Author: Mahya Tazike
-- Sample data for the Paper_Categories junction table
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0704.1353', 1);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0704.1353', 2);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0704.1353', 3);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0704.1353', 4);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0704.1676', 5);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0704.1676', 6);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0704.1676', 7);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0704.1676', 3);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0704.1676', 4);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0704.2542', 4);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0704.3643', 4);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0704.3647', 3);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0704.3647', 7);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0704.3647', 4);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0704.3653', 3);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0704.3653', 7);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0704.3653', 4);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0704.3662', 4);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0704.3662', 8);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0704.3665', 8);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0704.3665', 4);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0705.0025', 4);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0705.0025', 6);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0705.0599', 4);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0705.1395', 4);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0705.1395', 9);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0705.3644', 10);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0705.3644', 4);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0705.3644', 11);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0706.0507', 4);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0706.1087', 4);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0706.1087', 7);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0706.1127', 7);
INSERT INTO paper_categories (paper_id, category_id) VALUES ('0706.1127', 4);

-- ============================================================
-- PART 3: APPLICATION QUERIES
-- ============================================================


-- Author: Mahya Tazike
-- Query 1: Search papers by a keyword in the title
-- Application functionality: Allows users to search for research papers
-- whose titles contain a specified keyword.

SELECT
    paper_id,
    title,
    update_date
FROM papers
WHERE title LIKE '%virtual%'
ORDER BY update_date DESC;


-- Author: Mahya Tazike
-- Query 2: Search papers by author name
-- Application functionality: Allows users to find all papers
-- written by a specified author.

SELECT
    a.first_name,
    a.last_name,
    p.paper_id,
    p.title,
    p.update_date
FROM papers p
JOIN paper_authors pa
    ON p.paper_id = pa.paper_id
JOIN authors a
    ON pa.author_id = a.author_id
WHERE a.last_name LIKE '%Marshall%'
ORDER BY p.update_date DESC;


-- Author: Mahya Tazike
-- Query 3: Search papers by category
-- Application functionality: Allows users to browse all papers
-- assigned to a specified subject category.

SELECT
    c.category_code,
    p.paper_id,
    p.title,
    p.update_date
FROM papers p
JOIN paper_categories pc
    ON p.paper_id = pc.paper_id
JOIN categories c
    ON pc.category_id = c.category_id
WHERE c.category_code = 'cs.HC'
ORDER BY p.update_date DESC;


-- Author: Mahya Tazike
-- Query 4: Retrieve papers by year of last update
-- Application functionality: Allows users to browse papers
-- by the year of their last update.

SELECT
    paper_id,
    title,
    update_date
FROM papers
WHERE YEAR(update_date) = 2007
ORDER BY update_date ASC;


-- Author: Mahya Tazike
-- Query 5: Publication trend over time
-- Application functionality: Powers a visualization showing how many
-- HCI papers were updated in each year, revealing growth trends
-- in the field over time.

SELECT
    YEAR(update_date) AS year,
    COUNT(*) AS paper_count
FROM papers
GROUP BY YEAR(update_date)
ORDER BY year;


-- Author: Mahya Tazike
-- Query 6: Top authors by number of papers
-- Application functionality: Powers a "most active researchers" view,
-- helping users identify who publishes most frequently in HCI.

SELECT
    a.first_name,
    a.last_name,
    COUNT(*) AS paper_count
FROM authors a
JOIN paper_authors pa ON a.author_id = pa.author_id
GROUP BY a.author_id, a.first_name, a.last_name
ORDER BY paper_count DESC, a.last_name ASC, a.first_name ASC
LIMIT 10;
