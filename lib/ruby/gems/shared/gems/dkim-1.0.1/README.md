dkim
====
A DKIM signing library in ruby.

[![Build Status](https://secure.travis-ci.org/jhawthorn/dkim.png?branch=master)](http://travis-ci.org/jhawthorn/dkim)

[Documentation](http://rubydoc.info/github/jhawthorn/dkim)

Installation
============

    sudo gem install dkim

Necessary configuration
=======================
A private key, a domain, and a selector need to be specified in order to sign messages.

These can be specified globally

    Dkim::domain      = 'example.com'
    Dkim::selector    = 'mail'
    Dkim::private_key = open('private.pem').read

Options can be overridden per message.

    Dkim.sign(mail, :selector => 'mail2', :private_key => OpenSSL::PKey::RSA.new(open('private2.pem').read))

For more details see {Dkim::Options}

Usage With Rails
================

Dkim contains `Dkim::Interceptor` which can be used to sign all mail delivered
by [mail](https://github.com/mikel/mail), which is used by actionmailer in
rails >= 3.

For rails, create an initializer (for example `config/initializers/dkim.rb`)
with the following template.

    # Configure dkim globally (see above)
    Dkim::domain      = 'example.com'
    Dkim::selector    = 'mail'
    Dkim::private_key = open('private.pem').read

    # This will sign all ActionMailer deliveries
    ActionMailer::Base.register_interceptor(Dkim::Interceptor)

Standalone Usage
================

Calling `Dkim.sign` on a string representing an email message returns the message with a DKIM signature inserted.

For example

    mail = Dkim.sign(<<EOS)
    To: someone@example.com
    From: john@example.com
    Subject: hi

    Howdy
    EOS

    Dkim.sign(mail)
    # =>
    # To: someone@example.com
    # From: john@example.com
    # Subject: hi
    # DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=example.com; q=dns/txt; s=mail; t=1305917829;
    #  	bh=qZxwTnSM1ywsrq0Ag9UhQSOtVIG+sW5zDkB+hPbuX08=; h=from:subject:to;
    #  	b=0mKnNOkxFGiww63Zu4t46J7eZc3Uak3I9km3IH2Le3XcnSNtWJgxiwBX26IZ5yzcT
    # 	VwJzcCnPKCScIJMQ7yfbfXmNsKVIOV6eSUqu1YvJ1fgzlSAXuDEMNFTjoto5rrdA+
    # 	BgX849hEY/bWHDl1JJgNpiwtpl4t0Q7M4BVJUd7Lo=
    #
    # Howdy

More flexibility can be found using {Dkim::SignedMail} directly.

Specific configuration
========================

For sending mesages through Amazon SES, certain headers should not be signed

    Dkim::signable_headers = Dkim::DefaultHeaders - %w{Message-ID Resent-Message-ID Date Return-Path Bounces-To}

Some OpenSSL's don't have sha256 support.
RFC 6376 states that signers SHOULD sign using rsa-sha256.
For this reason, dkim will *not* use rsa-sha1 as a fallback.
If you wish to override this behaviour and use whichever algorithm is available you can use this snippet (**not recommended**).

    Dkim::signing_algorithm = defined?(OpenSSL::Digest::SHA256) ? 'rsa-sha256' : 'rsa-sha1'

Limitations
===========

* Strictly a DKIM signing library. No support for signature verification. *(none planned)*
* No support for the older Yahoo! DomainKeys standard ([RFC 4870](http://tools.ietf.org/html/rfc4870)) *(none planned)*
* No support for specifying DKIM identity `i=` *(planned)*
* No support for body length `l=` *(planned)*
* No support for signature expiration `x=` *(planned)*
* No support for copied header fields `z=` *(not immediately planned)*

Resources
=========

* [RFC 6376](http://tools.ietf.org/html/rfc6376)
* Inspired by perl's [Mail-DKIM](http://dkimproxy.sourceforge.net/)

License
=======

(The MIT License)

Copyright (c) 2011 [John Hawthorn](http://www.johnhawthorn.com/)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
