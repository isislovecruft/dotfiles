#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# pwdentropy.py
#**************************************
# Password Entropy Calculator         #
#                                     #
# ::author:: Isis Lovecruft           #
# ::license:: GPLv3 Isis Lovecruft   #
#**************************************
#
# Shannon entropy, b-ary entropy, and sub-optimal probability distributions
#__________________________________________________________________________
# 
# Shannon entropy
#----------------
# Entropy, in an information theory context, is defined as unpredictability.
# Thus, a toss of a fair coin has one bit of entropy, due to the fact that
# there is no way to predict the result. In comparision, the entropy of
# the result being heads has zero bits of entropy, because that result 
# becomes inevitable as coin tosses go towards infinity.
#
# For a random variable X with n outcomes {x_i: i=1, ... , n}, the Shannon
# entropy is denoted as H(X) and is defined as
#
#         n
# H(X) = -Σ p(x_i)log_b(p(x_i))
#        i=1
#
# where p(x_i) is the probability mass function of outcome x_i.
#
# However, it should be noted that this defines the entropy for a random
# variable X, independent from other variables. For example, in the 
# English language, if we have a sequence of letters and we know that
# one letter is 'q', the entropy for the following letter is much lower
# than it would be, because it is statistically likely to be the letter
# 'u'. Thus it is necessary to take the Markov model into account. In this
# context, lowercase English text without punctuation or numerals 
# constitutes a 26-ary alphabet, and the above formula for Shannon's 
# entropy is precisely the same for an order-0 source (i.e. each 
# character is independent of preceding characters).
#
# B-ary Entropy
#--------------
# The b-ary entropy of a source S = (s,p), with source alphabet
# s = {a_1, ... , a_n} and discrete probability distribution 
# p = {p_1, ... , p_n} where p_i = p(a_i), is defined by
#
#           n
# H_b(S) = -Σ (p_i)log_b(p_i)
#          i=1
#
# It should be noted that a uniform (or optimal) probability distrubution 
# is assigned to the source alphabet, thus it is considered to be an "ideal
# alphabet", i.e. it has the maximum amount of entropy per character. 
# Obviously, this is not the case for natural languages. 
#
# Sub-optimal Probability Distributions
#--------------------------------------
# The entropy deficiency in a source alphabet with non-uniform probability
# distribution can be expressed as a ratio
#
#                  n
# efficiency(X) = -Σ p(x_i)log_b(p(x_i))/log_b(n) 
#                 i=1
#
# where log_b(n) is the optimal entropy derived from a uniform distribution.

from __future__ import division
import re
from math import log, pow
from operator import add

class PasswordEntropy():
    def __init__(self):
        self.numeric = re.compile('\d')
        self.loweralpha = re.compile('[a-z]')
        self.upperalpha = re.compile('[A-Z]')
        self.symbols = re.compile('[\ \'\]\-\|\\`~!@#$%^&/()_=+.:,;",[<>{}?]')
        self.number_of_symbols = 33

    def sigma(self, f, n, i=1):
        """
        Completes a sigma operation on a function f(x). Note that the
        function f(x) must be defined elsewhere. For the case of squaring
        each iteration of x, this can be defined either as
            def f(x): return (x**2)
        or as
            f = lambda x: x**2
        the second of which can obviously be defined on the fly. Please
        excuse our Lispiness.
        """
        return reduce(add,[f(x) for x in range(i, n+1)])

    def calculate_entropy(self, password):
        charset = 0
        hasdigits = False
        haslowercase = False
        hasuppercase = False
        hassymbols = False

        if self.numeric.search(password):
            charset += 10
            hasdigits = True
        if self.loweralpha.search(password):
            charset += 26
            haslowercase = True
        if self.upperalpha.search(password):
            charset += 26
            hasuppercase = True
        if self.symbols.search(password):
            charset += self.number_of_symbols
            hassymbols = True

        if (hassymbols == True & hasuppercase == True & 
            haslowercase == True & hasdigits == True):
            entropybitsperchar = 6.5699
            return entropybitsperchar
        else: 
            if (hasuppercase == True & haslowercase == True & 
                hasdigits == True):
                entropybitsperchar = 5.9542
                return entropybitsperchar
            else: 
                if (hasuppercase == True & haslowercase == True):
                    entropybitsperchar = 5.7004
                    return entropybitsperchar
                else: 
                    if ((hasuppercase == True | haslowercase == True) &
                        hasdigits == True):
                        entropybitsperchar = 5.1699
                        return entropybitsperchar
                    else: 
                        if (hasuppercase == True | haslowercase == True):
                            entropybitsperchar = 4.7004
                            return entropybitsperchar
                        else: 
                            if (hasdigits == True):
                                entropybitsperchar = 3.3219
                                return entropybitsperchar
        
        #print "Average bits of entropy per character: %s" % entropybitsperchar
        uniformPofX = (1/charset)
        shannonSigmaF = lambda x: (uniformPofX*(log(uniformPofX, charset)))
        shannonEntropy = -(self.sigma(shannonSigmaF, charset, i=1))
        print "Shannon entropy for password is %s" % shannonEntropy
        entropy = log(pow(charset,len(password)),2)
        print "Password entropy: %s" % entropy 
        return entropy

if __name__=="__main__":
    password = "abcdefghijklmnop"
    pe = PasswordEntropy()
    pe.calculate_entropy(password)
