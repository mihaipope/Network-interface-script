import ipaddr
import sys

def check():
	try:
		ip = ipaddr.IPAddress(sys.argv[1])
		return 0
	except:
		sys.exit(100)

check()