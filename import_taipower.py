import csv
import sys
import datetime
import sqlite3

def import_taipower(db_path, csv_path):
    with sqlite3.connect(db_path) as conn:
        conn.text_factory = str
        conn.execute('''
CREATE TABLE taipower
(
    t           INTEGER     NOT NULL,
    planet      TEXT        NOT NULL,
    powerset    TEXT        NOT NULL,
    generating  INTEGER     NOT NULL,
    capacity    INTEGER     NOT NULL
)
        ''')
        conn.commit()

        with open(csv_path, 'rb') as csv_file:
            csv_reader = csv.reader(csv_file, delimiter=',', quotechar='"')
            for row in csv_reader:
                category    = row[0]
                planet      = row[1].split('#')[0]
                powerset    = row[1].split('#')[1]
                timestamp   = datetime.datetime.strptime(row[2], '%Y-%m-%d %H:%M:%S')
                capacity    = row[3]
                generating  = row[4]

                conn.execute('INSERT INTO taipower VALUES (?, ?, ?, ?, ?)',
                             [timestamp, planet, powerset, generating, capacity])
                conn.commit()
                sys.stderr.write('.')

if __name__ == '__main__':
    if len(sys.argv) == 3:
        import_taipower(sys.argv[1], sys.argv[2])
    else:
        print 'Usage: %s <csv-file> <db-file>' % (sys.argv[0])


