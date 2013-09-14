pactester-node
==============

A Node.js proxy.pac tester written in CoffeeScript. 
You don't need to install SpiderMonkey stuff anymore.

1.  Install NPM packages

    npm install

2.  Edit or replace the proxy.pac file for your use

3.  Run the tester

    coffee run.coffee proxy.pac -u http://www.google
    .com/ -h www.google.com
