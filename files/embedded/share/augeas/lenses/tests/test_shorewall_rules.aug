module Test_shorewall_rules =
  let basic = "Foo/ACCEPT fw bloc
Bar/DENY bloc fw\n"

  let tabs = "Foo/ACCEPT    fw  bloc
Bar/DENY            bloc    fw\n"

  let three_fields_plus_comment = "ACCEPT   fw:127.0.0.1    bloc
# This should be a comment.
Foo/ACCEPT      bloc fw
"

  let rules_and_comments = "ACCEPT   fw:127.0.0.1   bloc   tcp - 22 127.0.0.1 22/s root/user
# This should be a comment.

Foo/ACCEPT      bloc fw
"

  let rules_comment_section = "# This is a comment.
SECTION NEW
ACCEPT   fw:127.0.0.1   bloc   tcp - 22 127.0.0.1 22/s root/user # This should also be a comment.
# This should be a comment.

Foo/ACCEPT      bloc fw
"

  let hq_server01_test = "SMTP/ACCEPT:info        fw                      net:63.246.22.101,63.246.22.114,63.246.22.117                   tcp     smtp  -  -  25/min\n"

  let put_test_basic = "ACCEPT  net fw  tcp
"

  let put_test_basic_result = "ACCEPT   net fw  tcp
DENY    fw  bloc    tcp
"

  let put_test_comment = "# This is a comment.
ACCEPT  net fw  tcp
"

  let put_test_comment_result = "# This is a comment.
ACCEPT  net fw  tcp
DENY    fw  bloc    tcp
"


  test Shorewall_rules.lns get hq_server01_test =
    { "rule"
      { "action" = "SMTP/ACCEPT:info" }
      { "source" = "fw" }
      { "dest" = "net:63.246.22.101,63.246.22.114,63.246.22.117" }
      { "proto" = "tcp" }
      { "dest_port" = "smtp" }
      { "source_port" = "-" }
      { "dest_original" = "-" }
      { "rate_limit" = "25/min" } }

  test Shorewall_rules.lns get basic =
    { "rule"
        { "action" = "Foo/ACCEPT" }
        { "source" = "fw" }
        { "dest"   = "bloc" } }
    { "rule"
        { "action" = "Bar/DENY" }
        { "source" = "bloc" }
        { "dest"   = "fw" } }

  test Shorewall_rules.lns get tabs =
    { "rule"
        { "action" = "Foo/ACCEPT" }
        { "source" = "fw" }
        { "dest"   = "bloc" } }
    { "rule"
        { "action" = "Bar/DENY" }
        { "source" = "bloc" }
        { "dest"   = "fw" } }

  test Shorewall_rules.lns get three_fields_plus_comment =
    { "rule"
      { "action" = "ACCEPT" }
      { "source" = "fw:127.0.0.1" }
      { "dest"   = "bloc" } }
    { "#comment" = "This should be a comment." }
    { "rule"
      { "action" = "Foo/ACCEPT" }
      { "source" = "bloc" }
      { "dest"   = "fw" } }

  test Shorewall_rules.lns get rules_and_comments =
    { "rule"
        { "action" = "ACCEPT" }
        { "source" = "fw:127.0.0.1" }
        { "dest"   = "bloc" }
        { "proto"  = "tcp" }
        { "dest_port" = "-" }
        { "source_port" = "22" }
        { "dest_original" = "127.0.0.1" }
        { "rate_limit" = "22/s" }
        { "user_group" = "root/user" } }
    { "#comment" = "This should be a comment." }
    {}
    { "rule"
        { "action" = "Foo/ACCEPT" }
        { "source" = "bloc" }
        { "dest"   = "fw" } }

(*  test Shorewall_rules.lns get rules_comment_section =
    { "#comment" = "This is a comment." }
    { "SECTION" = "NEW" }
    { "rule"
        { "action" = "ACCEPT" }
        { "source" = "fw:127.0.0.1" }
        { "dest"   = "bloc" }
        { "proto"  = "tcp" }
        { "dest_port" = "-" }
        { "source_port" = "22" }
        { "dest_original" = "127.0.0.1" }
        { "rate_limit" = "22/s" }
        { "user_group" = "root/user" }
        { "#comment" = "This should also be a comment." } }
    { "#comment" = "This should be a comment." }
    {}
    { "rule"
        { "action" = "Foo/ACCEPT" }
        { "source" = "bloc" }
        { "dest"   = "fw" } }
*)

  test Shorewall_rules.lns put put_test_basic after
    set "/rule[last() + 1]/action" "DENY";
    set "/rule[last()]/source" "fw";
    set "/rule[last()]/dest" "bloc";
    set "/rule[last()]/proto" "tcp"
    = put_test_basic_result
