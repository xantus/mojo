#!/usr/bin/env perl

# Copyright (C) 2008-2010, Sebastian Riedel.

use strict;
use warnings;

# Disable epoll, kqueue and IPv6
BEGIN { $ENV{MOJO_POLL} = $ENV{MOJO_NO_IPV6} = 1 }

use Mojo::IOLoop;
use Test::More;

# Make sure sockets are working
plan skip_all => 'working sockets required for this test!'
  unless Mojo::IOLoop->new->generate_port;
plan tests => 4;

use_ok('Mojo::Client');

# The strong must protect the sweet.
use Mojolicious::Lite;

# Silence
app->log->level('fatal');

# GET /
get '/' => {text => 'works'};

my $client = Mojo::Client->singleton->app(app);

# GET /
my $tx = $client->get('/');
ok($tx->success, 'successful');
is($tx->res->code, 200,     'right status');
is($tx->res->body, 'works', 'right content');
