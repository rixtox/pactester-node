module.exports =
  dnsDomainIs: (host, domain) ->
    host.length >= domain.length and host.substring(host.length - domain.length) is domain
  dnsDomainLevels: (host) ->
    host.split('.').length - 1
  convert_addr: (ipchars) ->
    bytes = ipchars.split('.')
    return ((bytes[0] & 0xff) << 24) | ((bytes[1] & 0xff) << 16) | ((bytes[2] & 0xff) << 8) | (bytes[3] & 0xff)
  isInNet: (ipaddr, pattern, maskstr) ->
    test = /^\b(?:\d{1,3}\.){3}\d{1,3}\b$/.test ipaddr
    unless test?
      ipaddr = dnsResolve(ipaddr)
      return false  if ipaddr is 'null'
    else return false  if test[1] > 255 or test[2] > 255 or test[3] > 255 or test[4] > 255 # not an IP address
    host = convert_addr(ipaddr)
    pat = convert_addr(pattern)
    mask = convert_addr(maskstr)
    (host & mask) is (pat & mask)
  isPlainHostName: (host) ->
    host.search('\\.') is -1
  isResolvable: (host) ->
    ip = dnsResolve(host)
    ip isnt 'null'
  localHostOrDomainIs: (host, hostdom) ->
    (host is hostdom) or (hostdom.lastIndexOf(host + '.', 0) is 0)
  shExpMatch: (url, pattern) ->
    pattern = pattern.replace(/\./g, '\\.')
    pattern = pattern.replace(/\*/g, '.*')
    pattern = pattern.replace(/\?/g, '.')
    newRe = new RegExp('^' + pattern + '$')
    newRe.test url
  weekdayRange: ->
    getDay = (weekday) ->
      i = 0
      while i < 6
        return i  if weekday is wdays[i]
        i++
      -1
    date = new Date()
    argc = arguments.length
    wday = undefined
    return false  if argc < 1
    if arguments[argc - 1] is 'GMT'
      argc--
      wday = date.getUTCDay()
    else
      wday = date.getDay()
    wd1 = getDay(arguments[0])
    wd2 = (if (argc is 2) then getDay(arguments[1]) else wd1)
    (if (wd1 is -1 or wd2 is -1) then false else (wd1 <= wday and wday <= wd2))
  dateRange: ->
    getMonth = (name) ->
      i = 0

      while i < 6
        return i  if name is monthes[i]
        i++
      -1
    date = new Date()
    argc = arguments.length
    return false  if argc < 1
    isGMT = (arguments[argc - 1] is 'GMT')
    argc--  if isGMT
    
    # function will work even without explict handling of this case
    if argc is 1
      tmp = parseInt(arguments[0])
      if isNaN(tmp)
        return (((if isGMT then date.getUTCMonth() else date.getMonth())) is getMonth(arguments[0]))
      else if tmp < 32
        return (((if isGMT then date.getUTCDate() else date.getDate())) is tmp)
      else
        return (((if isGMT then date.getUTCFullYear() else date.getFullYear())) is tmp)
    year = date.getFullYear()
    date1 = undefined
    date2 = undefined
    date1 = new Date(year, 0, 1, 0, 0, 0)
    date2 = new Date(year, 11, 31, 23, 59, 59)
    adjustMonth = false
    i = 0

    while i < (argc >> 1)
      tmp = parseInt(arguments[i])
      if isNaN(tmp)
        mon = getMonth(arguments[i])
        date1.setMonth mon
      else if tmp < 32
        adjustMonth = (argc <= 2)
        date1.setDate tmp
      else
        date1.setFullYear tmp
      i++
    i = (argc >> 1)

    while i < argc
      tmp = parseInt(arguments[i])
      if isNaN(tmp)
        mon = getMonth(arguments[i])
        date2.setMonth mon
      else if tmp < 32
        date2.setDate tmp
      else
        date2.setFullYear tmp
      i++
    if adjustMonth
      date1.setMonth date.getMonth()
      date2.setMonth date.getMonth()
    if isGMT
      tmp = date
      tmp.setFullYear date.getUTCFullYear()
      tmp.setMonth date.getUTCMonth()
      tmp.setDate date.getUTCDate()
      tmp.setHours date.getUTCHours()
      tmp.setMinutes date.getUTCMinutes()
      tmp.setSeconds date.getUTCSeconds()
      date = tmp
    (date1 <= date) and (date <= date2)
  timeRange: ->
    argc = arguments.length
    date = new Date()
    isGMT = false
    return false  if argc < 1
    if arguments[argc - 1] is 'GMT'
      isGMT = true
      argc--
    hour = (if isGMT then date.getUTCHours() else date.getHours())
    date1 = undefined
    date2 = undefined
    date1 = new Date()
    date2 = new Date()
    if argc is 1
      return (hour is arguments[0])
    else if argc is 2
      return ((arguments[0] <= hour) and (hour <= arguments[1]))
    else
      switch argc
        when 6
          date1.setSeconds arguments[2]
          date2.setSeconds arguments[5]
        when 4
          middle = argc >> 1
          date1.setHours arguments[0]
          date1.setMinutes arguments[1]
          date2.setHours arguments[middle]
          date2.setMinutes arguments[middle + 1]
          date2.setSeconds 59  if middle is 2
        else
          throw 'timeRange: bad number of arguments'
    if isGMT
      date.setFullYear date.getUTCFullYear()
      date.setMonth date.getUTCMonth()
      date.setDate date.getUTCDate()
      date.setHours date.getUTCHours()
      date.setMinutes date.getUTCMinutes()
      date.setSeconds date.getUTCSeconds()
    (date1 <= date) and (date <= date2)
  wdays: new Array('SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT')
  monthes: new Array('JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC')