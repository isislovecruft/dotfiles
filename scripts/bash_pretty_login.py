#!/usr/bin/env python
# -*- coding: utf-8 -*-
##############################################################################
# bash_pretty_login
# -----------------------
# Makes a pretty!
# Tells a story written by an AI!
#
# @author Isis Agora Lovecruft, 0x2cdb8b35
# @version 0.0.2
# @date 28 June 2012
#_____________________________________________________________________________
# Changelog:
# ----------
# v0.0.2: More nonsense from the geo-kaepora script.
# v0.0.1: Blah blah ascii art nonsense.
#       
##############################################################################

from os import path
from random import choice
from simplejson import loads
from sys import stdout
from urllib2 import urlopen
from urlparse import urlparse, urlunparse

import socket


class InvalidURL(Exception):
    pass

class SafemnAPI():
    def __init__(self):
        self.URL_SHORTEN = "http://safe.mn/api/?url=%s&format=json"

    def shorten(self, url):
        try:
            url = urlunparse(urlparse(url))
            response = urlopen(self.URL_SHORTEN % url)
            json = response.read()
            json_decode = loads(json)
            url = json_decode.get('url', None)
            if url is None:
                raise InvalidURL
            return url
        except Exception, e:
            raise e

class GreetingsEarthling:

    def __init__(self):
        pass

    @staticmethod
    def its_an_art():
        greetings = []
        greetings.append("""
        .a,                                                      
        ]QQ         jQQQ                             QQQ.              ayQ  
        .?'        _QQP?                             WQQ.aa            QQQ  
QQaQQ; ]QQ jQQQQ  ]QQQQQ_yQQQQa QQ6mQf ]QQyQQ_jQQQQa WQQQQWQ/ _yQQQQa QQQQQk
QQQQW  ]QQ]QQE?4  )9QQP QQW?4QQrWQQQQ' ]QQQQfQQW?4QQrWQQ??QQQ.QQQ?4QQ[?QQQ?^
QQP    ]QQ QQQQw   =QQ ]QQf  QQfBQQ    ]QQf ]QQf  QQfWWQ. ]QQfWQf  QQk QQQ  
QQf    ]QQ_c??QQf  )WQf-QQ6,aQQfWQQ    ]QQf -QQ6,aQQfWWQc jQQ'QQ6,aQQf QQQ ,
QQf    ]QQ]QQQQQ(  )WQf ?WQQQQP QWQ    ]QQf  4QQQQWP QWQQQQQf )WQQQQP` $QQQk
??     )?? ????'.  -??'  )???!  ???    )??'   )???!  ?? ???^   "????   "?9?
                              .aaaaaaac               
                            a@?'      "?mc            
                          wP'            "4c             
                        _Z' ._.         _. "6,       
                       _P.J9mwyP\/   a?mwyD\/4/         
                      _P.]/)maj( f  ]["QajP.k.4,       
                      D   ?\aaa%?    "saaaa7' -m         
                     j'         _aaa,.         ][           
                     @     _awP????????maa      m         
                    ]f  _wP?             "?6a   4            
                    ]'<d?                   )4w ]>         
             <wZqa  ]m!                       -4y[ _aac    
            j"   "5aP                           )6w?' "4/  
           ][     j'                              4/    4/  
           W     j(                                4/   -L    
           Qac  j(                                  4/   Q    
          _P'"Gj(      ._aasasaaasssaaaaaaaas,.      4wP?m.  
          @   -E    .aP??""'""'""'""'""'""'""??4a    ](  -6  
         :f    Q  ._P`                          "5/  m    ]. 
         -f .  W  _P.  ]QQWWg,  WWWQa,       .m   4, Q    ]; 
          $j?5af  y'   ]f   -Q, Q   ]m      aDQ   +f 4.wGcd  
          ]( "Q   D    ]f   _Q` Q   jP      ! W    m )Q' 4F  
          @   ]/  f    ]WBQW?'  Q??Tmc        Q    Q _F   g  
         ][   -L  f    ]f  "m, .Q    Q.T?Y(   Q    Q ]'   ],  
         ]'    Q  f    ]f   ]m .Q   sW        Q    Q m    ]f  
         m     3  f    )'    ?'.?????'        ?    Q F     L  
         W     ]; f              ,.   _aa,  .wWQw  Q_f     Q   
         k     ]f f  . .a  sa, _QQQ, _QQQQ, jQQQWL Q]f     $  
        <f     ][ f -B ]Qf QWk ]QQQf ]QQQW[ QQQQQE Q][     j. 
        ]f     =f f     -  )?` -4QP` -$QQP  ]QQQW( Q];     ](  
        ]f     :f f   aa,     .        -`    "??'  Qj;     ][  
        ]f     :f f _QQWQL  aWQm/  swa.  _         Q];     ][ 
        ][     )f f jQQQQQ  WQQQk _QWQL ]QQ,<QL w/ Qj;     ](  
        -L     ][ f ]QQQQW  QWQQf -QQQf )WW`-?'    Q](     j`  
         m     ][ f  9WQ@'  -?T!   "?!             Q]f     d   
         Q     ]  L                                Q)[     Q   
         ]     m  Q                                F L     F    
         ]r    E  ][                              j' Q    <f   
       sawL   <[   4/                            jF  ],   ]L,  
      )6. WgWdQ     ?g/                        sJ'   "6aaa@"?4/
       )??F]rL3.      ?9V###############Z#U##D??      P44P4awP 
         ][]fW][                      ..... .._assss,]fQ][];   
         ]f)[W]f  . . .]      ;`    ])  . .]. Z     ;][#];][

""")
        greetings.append("""
                                           _                         
                                          _P\                                      
                                         _? J\                                
                                        _P???4\                                
                                       _?)/ _))\                                
                                      _P6JW/j6_Q\                              
                                     _?/        J\                       
                                    _a j/      a/_6                    
                                   _) ) )/    /' ' \                 
                                  _ga   aj/  aa/  _a\        
                                 _?/j< f6_)/J\_P/]_//6       
                                _g                   _6         
                               _? 6                 _P 6          
                              _gjya6               _gaja6            
                             _P/   P6             _J/  _J6   
                               J  ?  \              J _)/ \                          
                           _P?????????6          P))"))"???\    
                          _()/       J \       _')/       J \   
                         _P\j4/     j?aP6     _P\j?/     jPaP\  
                        _(   _?/   J    J\   _(   _?/   J    J\    
                       _P?6 _4?4/ j?4/ JP?6 _P?6 _4??/ j?4/ JP?\    
                      _())'(?)'(?) '?)"'?)"'())'(?)''?"'(?)"'?)"'   
                     _Q6                                        Pf   
                    _4/J\                                      ?/J\   
                   _/   _6                                    /   _6 
                  _) / _f)\                                  )'/ _f)\    
                 _gajaa6jaa6                               _a6jaa6jaa6    
                _4/        J\                             _4/        J6  
               _g j/      j/_6                           _g j/      j/_6  
              _?'?'4/    J?)?)6                         _P'?'4/    J')?)6  
             _g6  _gj/  jjf  ja6                       _ga  _gj/  ja/  ja6 
             Q a'<'\ 4 ]f_P'J)/?6                      j a'<'\/\/_f_J_J]a)a  
            \                    \                    _                    _  
           P?6                  P?6                  J)a                  J)6  
          '?) \                '?) \                '?" \                '?" \  
        _Q   _?6             _Q   _?6              Q'  _?6             _Q'  _?6
       _\ J__?/J\           _\ J__?//\           _\ J\_?/ \           _\ J'_?/ \ 
      _P?????????6         _P?????????6         <P?????????6         _P?????????6 
     _(?/       J)\       _()/       J)\       _'?/       J)\       _(?/       J)\ 
    _a\a_/     a7a/a     <a6a_/     a7a/a     _a\a_/     a7a/a     _a\j_/     a7a[a 
   _]   _'    /f   J    _]/  _'/   /6   J    _</  _(     '   J'    ]   <?    /f   J 
  _/ j/_g a/ a _f j/_a _/ j/_g a/ a _a j/ 6 _/ a/_g ]/ a _a j/_6 _/ j/_6 j/ a _6 j/_a
  )')')' ' ' ? ? ? ) )')')')' ' ? ? ? ) )')')')' ' ? ? ? ? ) )')')')')')? ? ? ? ? ? )

""")
        greetings.append("""
            .___,                                        
            ]QQQf                     QQQf               
            ]QQQ6aQQga/   aaaaaaaa,_awQQQ6aa _aaaaaa,    
            ]QQQP??$QQQ/ )WWY.?WWQQ/T4QQQDT? QQQ`.?Q(    
            ]QQQf   QQQL _aWQQQQWQQf ]WQQf   4QQQQQw/    
            ]QQQ6aawQQQ[ QQQQ  jQQQf )WQQ6aa.aay,QWWQ aaa
            ]QQ?4QQQQP^  ?QQQQWP4QQ?  4QQQQW QQQQWQ@? QQW

                    -.                       .-

                _..-'(                       )'-.._
             ./'. '!!\\.       (\_/)       .//!!' .'\.
          ./'.!'.'!!!!\\!..    ). .(     ..!//!!!!'.'!.'\.
       ./'..!'.!! !!!!!\'''''' '''' ''''''/!!!!! !!.'!..'\.
     ./'.!!'.!!!! !!!!!!!!!!!!.     .!!!!!!!!!!!! !!!!.'!!.'\.
    /'!!!'.!!!!!! !!!!!!!!!!!!{     }!!!!!!!!!!!! !!!!!!.'!!!'\'
   '.!!!'.!!!!!!! !!!!!!!!!!!!{     }!!!!!!!!!!!! !!!!!!!.'!!!.'
  '.!!! !!!!!!!!! !/'   ''\!!''     ''!!/''   '\! !!!!!!!!! !!!.'
  !/' \./'     '\./         \!!\   /!!/         \./'     '\./ '\!
  V    V         V          }' '\ /' '{          V         V    V
  '    '         '               V               '         '    '
""")
        greetings.append("""
    OOOOOO8O888888888888888888888888888888888OOCc::..                                              .::..     :oCO8O8888888888888888888888888888888OOOOOOOO
    OOOOO8O888888888888888888888888888888888OCo:..                                                 c::..     .::oOO8888888888888888888888888888888O88OOOOO
    OOOO8O88888888888888888888888888888888OOo:...                                                  .c:.       :::oCOO8888888888888888888888888888888O8OOOO
    OOOOO88888888888888888888888888888888CCc:.                                                      :c      .  .c:COCO8888888888888888888888888888888O8OOO
    OOO888888888888888888888888888888888oo:.                                                         :       :  .::COCO8888888888888888888888888888888O8OO
    O8O88888888888888888888888888888888Cc::                                                       :. ..      ..   .cCOCO888888888888888888888888888888O8OO
    O8O8O88888888888888888888888888888Ccc.  .                                                      ::..      .:.  .:oCCC88888888888888888888888888888888O8
    O88O88888888888888888888888888888Oco                                                           ::..     ..::.   ccCCO88888888888888888888888888888888O
    O8O888888888888888888888888888888co     .  .   .                c                            .:.c::.    . .    .:ccCC88888888888888888888888888888888O
    O8O8O888888888888888888888888888Cc:       :   .:     .    :                   .c..          ..:c::c..          :o:ooC88888888888888888888888888888O888
    888O888888888888888888888888888Ooc.       .  ::c   . c..  .        .         .:cc.          .c:c:. :.   .      ::cooo888888888888888888888888888888888
    8888888888888888888888888888888Ccc.          ::..:..:c..::.   .:.         ....o:c:::c..:    .cc:c . :.   .      :ccCoO88888888888888888888888888888888
    8O8888888888888888888888888888OoCc.      .   ::..c.:.o .::.. ...  .      .c...::c::o:::.. .  :::...  ..  .     . ccccO88888888888888888888888888888888
    O88888888888888888888888888888OCO:.          :...:.::.::....   ::..   :  .c.::c:oc:o:c::.    .:...    .       .:..coo888888888888888888888888888888888
    8O8888888888888888888888888888OoCc:        .. . . .: :.::c... :c...:o:. .::::cc:cc:ccc:::.. ...::.            .:.:coCO88888888888888888888888888888888
    8O88888888888888888888888888888oOCc       ...   ......::.:.. .::...:cc...:.::cc:.ccc:::::...  . :c            . .ccoCO88888888888888888888888888888888
    O888888888888888888888888888888CCOc.       :.      .. .. .: .:..::c::::.:..::::::c:o:..:..:. .. .             ..cccCCO88888888888888888888888888888888
    8O88888888888888888888888888888OCCc:       .            .  ..::ooCOCOcocccoooooc:ccOo..:. . .::.c              .:ccCO888888888888888888888888888888888
    O8O88888888888888888888888888888OCc:                 .:OOOOOOOCooCCOO888888@@@88OOCOOO:.c::::. :ooc            .ccoOO888888888888888888888888888888888
    8O888888888888888888888888888888OCo:               :coCOo..... ..cCO88O88@@@@@8888O.              :           .:oooO8888888888888888888888888888888O88
    8OO8O8888888888888888888888888888OCo            .  oCo            . o88888@@@@888o.                           .cCoCO8888888888888888888888888888888888
    O88O88888888888888888888888888888OCo            .  c..               .8888@@@@8OC.                            cCCOOO88888888888888888888888888888888O8
    8O8O88888888888888888888888888888OC.                                    .ccooccc                       .     :COOOO88888888888888888888888888888O888OO
    O8OO888888888888888888888888888OCo:                                    o8@@@@@@8:                       ..   cOOO888888888888888888888888888O88888OO8O
    OOOO8O8888888888888888888888888CCoCOCo.                               .888@@@@88O:                   ::. .  :cO888888888888888888888888888888888OO8O8O
    OOOO888O888888888888888888888888888OC.                                c88@@@@@8888c                 cc:. . .cCO8888888888888888888888O888O888888O8OOOO
    OOO8O88O888888888888888888888888888Co                         .      C88@@@@@@@8888Oo.     ...:::     .... .oO8888888888888888888888888888888888OOO8OO
    OOOOOOO8O888888888888888888888888Ooo.                c ...      ::oO@888@@@@@@@8888@@@@8OCCCCCOOC       .:.:oO8888888888888888888888888888O8888OOOOOOO
    OOOOOOOO8O8O88888888888888888888OOCc:.              8c :oocoCCO8@@@@@@88@@@@@@@888@@@@@@@@88888Oo       ..cCOO888888888888888888888888888888O88OOOOOOO
    OOOOOOO8OOO8O888888888888888888888Cooc..           cCCc:CO8888@8@@@@@@OC88@@@@8OO8@@@@@@@@8888OC.::.:    .cCO8888888888888888888888888888888O8OOOOOOOO
    OOOOOOOOO88O888888888888888888888OOOOcc:                cO8888888@@@@@@8OC8OOoC8@@@@@@@888888OO: ::..    coO8888888888888888888888888888888O8OOOOOOOOO
    OOOOOOO88OO88888888O88888888888888OOOoc                  cO8888888@88@8@8888O8@@@@@@88888888OCc   ....  :oCO88888888888888888888O888888888O8O8O8OOOOOO
    OOOOOO8OO8O8888888888888888888888888Ooc:..                :O888888888888@@@@@@@@@@8@8888888OC.   ...   .oCOO88888888888888888888888888888OOO8OOOOOOOOO
    OOOOO8O8O88O8888888888O888888888888OCOCoc:                 :O88888OOCoCCCCCOCCCCoCCOO8888OOC     ..:  .:CO8O88888888888888888888888888888OO8OOOOOOOOOO
    OOOOOO8OO88O88888888888888888888888888OCcc:.                 oO888888888OOOOOOOOCC888O88OC:       ::  .oCO8888888888888888888888O888888O8OOOOOOOOOOOOO
    OOOOOO8OO8O8OO8O8888888888888888888888OCCC::                  .COOOO888CCOCCCoooOOOOOOOC:          ...:CO888888888888888888888888888888OOOOOOOOOOOOOOO
    OOOOOOOO8O8OO8O8888888888888888888888888OCoc:         .    .    .C8@@8cOCCooCOOOOOOOOO:                   o88888888888888888888888888OOOOOOOOOOOOOOOOO
    OOOOOOOOOO8O8O8OO8888888888888888888888OOOCoc:                :. O@@@c8888@@@8@8888Oo                        cC888888888888888888O8O8OO8OOOOOOOOOOOOOO
    OOOOOOOOOOOOOO8OOOOO88888888888888888888OOCCCc.                O@@@@:CO888888888OOC   .                             ..:oCOO8O888O8OOOOOOOOOOOOOOOOOOOO
    OOOOOOOOOOOOOOOOOOOO8O888888888888888888OOOC:c              ...@@@@:  .oCCOOOCCo:   .                               ... ....::COOOO8OOOOOOOOOOOOOOOOOO
    OOOOOOOOOOOOOOOOOOOOOO8O8O8O888888888888Oo                  .c@@@8: .C.          ...                          :@@@c         ...:.oOOOOOOOOOOOOOOOOOOOO
    OOOOOOOOOOOOOOOOOOOOOOO8O8O88O888888OC.  .                  C@@@o  .O88888OOO .:. .                           :@@8.          .......cOOOOOOOOOOOOOOOOO
    OOOOOOOOOOOOOOOOOOOOOOOOOO88OOOO8C.                        C@@@:   C888888:  ..                                                        COOOOOOOOOOOOOO
    COOOOOOOOOOOOOOOOOOOOOOOOOOOOOO:                          o@@@.       .                                                                  OOOOOOOOOOOOO
    CCCOCOOOOOOOOOOOOOOOOOOOOOOOOO                           :@8@                  .                                                          COOOOOOOOOOO
    CCCCOOCOOOOOOOOOOOOOOOOOOOOOo                           c@@8              ...  .:                .                                        :OOOOOOOOOCO
    CCCCCCCOOCOOOOOOOOOOOOOOOOOc                            .Co             ..                       .                                          cOOOOOOOCO
    CCCCCCCOCCOOOOOOOOOOOOOOOOC                                                  .  ::.  .           .                                            :OCOCOCO
    CCCCCCCCOOOCOOOOOOOOOOOOOO                                                   ....       :  : .:    ..                                           :CCOCC
    CCCCCCCCCOCOOOOOOOOOOOOOOC                                         ..... .: ..      .   c   ....:....                        .            .        oCC
    CCCCCCCCCCCCOCCOOOOOOOOOO:                                           ..                 . ......:c:     .   .                                . .     .
    CCCCCCCCCCCCCCCCOCOOOOOOO.                                      :           .      :   .  .c.  ...:      .  .:                                        
    CCCCCCCCCCCCCCCCOCCOCOOOC             .                   . .    :               ..:   .  ::. :.:: .    ..   .    .                                   
    ooCCCCCCCCCCCCCCCCCCOCOOC                           .       .:   :c  .:...        :    .  .:  c :.     ...       .                  .                 
    ooooooCCCCCCCCCCCCCCCCCCC                          :     .  ::       .:::.:.: :  .:       .. ....                .    .                               
    oooooooCCCCCCCCCCCCCCCCCC                           .         :       ::.:c.. . :            . :..     ..         .               :                   
""")
        greetings.append("""
                                    ,_-=(!7(7/zs_.
                                 .='  ' .`/,/!(=)Zm.
                   .._,,._..  ,-`- `,\ ` -` -`\\7//WW.
              ,v=~/.-,-\- -!|V-s.)iT-|s|\-.'   `///mK%.
            v!`i!-.e]-g`bT/i(/[=.Z/m)K(YNYi..   /-]i44M.
          v`/,`|v]-DvLcfZ/eV/iDLN\D/ZK@%8W[Z..   `/d!Z8m
         //,c\(2(X/NYNY8]ZZ/bZd\()/\\7WY%WKKW)   -'|(][%4.
       ,\\i\c(e)WX@WKKZKDKWMZ8(b5/ZK8]Z7%ffVM,   -.Y!bNMi
       /-iit5N)KWG%%8%%%%W8%ZWM(8YZvD)XN(@.'P[   \]!/GXW[
      / ))G8\NMN%W%%%%%%%%%%8KK@WZKYK*ZG5KMi,-   vi[NZGM[
     i\!(44Y8K%8%%%**~YZYZ@%%%%%4KWZ/PKN)ZDZ7   c=//WZK%!
    ,\y\YtMZW8W%%f`,`.t/bNZZK%%W%%ZXb*K(K5DZ   -c\\/KM48
    -|c5PbM4DDW%f  v./c\[tMY8W%PMW%D@KW)Gbf   -/(=ZZKM8[
    2(N8YXWK85@K   -'c|K4/KKK%@  V%@@WD8e~  .//ct)8ZK%8`
    =)b%]Nd)@KM[  !'\cG!iWYK%%|   !M@KZf    -c\))ZDKW%`
    YYKWZGNM4/Pb  '-VscP4]b@W%     'Mf`   -L\///KM(%W!
    !KKW4ZK/W7)Z. '/cttbY)DKW%     -`  .',\y)K(5KW%%f
    'W)KWKZZg)Z2/,!/L(-DYYb54%  ,,`, -\-/y(((KK5WW%f
     \M4NDDKZZ(e!/\\7vNTtZd)8\Mi!\-,-/i-v((tKNGN%W%%
     'M8M88(Zd))///((|D\\tDY\\\\KK-`/-i(=)KtNNN@W%%%@%[
      !8%@KW5KKN4///s(\Pd!ROBY8/=2(/4ZdzKD%K%%%M8@%%
       '%%%W%dGNtPK(c\/2\[Z(ttNYZ2NZW8W8K%%%%YKM%M%%.
         *%%W%GW5@/%!e]_tZdY()v)ZXMZW%W%%%*5Y]K%ZK%8[
          '*%%%%8%8WK\)[/ZmZ/Zi]!/M%%%%@f\ \Y/NNMK%%!
            'VM%%%%W%WN5Z/Gt5/b)((cV@f`  - |cZbMKW%%|
               'V*M%%%WZ/ZG\+5((+)L'-,,/  -)X(NWW%%%
                    `~`MZ/DZGNZG5(((\,    ,t\\Z)KW%@
                       'M8K%8GN8\\5(5///]i!v\K)85W%%f
                         YWWKKKKWZ8G54X/GGMeK@WM8%@
                          !M8%8%48WG@KWYbW%WWW%%%@
                            VM%WKWK%8K%%8WWWW%%%@`
                              ~*%%%%%%W%%%%%%%@~
                                 ~*MM%%%%%%@f`
                                     '''''
""")
        greetings.append("""
                     _______
                    / _____ \\
              _____/ /     \\ \\_____
             / _____/  311  \\_____ \\
       _____/ /     \\       /     \\ \\_____
      / _____/  221  \\_____/  412  \\_____ \\
     / /     \\       /     \\       /     \\ \\
    / /  131  \\_____/  322  \\_____/  513  \\ \\
    \\ \\       /     \\       /     \\       / /
     \\ \\_____/  232  \\_____/  423  \\_____/ /
     / /     \\       /     \\       /     \\ \\
    / /  142  \\_____/  333  \\_____/  524  \\ \\
    \\ \\       /     \\       /     \\       / /
     \\ \\_____/  243  \\_____/  434  \\_____/ /
     / /     \\       /     \\       /     \\ \\
    / /  153  \\_____/  344  \\_____/  535  \\ \\
    \\ \\       /     \\       /     \\       / /
     \\ \\_____/  254  \\_____/  445  \\_____/ /
      \\_____ \\       /     \\       / _____/
            \\ \\_____/  355  \\_____/ /
             \\_____ \\       / _____/
                   \\ \\_____/ /
                    \\_______/

""")
        greetings.append("""
        +------+.      +------+       +------+       +------+      .+------+
        |`.    | `.    |\     |\      |      |      /|     /|    .' |    .'|
        |  `+--+---+   | +----+-+     +------+     +-+----+ |   +---+--+'  |
        |   |  |   |   | |    | |     |      |     | |    | |   |   |  |   |
        +---+--+.  |   +-+----+ |     +------+     | +----+-+   |  .+--+---+
         `. |    `.|    \|     \|     |      |     |/     |/    |.'    | .'
           `+------+     +------+     +------+     +------+     +------+'

           .+------+     +------+     +------+     +------+     +------+.
         .' |    .'|    /|     /|     |      |     |\     |\    |`.    | `.
        +---+--+'  |   +-+----+ |     +------+     | +----+-+   |  `+--+---+
        |   |  |   |   | |    | |     |      |     | |    | |   |   |  |   |
        |  ,+--+---+   | +----+-+     +------+     +-+----+ |   +---+--+   |
        |.'    | .'    |/     |/      |      |      \|     \|    `. |   `. |
        +------+'      +------+       +------+       +------+      `+------+

           .+------+     +------+     +------+     +------+     +------+.
         .' |      |    /|      |     |      |     |      |\    |      | `.
        +   |      |   + |      |     +      +     |      | +   |      |   +
        |   |      |   | |      |     |      |     |      | |   |      |   |
        |  .+------+   | +------+     +------+     +------+ |   +------+.  |
        |.'      .'    |/      /      |      |      \      \|    `.      `.|
        +------+'      +------+       +------+       +------+      `+------+
""")
        greetings.append("""
          _______________________________
         /\                              \ 
        /++\    __________________________\ 
        \+++\   \ ************************/
         \+++\   \___________________ ***/
          \+++\   \             /+++/***/
           \+++\   \           /+++/***/
            \+++\   \         /+++/***/
             \+++\   \       /+++/***/
              \+++\   \     /+++/***/
               \+++\   \   /+++/***/
                \+++\   \ /+++/***/
                 \+++\   /+++/***/
                  \+++\ /+++/***/
                   \+++++++/***/
                    \+++++/***/
                     \+++/***/
                      \+/___/

""")
        greetings.append("""
                  +_____A_____+
                 /:`          :\ 
               D/ : `         : B
               /  :  `        :  \ 
              /   :   +-----A-----+
             +______A_|__,    :   :
             :`   *___|_A_\___+   :
             : `  `   C  : B   \  :
             :  `  `  |  :  \   B :
             :   +--`-|--A---+   \:
             :   |   `+____A______+
             *__ |__A____+   :   ,
             `   |        \  :  ,
              `  C         B : ,
               ` |          \:,
                `+_____A_____+


              Tessaract like wut!

""")
        greetings.append("""
                                   .--. 
                                   \  / 
                                .--.\/.--.  
                           .--.|    \\    |.--. 
                           \  / '--'/\'--' \  / 
                        .--.\/.--. /  \ .--.\/.--. 
                   .--.|    \\    |:--:|    \\    |.--. 
                   \  / '--'/\'--' \  / '--'/\'--' \  / 
                .--.\/.--. /  \ .--.\/.--. /  \ .--.\/.--.  
               |    \\    |:--:|    \\    |:--:|    \\    | 
                '--'/\'--' \  / '--'/\'--' \  / '--'/\'--'
                   /  \ .--.\/.--. /  \ .--.\/.--. /  \ 
                   '--'|    \\    |:--:|    \\    |'--' 
                        '--'/\'--' \  / '--'/\'--' 
                           /  \ .--.\/.--. /  \ 
                           '--'|    \\    |'--' 
                                '--'/\'--' 
                                   /  \ 
                                   '--' 
        
""")
        greetings.append("""
                     _____ 
                  .-'     '-. 
                .'           '. 
               /               \  
              ;                 ; 
              |                 | 
              ;                 ; 
               \               / 
                '.           .' 
                  '-._____.-' 
                    .-'""'-.  
                  .'        '. 
                 /            \   
                ;              ; 
                ;              ; 
                 \            / 
                  '.        .'
                    '-....-'
                      .-""-.
                     /      \  
                    ;        ;  
                     \      /  
                      '-..-'  
                        .--.  
                       /    \   
                       \    /  
                        '--'  
                          .-.  
                         (   )  
                          '-'  
        
""")
        greetings.append("""
                           .-'''-.
                   .-'''-./       \.-'''-.
           .-'''-./       \.-'''-./       \.-'''-.
          /       \.-'''-./'-...-'\.-'''-./       \ 
          \       /'-...-'\.-'''-./'-...-'\       / 
           '-...-'\       /'-...-'\       /'-...-'
                   '-...-'\       /'-...-'
                           '-...-'
        
""")
        greetings.append("""
                    __    __ 
                 __/  \__/  \__ 
                /  \__/  \__/  \__ 
                \__/  \__/  \__/  \__
                   \__/  \__/  \__/  \__
                 __/  \__/  \__/  \__/  \  
                /  \__/  \__/  \__/  \__/  
                \__/  \__/  \__/  \__/  \  
                   \__/  \__/  \__/  \__/  
                 __/  \__/  \__/  \__/  \  
                /  \__/  \__/  \__/  \__/  
                \__/  \__/  \__/  \__/  \  
                   \__/  \__/  \__/  \__/  
                 __/  \__/  \__/  \__/  
                /  \__/  \__/  \__/   
                \__/  \__/  \__/   
                   \__/  \__/   

""")
        greetings.append("""
                                  _
                                 /\\\\ 
                                /  \\\\ 
                               / /\\ \\\\ 
                              / // \\ \\\\ 
                              \\ \\\\ / // 
                            _  \\ \\/ //  _ 
                           /\\\\  \\ \\//  /\\\\ 
                          /  \\\\ /\\ \\\\ /  \\\\ 
                         / /\\ \\/ /\\ \\/ /\\ \\\\ 
                        / // \\/ // \\/ // \\ \\\\ 
                        \\ \\\\ / /\\\\ / /\\\\ / // 
                      _  \\ \\/ /\\ \\/ /\\ \\/ //  _
                     /\\\\  \\ \\// \\ \\// \\ \\//  /\\\\  
                    /  \\\\ /\\ \\\\ /\\ \\\\ /\\ \\\\ /  \\\\ 
                   / /\\ \\/ /\\ \\/ /\\ \\/ /\\ \\/ /\\ \\\\ 
                  / // \\/ // \\/ // \\/ // \\/ // \\ \\\\ 
                  \\ \\\\ / /\\\\ / /\\\\ / /\\\\ / /\\\\ / //
                _  \\ \\/ /\\ \\/ /\\ \\/ /\\ \\/ /\\ \\/ //  _
               /\\\\  \\ \\// \\ \\// \\ \\// \\ \\// \\ \\//  /\\\\ 
              /  \\\\ /\\ \\\\ /\\ \\\\ /\\ \\\\ /\\ \\\\ /\\ \\\\ /  \\\\ 
             / /\\ \\/ /\\ \\/ /\\ \\/ /\\ \\/ /\\ \\/ /\\ \\/ /\\ \\\\ 
            / // \\/ // \\/ // \\/ // \\/ // \\/ // \\/ // \\ \\\\ 
            \\ \\\\ / /\\\\ / /\\\\ / /\\\\ / /\\\\ / /\\\\ / /\\\\ / //
             \\ \\/ /\\ \\/ /\\ \\/ /\\ \\/ /\\ \\/ /\\ \\/ /\\ \\/ //
              \\  // \\ \\// \\ \\// \\ \\// \\ \\// \\ \\// \\  //
               \\//  /\\ \\\\ /\\ \\\\ /\\ \\\\ /\\ \\\\ /\\ \\\\  \\//
                   / /\\ \\/ /\\ \\/ /\\ \\/ /\\ \\/ /\\ \\\\ 
                  / // \\/ // \\/ // \\/ // \\/ // \\ \\\\ 
                  \\ \\\\ / /\\\\ / /\\\\ / /\\\\ / /\\\\ / // 
                   \\ \\/ /\\ \\/ /\\ \\/ /\\ \\/ /\\ \\/ // 
                    \\  // \\ \\// \\ \\// \\ \\// \\  // 
                     \\//  /\\ \\\\ /\\ \\\\ /\\ \\\\  \\// 
                         / /\\ \\/ /\\ \\/ /\\ \\\\ 
                        / // \\/ // \\/ // \\ \\\\ 
                        \\ \\\\ / /\\\\ / /\\\\ / // 
                         \\ \\/ /\\ \\/ /\\ \\/ // 
                          \\  // \\ \\// \\  // 
                           \\//  /\\ \\\\  \\// 
                               / /\\ \\\\ 
                              / // \\ \\\\ 
                              \\ \\\\ / // 
                               \\ \\/ // 
                                \\  // 
                                 \\// 

""")

        ## PICTURES I GOT ANNOYED AT:

        ## "Qu'est-ce que fuck is that?" -- Me, first time on the streets of Vienna, Austria
        ## "That? It's an art."          -- Rubin

        return greetings

    @staticmethod
    def make_a_pretty():
        pretty = ['http://www.brianpiana.com/wp-content/uploads/2011/08/landscape1.png',
                  'https://s3.amazonaws.com/data.tumblr.com/tumblr_m46s1kMGx31qzt4vjo1_r1_500.gif',
                  'https://s3.amazonaws.com/data.tumblr.com/tumblr_m436mzp63k1qzt4vjo1_r7_500.gif',
                  'https://s3.amazonaws.com/data.tumblr.com/tumblr_m39qj6mK6v1qzt4vjo1_500.gif',
                  'https://s3.amazonaws.com/data.tumblr.com/tumblr_m2qw2jzPkJ1qzt4vjo1_r1_500.gif',
                  'http://davidope.com/tmblr/120305_xxl.gif',
                  'https://s3.amazonaws.com/data.tumblr.com/tumblr_m0ch5i6PWe1qzt4vjo1_500.gif',
                  'https://s3.amazonaws.com/data.tumblr.com/tumblr_lztyt60lS91qzt4vjo1_500.gif',
                  'https://s3.amazonaws.com/data.tumblr.com/tumblr_lz9c7jeS3b1qzt4vjo1_500.gif',
                  'https://s3.amazonaws.com/data.tumblr.com/tumblr_lxkgfkEHxn1qzt4vjo1_500.gif',
                  'http://davidope.com/tmblr/the_same.png',
                  'http://www.wayfarergallery.net/hot-images/wp-content/uploads/2010/08/Grid-Works2000-bw-4.gif',
                  'http://www.wayfarergallery.net/hot-images/wp-content/uploads/2010/08/Grid-Works2000-bw-3.gif',
                  'http://www.wayfarergallery.net/hot-images/wp-content/uploads/2010/08/Grid-Works2000-bw-21.gif',
                  'http://www.wayfarergallery.net/hot-images/wp-content/uploads/2010/08/Grid-Works2000-bw-1.gif',
                  'https://s3.amazonaws.com/data.tumblr.com/tumblr_lvabjmK8Ab1qzt4vjo1_500.gif',
                  'https://s3.amazonaws.com/data.tumblr.com/tumblr_luda3yYxzm1qzt4vjo1_500.gif',
                  'http://dearcomputer.nl/priwrid/',
                  'http://www.alwaysloading.com/',
                  'http://www.master-list2000.com/abillmiller/pages/imagePages/gridworks2000-blogdrawings-collage18.html',
                  'http://www.master-list2000.com/abillmiller/pages/imagePages/gridworks2000-blogdrawings-collage-4.html',
                  'http://www.master-list2000.com/abillmiller/pages/imagePages/gridworks2000-anim09.html',
                  'http://place3.elnafrederick.computersclub.org/',
                  'http://www.todayandtomorrow.net/wp-content/uploads/2009/12/gate_to_night_gate_to_day.gif',
                  'http://www.todayandtomorrow.net/wp-content/uploads/2009/12/revolving_door.gif',
                  'http://www.innerdoubts.com/',
                  'https://s3.amazonaws.com/data.tumblr.com/tumblr_m64wdyXg4a1qzt4vjo1_500.gif',
                  'https://s3.amazonaws.com/data.tumblr.com/tumblr_m618fya1Me1qzt4vjo1_r1_500.gif',
                  'https://s3.amazonaws.com/data.tumblr.com/tumblr_m5sbvyRME11qzt4vjo1_500.gif',
                  'https://s3.amazonaws.com/data.tumblr.com/tumblr_m5ew7vyBE71qzt4vjo1_500.gif',
                  'https://s3.amazonaws.com/data.tumblr.com/tumblr_m51woeJu3w1qzt4vjo1_r4_500.gif',
                  'https://s3.amazonaws.com/data.tumblr.com/tumblr_m4znrlTlEy1qzt4vjo1_r2_500.gif']

        picture = choice(pretty)
        safemn = SafemnAPI()
        short = safemn.shorten(picture)

        msg = "And we thought you'd find this pretty:\n" + short + "\n"
        return msg

    @staticmethod
    def pick_a_story():
        dt = socket.getdefaulttimeout=4
        base_url = 'http://dearcomputer.nl/extras/story/readstory.php?id='
        text_urls = []

        for x in range(1, 498):
            story_url = (base_url + str(x))
            text_only = ('http://html2text.theinfo.org/?url=' + story_url) 
            text_urls.append(text_only)

        story = choice(text_urls)

        try:
            story_opened = urlopen(story, timeout=dt)
        except Exception:
            return " "

        if story_opened:
            story_text = story_opened.read()

            ## Law of Demeter, my ass!
            raw_title = story_text.split('*', 2)[2].split('*', 1)[0]
            raw_story = story_text.split('* * *', 1)[1].strip()
    
            nice = '***  ' + raw_title + '  ***\n'
            nicer = raw_story.replace('\n\n\n', '\n')
            nicer_again = nicer.replace('\n\n', '\n')

            first_line = len(nice)
            line = '*' * first_line

            nicest = line + '\n' + nice + line + '\n' + nicer_again 
            return nicest
        else:
            return " "

    def store_a_story(self):
        separator = "!!!!!!!!!"
        stories = path.join(path.abspath(path.curdir), 
                            '.ai_generated_stories') 
        
        with open(stories, "a+") as seen:
            total = seen.read()
            have = total.split(separator)

            count = len(have)

            if count > 150:
                ai_story = choice(have)
            else:
                ai_story = self.pick_a_story()
                store = str(ai_story) + separator

                if have.count(str(ai_story)) == 0:
                    seen.write(store)

            return ai_story

    
if __name__ == "__main__":
    oh_hai = GreetingsEarthling()
    greet = oh_hai.its_an_art()
    broke = choice(greet)
    fixed = r'%s' % broke

    story = None
    #story = oh_hai.store_a_story()
    #glitch = "****\n****\n****\n"

    if story:
        if (len(fixed.splitlines()) + len(story.splitlines())) > 50:
            stdout.write(fixed)
        else:
            stdout.write(fixed)
            #while story == glitch:
            #    story = oh_hai.store_a_story()
            #print story
    else:
        stdout.write(fixed)

