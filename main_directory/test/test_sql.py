import unittest
import pymysql
import os
from main_directory.initialise_tables import create_template_table

host_environment = "localhost"
db_user = "usernameall"
test_environment = os.getenv("TEST_ENVIRONMENT")

if test_environment == "gitlab":
    host_environment = "docker"


class MyTestCase(unittest.TestCase):
    db = pymysql.connect(host=host_environment, port=3306, user=db_user, password="password", database="pythonProjectTest")
    cursor = db.cursor()

    def test_create_tables(self):
        create_template_table(self.cursor)
        self.db.commit()

        check_tables_sql = "SHOW TABLES"
        self.cursor.execute(check_tables_sql)
        result = self.cursor.fetchall()

        self.assertEqual(len(result), 1)
