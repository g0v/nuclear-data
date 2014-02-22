import sys
import datetime

def _timedelta_total_seconds(td):
	if sys.version_info < (2, 7):
		return (td.microseconds + (td.seconds + td.days * 24 * 3600) * 10**6) / 10**6
	else:
		return td.total_seconds()

# http://stackoverflow.com/questions/6999726/python-getting-millis-since-epoch-from-datetime/11111177#11111177
def unix_time(dt):
    epoch = datetime.datetime.utcfromtimestamp(0)
    delta = dt - epoch
    return int(_timedelta_total_seconds(delta))

