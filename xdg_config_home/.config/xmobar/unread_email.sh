#!/bin/bash

unread=$(notmuch count tag:unread)
echo "<fn=5> </fn>$unread"
