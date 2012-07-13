#!/usr/bin/env python
# -*- coding: utf-8 -*-
################################################################################
#
# noisetorbot.py
# --------------
# Connects to an IRC channel and does the following things:
#     * Logs all messages and actions to a file
#     * Queries the Tor Project's Onionoo REST API for statistics on Tor nodes
#     * Pushes query responses to the IRC channel
#     * Barfs info-anarchist propaganda at anyone who tries to talk to the bot
#
# @author Isis Agora Lovecruft, 0x2cdb8b35
# @version 0.0.1
#_______________________________________________________________________________
# Changelog:
# ----------
# v0.0.1: First commit.
################################################################################

import chardet
import json
import os
import random
import textwrap
import time
import sys

from pprint import pformat, pprint

try:
    from twisted.application import internet, service
    from twisted.internet import reactor, protocol
    from twisted.internet.defer import Deferred
    from twisted.internet.error import DNSLookupError
    from twisted.internet.protocol import Protocol
    from twisted.internet.ssl import ClientContextFactory, Client
    from twisted.python import log
    from twisted.python.log import err
    from twisted.web.client import Agent, RedirectAgent
    from twisted.web.http_headers import Headers
    from twisted.words.protocols import irc
except:
    print "Please install Twisted: $ sudo apt-get install python-twisted"

try:
    from BeautifulSoup import UnicodeDammit
except:
    print "Install BeautifulSoup: https://crate.io/packages/BeautifulSoup/"

try:
    import simplejson
except:
    print "Please install simplejson: https://crate.io/packages/simplejson/"


class MessageLogger:
    """
    Keeps a log of actions and messages in the channel so we can work out 
    problems later.
    """
    def __init__(self, file):
        self.file = file

    def log(self, message):
        """
        Logs are kept in UTC, because fuck being fingerprinted on something
        so trite as a timezone. If you want timestamps localized to the
        server with the running instance of the bot, then change 'time.gmtime()'
        to 'time.localtime()'.
        """
        timestamp = time.strftime("[%H:%M:%S]", time.gmtime(time.time()))
        self.file.write('%s %s\n' % (timestamp, message))
        self.file.flush()

    def close(self):
        self.file.close()

class OnionooClientContextFactory(ClientContextFactory):
    """
    Creates a context for Agent, in order to process SSL connections.
    """
    def getContext(self, hostname, port):
        return ClientContextFactory.getContext(self)

class NoiseTorBot(irc.IRCClient):
    """
    I help people in IRC learn about Tor nodes!
    """
    def __init__(self, nickname):
        self.nickname = "panopticon"
        self.lineRate = 1
        self.heartbeatInterval = 120
        self.fingerReply = "I'm a Tor node statistics bot, run by Isis Agora Lovecruft"
        ## XXX add github source
        self.sourceURL = ""

        self.raw_headers = None
        self.respect_caching_protocol = False
        self.query = None
        self.onionoo = None

        self.diced = textwrap.TextWrapper(width=400, break_long_words=True)

    def makeQuote(self):
        """
        Says one of the following quotes at random.
        """
        quotes = []
        quotes.append("Et sans doute notre temps... préfère l'image à"
                      +" la chose, la copie à l'original, la "
                      +"représentation à la réalité, l'apparence à"
                      +" l'être...")
        quotes.append("Quis custodiet ipsos custodes?")
        quotes.append("Some would claim that complete societal "
                      +"transparency or equiveillance would produce, "
                      +"by homogenesis, a balance of power between the"
                      +" watched and the watchers. That is false. In "
                      +"such a world, one merely loses the ability to"
                      +" openly challenge such power.")
        quotes.append("Panopticism is the general principle of a new "
                      +"'political anatomy' whose object and end are "
                      +"not the relations of sovereignty but the "
                      +"relations of discipline. The celebrated, "
                      +"transparent, circular cage, with its high "
                      +"towers powerful and knowing, may have been..."
                      +"a project of perfect disciplinary institution...")
        return random.choice(quotes)

    def connectionMade(self):
        global log

        irc.IRCClient.connectionMade(self)
        self.logger = MessageLogger(open(self.factory.filename, "a"))
        log = self.logger.log
        log("[connected at %s]" %
            time.asctime(time.localtime(time.time())))

    def connectionLost(self, reason):
        irc.IRCClient.connectionLost(self, reason)
        log("[disconnected at %s]" %
            time.asctime(time.localtime(time.time())))
        self.logger.close()

    def signedOn(self):
        """
        Called when the bot signs on. Derp.
        """
        self.join(self.factory.channel)

    def joined(self, channel):
        """
        Called when the bot joins the channel.
        """
        log("[I have joined %s]" % channel)

    def __create_URL__(self, query):
        """
        Turns an IRC query such as 'node details noise' into the 
        correct URL for the Onionoo API.
        """
        database = 'http://onionoo.torproject.org/'

        if query.startswith('details'):
            url = database + "details?search=" + str(query[8:])
        elif query.startswith('bandwidth'):
            url = database + "bandwidth?search=" + str(query[10:])
        elif query.startswith('summary'):
            url = database + "summary?search=" + str(query[8:])
        else:
            log(err)
        return url

    def createOnionooHeaders(self):
        """
        Method to analyze response.headers and grep for Last-Modified 
        time, for use in self.headers['If-Modified-Since'].
        """
        headers = {'User-Agent': 
                   ['Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20100101 Firefox/12.0'],
                   'Accept-Encoding':
                   ['gzip', 'deflate'],
                   'Accept':
                   ['application/json; charset=utf-8']}

        if self.respect_caching_protocol:

            if self.raw_headers is not None:
                last_modified = str(self.raw_headers[2]).split('[')[1].split(']')[0]
                headers['If-Modified-Since'] = list(last_modified)

        return headers

    def onionooCallback(self, response):
        self.raw_headers = list(response.headers.getAllRawHeaders())
        rh = pformat(self.raw_headers)

        #print 'Response Version: ', response.version
        #print 'Response Code: ', response.code
        #print 'Response Phrase: ', response.phrase
        #print 'Response Headers: ', rh

        class PrintToIRC(Protocol):
            """
            IRC is the new green.
            """
            def __init__(self, finished):
                self.finished = finished
                self.remaining = 1024 * 100

            def dataReceived(self, bytes):
                global onion
                onion = bytearray()
                if self.remaining:
                    data = bytes[:self.remaining]
                    onion.write(data)
                    self.remaining -= len(data)
                else:
                    ## kludgey, but we need it or else the file could stay open
                    ## while the deferred gets passed on...
                    onion.__exit__(None, None, None)

            def connectionLost(self, reason):
                print "Finished receiving JSON object: ", reason.getErrorMessage()
                self.finished.callback(None)
                #self.finished.callback(p.factory.client.onionooPaste)

        finished = Deferred()
        response.deliverBody(PrintToIRC(finished))
        return finished

    def onionooQuery(self, query_message, msg, channel):
        """
        Ask Onionoo about a specific Tor Relay.
        """
        if not query_message:
            query_message='summary noise'

        query_url = self.__create_URL__(query_message)

        def __ssl_request__(query_url):
            headers = self.createOnionooHeaders()
            contextFactory = OnionooClientContextFactory()
            agent = RedirectAgent(Agent(reactor, contextFactory))
            d = agent.request(
                'GET',
                str(query_url),
                Headers(headers),
                None)
            d.addCallback(self.onionooCallback)
            d.addErrback(err)
            d.addCallback(self.onionooPaste, msg, channel)
            d.addErrback(err)
            return d
            
        __ssl_request__(query_url)

    def onionooParseSummaryGeneric(node):
        try:
            n = node['n']
            if node['r'] == 'True':
                r = ' is running.'
            else:
                r = ' is not running.'
            return str(n), str(r)
        except:
            log("Error in onionooParseSummaryGeneric(%s)" % node)
            return None, None

    def onionooParseSummaryRelay(relay):
        try:
            f = relay['f']
            addrs = relay['a']
            a = ''
            for addr in addrs:
                a = a + addr + ' '
            return str(a), str(f)
        except:
            log("Error in onionooParseSummaryRelay(%s)" % relay)
            return None, None

    def onionooParseSummaryBridge(bridge):
        try:
            h = bridge['h']
            return h
        except:
            log("Error in onionooParseSummaryRelay(%s)" % bridge)
            return None            

    def onionooParseSummary(self, leek, msg, channel):
        print type(leek)
        if type(leek) is dict:
            print "IS DICT"
            if leek.has_key(u'relays'):
                print "HAS KEY RELAYS"
                relays = leek[u'relays']
                print "OH YEAH RELAYS"
                for relay in relays:
                    n, r = self.onionooParseSummayGeneric(relay)
                    print "DID THE GENERIC SUMMARY"
                    a, f = self.onionooParseSummaryRelay(relay)
                    print "DID THE RELAY SUMMARY"
                    if a and f and n and r is not None:
                        "A & F & N & R IS NOT NONE!"
                        i = "Relay " + n + " with fingerprint " + f + \
                            " at " + a + r
                        self.msg(channel, i)
                        return finished
                    else:
                        i = "Unable to parse some relay info..."
                        for x in (a, f, n, r): 
                            if x is not None:
                                i = i + x + " "
                        self.msg(channel, i)
                        log("%s %s %s %s %s" % (i, a, f, n, r))
                        return finished
            else:
                i = "I didn't find any relays matching query " + str(msg)
                self.msg(channel, i)
                log("%s" % i)
                return finished

            if leek.has_key(u'bridges'):
                bridges = leek[u'bridges']
                for bridge in bridges:
                    n, r = self.onionooParseSummayGeneric(bridge)
                    h = self.onionooParseSummaryBridge(bridge)
                    if h and n and r is not None:
                        i = "Bridge " + n + " with hashed fingerprint " + h + r
                        self.msg(channel, i)
                        return finished
                    else:
                        i = "Unable to parse some bridge info..."
                        for x in (h, n, r): 
                            if x is not None:
                                i = i + x + " "
                        self.msg(channel, i)
                        log("%s %s %s %s" % (i, h, n, r))
                        return finished
            else:
                i = "I didn't find any bridges matching query " + str(msg)
                self.msg(channel, i)
                log("%s" % i)
                return finished
        else:
            print "I'M NOT A FUCKING DICT!"

    def onionooPaste(self, finished, msg, channel):
        """
        Post the JSON object to IRC in a prettier format.
        """
        with open(".onionoo.json") as onion:
            #for onion in oOoOo:
            leeks = simplejson.loads('%s' % onion)
            print leeks
            for leek in leeks:
                if 'node summary' in msg:
                    #finished.addCallback(self.onionooParseSummary(leek, msg,
                    #                                              channel))
                    #finished.addErrback(err)
            #onion.seek(0)
            #finished.addCallback(self.onionooCleanup)

                    self.onionooParseSummary(leek, msg, channel)

            oOoOo.seek(0)
            self.onionooCleanup

                    #if type(leek) is dict: 
                    #    if leek.has_key(u'relays'):
                    #        relays = leek[u'relays']
                    #        for relay in relays:
                                #try:
                                #    name = relay['n']
                                #    fgpr = relay['f']
                                #    addrs = relay['a']
                                #    a = ''
                                #    for addr in addrs:
                                #        a = a + addr + ' '
                                #
                                #    if relay['r'] == 'True':
                                #        running = " is running."
                                #    else:
                                #        running = " is not running."
                                #
                                #    info = "Relay " + str(name) + \
                                #        " with fingerprint " + str(fgpr) + \
                                #        " at " + str(a) + running
                                #except:
                                #    info = "Unable to parse some relay information..."
                                #self.msg(channel, info)

                        #if leek.has_key(u'bridges'):
                        #    bridges = leek[u'bridges']
                        #    for bridge in bridges:
                        #        try:
                        #            name = bridge['n']
                        #            hsh = bridge['h']
                        #
                        #            if bridge['r'] == 'True':
                        #                running = " is running."
                        #            else:
                        #                running = " is not running."
                        #
                        #
                        #            info = "Bridge " + str(name) + \
                        #                " with hashed fingerprint " + str(hsh) + \
                        #        running
                        #        except:
                        #            info = "Unable to parse some bridge information..."
                        #            print name, fgpr, addr, running

                        #        print channel, msg, info

                        #        self.msg(channel, info)

            #else:    
            #    chopped_leeks = self.diced.wrap(leek)
            #    for pieces in chopped_leeks:
            #        self.msg(channel, str(pieces))

            #onion.seek(0)

            #onion.close()

        #self.onionooCleanup()

    def onionooCleanup(self):
        with open(".onionoo.json", "w") as chive:
            chive.truncate()

    def privmsg(self, user, channel, msg):
        """
        Try to discourage other nicks from querying the bot.
        """
        self._channel = channel

        user = user.split('!', 1)[0]
        log("<%s> %s" % (user, msg))
        heard_before = False

        if channel == self.nickname:
            if not heard_before:
                speak = "Why are you whispering?"
                self.msg(user, speak)
                heard_before = True
                return
            else:
                speak = self.makeQuote()
                self.msg(user, speak)
                return

        if msg.startswith(self.nickname + ":"):
            speak = "%s: %s" % (user, self.makeQuote()) 
            self.msg(channel, speak)
            log("<%s> %s" % (self.nickname, speak))
            
            if 'node details' or 'node bandwidth' or 'node summary' in msg:
                self.query = msg[5:]

        elif 'node details' or 'node bandwidth' or 'node summary' in msg:
            self.query = msg[5:]

        else:
            log("%s said '%s', which did not include a stats cmd."
                            % (user, msg))

        if self.query is not None:
            self.onionooQuery(self.query, msg, channel)
            self.query = None

    def action(self, user, channel, msg):
        """
        When someone else does an action.
        """
        user = user.split("!", 1)[0]
        log("* %s %s" % (user, msg))

    def irc_NICK(self, prefix, params):
        """
        Called when an IRC user changes their nick.
        """
        old_nick = prefix.split('!')[0]
        new_nick = params[0]
        log("%s is now known as %s" % (old_nick, new_nick))

class NoiseTorBotFactory(protocol.ClientFactory):
    """
    An factory for NoiseTorBots. A new protocol instance is created each time
    a connection is made to the server.
    """    
    def __init__(self, nickname, channel, filename):
        self.nickname = nickname
        self.channel = channel
        self.filename = filename
        self.noisy = False

    def buildProtocol(self, addr):
        p = NoiseTorBot(nickname)
        p.factory = self
        return p

    def clientConnectionLost(self, connection, reason):
        """
        If we get disconnected, reconnect to server.
        """
        connection.connect()

    def clientConnectionFailed(self, connector, reason):
        print "Connection failed: ", pprint(reason)
        reactor.stop()
    
if __name__ == "__main__":
    log.startLogging(sys.stdout)

    nickname   = "0n10no0b0t"
    server     = "irc.freenode.net"
    port       = 6667
    channel    = "#torstats"
    irclogfile = str("torbot-" 
                     + time.strftime("%Y-%m-%d", time.gmtime(time.time()))
                     + ".log")

    counter        = 0
    while os.path.isfile(os.path.abspath(irclogfile)):
        counter   += 1
        irclogfile = irclogfile + "." + str(counter)
                     

    noiseBot = NoiseTorBotFactory(nickname, channel, irclogfile)

    print "Connecting to %s:%s" % (server, port)
    reactor.connectTCP(server, port, noiseBot)
    reactor.run()

'''
log.startLogging(sys.stdout)

botService = service.MultiService()
noiseBot = NoisetorBotFactory(sys.argv[1], sys.argv[1])
internet.TCPClient("irc.freenode.net", 6667, noiseBot).setServiceParent(botService)
onionooMachine = onionooFactory()
internet.TCPClient("port", onionooMachine).setServiceParent(botService)

## Create application
application = service.Application("NoiseTor Bot")

## Connect the MultiService to the application
botService.setServiceParent(application)
'''
