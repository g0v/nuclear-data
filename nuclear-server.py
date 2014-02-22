from bottle import route, static_file, run

@route('/static/<filename:path>')
def send_static(filename):
    return static_file(filename, root='static/')

run(host='localhost', port=8080, debug=True, reloader=True)

