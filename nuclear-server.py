from bottle import route, static_file, run, response
from nuclear_utils import *
import sqlite3

db_path = 'data/nuclear.db'

@route('/static/<filename:path>')
def send_static(filename):
    return static_file(filename, root='static/')

@route('/api/tai-vs-aec/<start:int>/<end:int>')
def tai_vs_aec(start, end):
    with sqlite3.connect(db_path) as conn:
        entries = {}
        for row in conn.execute('SELECT * FROM nuclear WHERE ? <= t AND t < ?', [start, end]):
            t = row[0]
            powerset = {
                'planet'  : row[1],
                'powerset': row[2],
                'capacity': row[3],
                'tai'     : row[4],
                'aec'     : row[5],
            }
            if t in entries:
                entries[t].append(powerset)
            else:
                entries[t] = [ powerset ]
        results = { 'data': [] }
        for t in sorted(entries.keys()):
            result = { 't': t, 'powersets': [] }
            for p in entries[t]:
                result['powersets'].append(p)
            results['data'].append(result)
        response.set_header('Content-Type', 'application/json')
        return results

run(host='localhost', port=8080, debug=True, reloader=True)

