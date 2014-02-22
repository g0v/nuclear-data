import os, sys, time, datetime
import subprocess
import logging, logging.handlers
import simplejson
import sqlite3

# http://stackoverflow.com/questions/6999726/python-getting-millis-since-epoch-from-datetime/11111177#11111177
def unix_time(dt):
    epoch = datetime.datetime.utcfromtimestamp(0)
    delta = dt - epoch
    return int(delta.total_seconds())

def runcmd(cmds, cwd=None, wait=True):
    _PIPE = subprocess.PIPE
    try:
        p = subprocess.Popen(cmds, stdin=_PIPE, stdout=_PIPE, stderr=_PIPE, cwd=cwd, shell=True)
#        p.wait()
        if wait:
            (stdout, stderr) = p.communicate()
            return (stdout, stderr)
#        print 'run ==> %s <=='%cmds
#        print 'err ==> ', stderr, '\nout ==> ', stdout

#        if p.returncode:
#            print 'retcode=%d, err=%s'%(p.returncode, stderr)
#            raise
#        else:
#        return (stdout, stderr)
    except OSError, e:
        print sys.stderr, "Execution failed:", e

def setup(db_path):
    with sqlite3.connect(db_path) as conn:
        conn.text_factory = str
        conn.execute('''
CREATE TABLE nuclear
(
    t               INTEGER NOT NULL,
    planet          TEXT    NOT NULL,
    powerset        TEXT    NOT NULL,
    capacity        REAL    NOT NULL,
    generating_tai  REAL    NOT NULL,
    generating_aec  REAL    NOT NULL 
)
        ''')
        conn.commit()

def mainloop(db_path, interval):
    with sqlite3.connect(db_path) as conn:

        while True:
            res = runcmd("curl http://gamma.aec.gov.tw/spds/bottom.asp")[0]
            #print res
            out = {}
            item = ['N11RATEID', 'N11GENID', 'N12RATEID', 'N12GENID',
                    'N21RATEID', 'N21GENID', 'N22RATEID', 'N22GENID',
                    'N31RATEID', 'N31GENID', 'N32RATEID', 'N32GENID']
            index = 0
            now = datetime.datetime.now()
            print now
            for l in res.splitlines():
                if l.find('%s").value' % item[index]) >= 0:
                    #print l.strip().split()[-1].split('"')[1]
                    out[item[index]] = l.strip().split()[-1].split('"')[1]
                    index += 1
                    if index >= len(item):
                        break
                #break
            #print out
            
            res = runcmd("curl http://g0v-data-mirror.gugod.org/taipower/generators.json")[0]
            #print res
            jdata = simplejson.loads(res)
            #print jdata[0], jdata[1]
            #print jdata[0]['device'], jdata[0]['capacity'], jdata['generating'], out['N11GENID']

            entry = { 't': unix_time(now), 'powersets': [] }
            print entry
            for i in range(6):
                powerset = {
                    'planet'  : jdata[i]['device'].split('#')[0],
                    'powerset': jdata[i]['device'].split('#')[1],
                    'capacity': float(jdata[i]['capacity']),
                    'tai'     : float(jdata[i]['generating']),
                    'aec'     : float(out[item[i*2+1]]),
                }
                entry['powersets'].append(powerset)
                print '%s(%s): %8.2f vs. %8.2f / %8.2f' % (powerset['planet'], powerset['powerset'], powerset['tai'],    powerset['aec'], powerset['capacity'])
                conn.execute('INSERT INTO nuclear VALUES (?, ?, ?, ?, ?, ?)', [entry['t'], powerset['planet'], powerset['powerset'], powerset['capacity'], powerset['tai'], powerset['aec']])
                conn.commit()
#           print entry
            print '=='

            time.sleep(float(interval))

if __name__ == '__main__':
    if len(sys.argv) == 3:
        setup(sys.argv[1])
        mainloop(sys.argv[1], sys.argv[2])
    else:
        print 'Usage: %s <db-file> <interval-secs>' % (sys.argv[0])

