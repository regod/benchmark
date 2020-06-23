# -*- coding: UTF-8 -*-
import re
import subprocess
import tablib
import time

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

cmd_fmt = 'ab -k -c {currency} -n {requests} %s'


def benchmark_one_url(url, ab_fmt):
    url_name = url.split('?')[0]
    print 'begin %s' % url_name
    cmd = ab_fmt % (url)
    ret = subprocess.check_output(cmd.split())
    print ret
    pattern = re.compile(r'Requests per second:\s+([.0-9]*)\[?.*\nTime per request:\s+([.0-9]*)\[?')
    matches = pattern.findall(ret)
    if matches:
        qps, tpr = matches[0]
    else:
        qps, tpr = '-', '-'
    return url_name, qps, tpr


def benchmark(urls):
    t = tablib.Dataset()
    t.headers = ['url地址', '请求数/秒', '毫秒/请求']
    c = cmd_fmt.format(currency=100, requests=10000)
    for url in urls:
        url_name, qps, tpr = benchmark_one_url(url, c)
        print url_name, qps, tpr
        t.append([url_name, qps, tpr])
        idle_time = 5
        print 'time sleep %s' % idle_time
        time.sleep(idle_time)
    print t


def main():
    urls = []
    for line in open('/tmp/benchmark_urls.txt'):
        urls.append(line.strip())
    benchmark(urls)


if __name__ == '__main__':
    main()
