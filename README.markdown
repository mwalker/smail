README for smail
================

SMail is a very lightweight email library, based on Perl's Email::Simple.

It implements the minimal functions to enable the easy creation or parsing of an
email message that conforms to RFC 2822.

It is intended to be the first of a family of SMail::* modules that will deal with
many common email standards.

It is still a work in progress and the interface may change.

Download & Install
==================

    sudo gem install smail-mwalker --source http://gems.github.com

Synopsis
========

    email = SMail.new(text)

    from_header = email.header("From")
    received = email.headers("Received")

    email.header_set("From", "matthew@walker.wattle.id.au")

    old_body = email.body
    email.body = "Hello World!\nMatthew"

    print email.to_s


Contributors
============

SMail is maintained by Matthew Walker
[matthew@walker.wattle.id.au](mailto:matthew@walker.wattle.id.au)

Contributors include:

[Pete Yandell](http://github.com/notahat)

Thanks to the [Perl Email Project](http://emailproject.perl.org/)'s [Email::Simple](http://emailproject.perl.org/wiki/Email::Simple)
