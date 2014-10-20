(* Parses /etc/shorewall/rules *)

module Shorewall_rules =
  autoload xfm

  let filter = incl "/etc/shorewall/rules"

  let eol = del /[ \t]*\n/ "\n"
  let comment_or_eol = Util.comment_or_eol
  let indent = del /[ \t]*/ "\t"

  let comment = Util.comment

  let empty = Util.empty
  let word = /[^# \t\n]+/
  let del_ws = del /[ \t]*/ ""
  let sep_tab = del /[ \t]+/ "\t"
  let sep_opt_tab = Util.del_opt_ws "\t"

  let action = [ del_ws . label "action" . store word ]
  let source = [ sep_tab . label "source" . store word  ]
  let dest = [ sep_tab . label "dest" . store word  ]
  let proto = [ sep_tab . label "proto" . store word ]
  let dest_port = [ sep_tab . label "dest_port" . store word  ]
  let source_port = [ sep_tab . label "source_port" . store word  ]
  let dest_original = [ sep_tab . label "dest_original" . store word  ]
  let rate_limit = [ sep_tab . label "rate_limit" . store word ]
  let user_group = [ sep_tab . label "user_group" . store word ]

  let opt (l1:lens) (l2:lens) = (l1 . l2)?

  let rule = action . source . dest . opt proto (opt dest_port (opt source_port (opt dest_original (opt rate_limit user_group?))))

  let section = del_ws . key /SECTION/ . sep_tab . store word

  let directive = ( [ section . comment_or_eol ] | [ label "rule" . rule . comment_or_eol ]  )

  let lns =  ( directive | comment | empty )*

  let xfm = transform lns filter
