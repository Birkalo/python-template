#!/usr/bin/env python3.10

import pymysql


def create_tables():
    db = pymysql.connect(host="localhost", user="usernameall", password="password", database="pythonProject")
    cursor = db.cursor()

    try:
        create_template_table(cursor)
        db.commit()
    except pymysql.err.ProgrammingError:
        db.rollback()
    db.close()


def create_template_table(cursor):

    drop_template_table = """DROP TABLE IF EXISTS TEMPLATE"""
    cursor.execute(drop_template_table)

    create_template_table_sql = """CREATE TABLE TEMPLATE (
        ID INT NOT NULL,
        NAME  CHAR(20),
        PRIMARY KEY (ID))""".strip()
    cursor.execute(create_template_table_sql)
