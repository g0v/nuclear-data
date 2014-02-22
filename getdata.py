import os, sys, time, datetime
import subprocess
import logging, logging.handlers
import simplejson

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

while True:
    res = runcmd("curl http://gamma.aec.gov.tw/spds/bottom.asp")[0]
    #print res
    out = {}
    item = ['N11RATEID', 'N11GENID', 'N12RATEID', 'N12GENID', 'N21RATEID', 'N21GENID', 'N22RATEID', 'N22GENID', 'N31RATEID', 'N31GENID', 'N32RATEID', 'N32GENID']
    index = 0
    print datetime.datetime.now()
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
    print '%s,%s,%s,%s' % (jdata[0]['device'], jdata[0]['capacity'], jdata[0]['generating'], out['N11GENID'])
    print '%s,%s,%s,%s' % (jdata[1]['device'], jdata[1]['capacity'], jdata[1]['generating'], out['N12GENID'])
    print '%s,%s,%s,%s' % (jdata[2]['device'], jdata[2]['capacity'], jdata[2]['generating'], out['N21GENID'])
    print '%s,%s,%s,%s' % (jdata[3]['device'], jdata[3]['capacity'], jdata[3]['generating'], out['N22GENID'])
    print '%s,%s,%s,%s' % (jdata[4]['device'], jdata[4]['capacity'], jdata[4]['generating'], out['N31GENID'])
    print '%s,%s,%s,%s' % (jdata[5]['device'], jdata[5]['capacity'], jdata[5]['generating'], out['N32GENID'])
    print '=='
    time.sleep(300)
