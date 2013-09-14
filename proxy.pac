function FindProxyForURL(url, host) {
  // Default Proxy
  var defaultProxy = 'SOCKS5 192.168.1.119:7070',

  // Shell Expression Filters
  whiteList = [
    /^\b(?:\d{1,3}\.){3}\d{1,3}\b$/ // IP address
    , 'osu.uu.gl'
    , '220.181.136.50:8000'
    , 'log.v.iask.com'
  ],

  // Match Any Sub-domains
  whiteHosts = [
    'baidu'
    , 'sina'
    , 'weibo'
    , 'bilibili.tv'
    , 'zhihu.com'
    , 'tudou.com'
    , 'youku.com'
    , 'iqiyi.com'
    , 'xiami.com'
    , 'taobao.com'
    , 'alipay.com'
    , 'bloodcat.com'
    , 'google.as'
    , 'bgy.gd.cn'
    , 'dirpy.com'
    , 'qq'
    , '126'
    , '163'
    , '139'
    , '10000'
    , '10010'
    , '115'
    , 'dnspod.cn'
    , 'yinyuetai'
    , 'battlenet.com.cn'
    , 'amazon.cn'
    , 'sinajs.cn'
  ];

  for (var i in whiteList) {
    var rule = whiteList[i];
    if (typeof rule == 'string') {
      if (shExpMatch(host, rule)) {
        return 'DIRECT';
      }
    }
    if (rule instanceof RegExp) {
      if (rule.test(host)) {
        return 'DIRECT';
      }
    }
  }

  for (var i in whiteHosts) {
    var rule = whiteHosts[i];
    if (rule.indexOf('.') < 0) {
      rule = new RegExp('^([^\.]+\.)*' + rule + '(\.[^\.]{2,})+$');
    } else {
      rule = new RegExp('^([^\.]+\.)*' + rule + '$');
    }
    if (rule.test(host)) {
      return 'DIRECT';
    }
  }

  if (isPlainHostName(host)) {
    return 'DIRECT';
  }

  return defaultProxy;
}