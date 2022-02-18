source $ZSHAI_MODULES_DIR/available/zshai-prompt.sh

go(){
  local cmds="lm superprompt;lm zshai-prompt;lm tapdir;"
  eval $cmds
  prompt-info "Command" "$cmds"
}

#PROMPT="╰❮⦗❯❯➤ ";return


{
##'DEBUG'##
ARLINE="AR1=$AR1 AR2=$AR2"
AR2R="❯"

##'COLORS'##
  PURPLE=12
  LIGHTPURPLE=5
  DARKPURPLE=13
  BRIGHTPURPLE=14
  GRAY=8
  WHITE=15
  DIMWHITE=7

  ##'BASE COLORS'##
  CLR1A=$PURPLE
  CLR1B=$DARKPURPLE
  CLR1C=$BRIGHTPURPLE
  CLR1D=$LIGHTPURPLE
  CLR1=$BRIGHTPURPLE
  CLR2=$GRAY

  ##'GRAY'##
  GR1="233"
  GR2="234"
  GR3="236"
  GR4="238"
  GR5="240"
  CGL1="250"
  CG1="250"
  GR6="252"
  GR2="248"
  GRAY_3="246"
  GRAY_4="244"
  GRAY_5="242"

  ##'HIGHLIGHT'##
  HLA1="6"
  HLA2="45"
  HLA3="39"
  HLA4="33"
  HLA5="21"

  ##'RED'##
  RED1=1
  RED2=9
  RED3=124
  RED4=88
  RED5=52

WHITE=%F{WHITE}
CFW=%F{WHITE}

##'THEME COLOR SETTINGS'##
BASE_LIGHT="250"
CLR_BASE="$CLR1"
CLR_PWD_START="$CLR1"
CLR_PWD_TAIL="$CLR2"
C1B="┍"

##'PALETTE'##
F1="%F{white}%K{blue}%B"
F2="%F{$CLR1}%B%K{blue}"
F3="%F{white}%K{black}%B"
F4="%B%F{$CLR1}%K{black}"
F0="%b%F{$CLR1}%k"
F5="%b%F{$CLR1}%K{white}"
F6="%b%F{$CLR_BASE}%K{$BASE_LIGHT}"

##'BOX DRAWING'##
C1=╭─
H1=─
C2=─╮ C3=╰─ C4=╯

V1=│
V2=├─
C1B="┍"
##'BLOCKS'##
FADE1=█▓▒░ FADE2=░▒▓█ B1=███▒░ B2=░▒███ ABL=▓▒░ ABR=░▒▓

##'ARROWS'##
AR1= AR2= AR3=❯ AR4=➤ AR5=➣
AL1= AL2= AL3=❮ AL4=➤ AL5=➣ AL5B=➣
TIP_CORNER='╰─%F{red}➤%F{white}'

##'BRACKETS'##
BR1=〔
BR2=【
BL1=〕
BL2=】

##'BARS'##
DRAGON_TAIL_L=‹‹❮█ DRAGON_TAIL_R=█❯➤➢➣
DTL="$DRAGON_TAIL_L" DTR="$DRAGON_TAIL_R"
##'VARS'##
USERHOST="%n@%m"
USER="$F1%n"
USERHOST="$F1$USERHOST"
NL=$'\n'
PSPATH="%~"
P1='%~/%b%k%f'
SEGSEP=' $AR2 '
CWD='%{${${PWD}:t}}'
DATE="%D{%a %b %d} %D{%I:%M:%S%P}"

##'SEGMENT OPTIONS'##
CLOSING1="${B1}"
CLOSING2="$CLOSING1 $ARROW_FADE_RIGHT"
SEGMENT_SEPRATOR_LIGHTEN="%b%F{7}$AR2%F{white}%b"
PFX="ZSHAI_PROMPT_"
LINE_COLOR="${PR_BLUE}"
EXIT_CODE='%(?..${LINE_COLOR}exitcode=[${EXIT_CODE_COLOR}%?${LINE_COLOR}] )'

##'ICONS'##
CIRCLE="◌"
STATUS=""
TRUE=✔
FALSE=✕

##'CHARS'##
PS1=''
SEP1=""
SEP2="/"
SP1=' '
SP2='  '

##'PS1-TIP'##
PS1_LINE1_TIP=$'
%F{$CLR2}$AR1
%F{$CLR2B}
%F{$GR3}${AR2}
%F{$GR3}${AR3}
%F{$GR5}${AR4}'
PS1_LINE1_TIP=${PS1_LINE1_TIP//$'\n'}
#TAPKEY=$KEYS
##'TIP GRAY'##
TIP_ARROW_GRAY='
%B%K❮
%B%F{$CLR2}%K❯
%B%F{$GR3}$AR2
%B%F{$GR4}$AR3
%B%F{$GRAY_4}${AL4} '
#❯➤➤
TAPKEY=${TAPKEY:-}
##'TIP GRAY BRACKETS'##

TAP_INDICATOR_ON='%B%F{12}%K❮$TAPKEY%B%K{$RED1}❯'

TAP_INDICATOR_OFF=''
#⸦  ▁▂▃⦞⦑࿌ ⦒⦘⥤⥤⥤❯⦑❯⦣▂▁
#╰⸦⸧⸧⸧⸧ ❮⦗❯❯➤
#
#⥢
#⸦⸧⸧⸧⸧⸧⸧ ⸨ ⸩
#⟈⸧⸧⸧ ⟉
#
#╰⸦⦗⭘ ⦘⸧⸧⸧⸧⸧❯⦗⸧⸧⸧⸧❯《❯❯❯
#
#╰⸦⦗⬥
#❪❫ 
#❬❭
#❮❯
#❰❱
#❲❳
#❴ 
#❨❩
#⦗⦘
#⎲⎲ ⎳ ⎳⎳
#⦋⦌
#┍┍┎⎲ ⎳‐‒—― ▅▆ ▆▃█▁▂▃
#╰❮
#⦇⦈
#⦅⦆⊹
#⦑⦒⦒
#⸂❮ ‐ ‑ ‒ – — ―⦗⬬⦗⬬ ⸪ ⸫ ⸬ ⸭⸃
#⸠ ⸡
#⥏⥦⥦⦛⦢⥦ ⥦ ⦛⥤⦣
#⦤⥏⥤⥤⥤⦛⥦ ⌤ ⌥⌙   ⥦ ⥤⥤ ⥤⦥
#⦞⥦⥦⥏⥐



TIP_ARROW_BRACKETS='
%K
%b%F{$GR6}⦗
$(status_indicator)
%b%F{$GR5}❯
%b%F{$GR3}$AR2
%b%F{$GR4}$AR3
%b%F{$GRAY_4}${AL4} '


##'TIP BLUE'##
TIP_ARROW_BLUE='
%F{$GRAY_3}${CIRCLE}
%F{$GRAY_3}${AR2R}
%F{$HIGHLIGHT_2}${AR2}
%F{$HIGHLIGHT_2}${AR3}
%F{$GR5}
%F{$GRAY_3}
%F{$HLA1}➤ '

##'TIP RED'##
TIP_ARROW_RED='
%F{$RED4}${AR2R}
%F{$RED3}${AR2}
%F{$RED2}${AR3}
%F{$RED1}${AR4}'

##'GUNS'##
GUN="︻デ═一"

##'SEGMENT OPTIONS'##
PATH_BODY="%b%F{7}$AR2%F{white}%b"
CLOSING1="${B1}"
CLOSING2="$CLOSING1 $ARROW_FADE_RIGHT"
SEGMENT_SEPRATOR_LIGHTEN="%b%F{7}$AR2%F{240}%b" PFX="ZSHAI_PROMPT_" LINE_COLOR="${PR_BLUE}" 
EXIT_CODE='%(?..${LINE_COLOR}exitcode=[${EXIT_CODE_COLOR}%?${LINE_COLOR}] )'
DIR_SEGMENT=""
SEP3="▊▋▌▍▎▏"
B3="▐░▒▓"
##'PS1 OPTIONS'##
PS1_TOPLEFT="  %B%F{$CLR1}╭─── ["

##'FUNCTIONS'##
typeset -g  lines
countlines(){
add=$1
unset PS2
((lines+=add))

echo $lines
}
base_icon() { [[ "${${(%)PSPATH}:0:1}" = '~' ]] && { [[ "${${(%)PSPATH}:h}" = '~' ]] && { echo -n ' ' } || { echo 'ڈ ' }} || { echo -n ' ' }}
base_head() { echo "${${${PWD}:h2:t}}" }
base_body_head() { [[ "${${PWD}:h}" = "$HOME" ]] && echo || echo "${${${PWD}:1:h}//\// $SEGMENT_SEPRATOR_LIGHTEN }"}
path_body() {
  AR1="%F{14}%K{8}%F{14}$AR1%F{240}"
  #first dir
  #TOPLEVEL_DIR='/';
  part1=${${${${PWD//${PWD:t}}//${PWD:h2}}:1}:s:/:$(echo " $AR1 ")}
  #echo $part1
  print -P ${part1//\// $DIR_SEGMENT }


}
status_indicator() {
#off="-"
INDICATOR_STATUS=""
#echo -n $WIDGET_INDICATOR_STATUS
#echo -n "$KEYS"
[[ ! -z $KEYS ]] && [[ $KEYS =~ '[0-9]' ]] && echo $RED$KEYS$RESET || echo "$INDICATOR_STATUS"
}
post_prompt() { unset TAPKEY }
path_toplevel() { echo "${${PWD}:h2}" }
parent_is_home() { [[ "${PWD:h}" = "/" ]] && PARENT_IS_HOMEDIR="true" }
size() { eval echo $#1 }

##'COLOR NRS'##
C01A=14
C01B=254
CLR1F=15
CLR1B=12
CLR2F=6
CLR2B=12
CLR3F=15
CLR3B=14
CLR4F=240
CLR4F=8
CLR2HL=15
W1=255

##'COLOR ASSIGNMENTS'##
# B=background
# F=foreground
# HL=highlight
F_ICON=${C01A}
B_ICON=${C01B}
F_HEAD=${CLR1F}
B_HEAD=${CLR1B}
F_BODY=${CLR2F}
B_BODY=${CLR2B}
F_TAIL=${CLR3F}
B_TAIL=${CLR3B}
SEP1=${CLR2HL}

F_ICON=${C01A}
B_ICON=${C01B}
F_HEAD=${CLR1F}
B_HEAD=${CLR1B}
F_BODY=254
B_BODY=8
F_TAIL=15
B_TAIL=8
SEP1=${CLR2HL}


##'SEGMENT OPTIONS'##
CLOSING1="${B1}"
CLOSING2="$CLOSING1 $ARROW_FADE_RIGHT"
SEGMENT_SEPRATOR_LIGHTEN="%b%F{0}%K{8}$AR2%F{$F_BODY}%K{$B_BODY}"
PFX="ZSHAI_PROMPT_"
LINE_COLOR="${PR_BLUE}"
EXIT_CODE='%(?..${LINE_COLOR}exitcode=[${EXIT_CODE_COLOR}%?${LINE_COLOR}] )'



##'DYNAMIC EVALUATION'##
P1_ICON='%b${F5}%K{$C01B}$SP1$(base_icon)%F{$BASE_LIGHT}%K{$CLR1}$AR1'
#${F5}${P1_ICON}$(base_head)
#ڄ
ICON_SUFFIX=' '
ICON_PREFIX=''
ICON='
%B${F5}%K{255}${SP1}$(base_icon)${ICON_SUFFIX}%F{15}'
P1_ICON_HEAD='
$ICON_PREFIX
%b%F{14}%K{255}$(base_icon)$ICON_SUFFIX
%b%F{15}%K{13}$AR1$SP1
%b%F{15}%K{13}$(base_head)$SP1
%b%F{13}%K{14}$AR1'
P1_BODY='%F{white}$(path_body)'
P1_TAIL='${${${(%)PSPATH}:t}}'

#SEGMENTS=(
# [P1_HEAD]='$(base_head)'
# [P1_BODYHEAD]='$(base_body_head)'
#)

##'PS1-PROMPT_PATH'##
PROMPT_PATH="
%F{7}%K{12}
%F{12}%K{15}-----$SP1
%b%K{15}---------${P1_ICON_HEAD}
%F{13}%K{14}----$AR2$SP1
%b%F{$F_BODY)----${P1_BODY}
%F{15}%K{8}%B----$SP1${P1_TAIL} "
PROMPT_PATH=${${PROMPT_PATH//$'\n'}//-}
ZSHAI_PROMPT=''

##'START PS1'##
PS1_LINE="
${C1B}${F5}${FADE1}
${PROMPT_PATH}
${F0}${PS1_LINE1_TIP}"
PS1_LINE=$'\n'${${PS1_LINE//$'\n'}}
PS1_LINE1="$C1$GUN"
ZSHAI_PROMPT+="$PS1_LINE"

##'START PS1-LINE2 LEFT OPTIONS'##
TIP_V1="${TIP_ARROW_GRAY}"
TIP_V2="%F{24}❮${TIP_ARROW_BLUE}"
TIP_V3="%F{white}❮${TIP_ARROW_RED}"
TIP_B1="${TIP_ARROW_BRACKETS}"
TIP_CORNER='╰─%F{red}➤%F{white}'
LINE2="%b%k%f╰${TIP_B1}%b%k%f${SP}"
ZSHAI_PROMPT+=${NL}${LINE2//$NL}

##'PS2'##
#PS2="❮$TIP_ARROW $GUN"
ZSHAI_PROMPT2=" %F{14}⦗%K{0} "
PS2=$ZSHAI_PROMPT2

##'RIGHT PROMPT'##
PS1='$BLANK_PROMPT'
PS1=$ZSHAI_PROMPT

##'PROMPT FORMATS'##
PROMPT_STANDARD="PS1"
PROMPT_TRANSIENT=">"
#PROMPT="$PS1"
PROMPT_LINES=2
PROMPT="$PS1"

}

export RPROMPT='%t $SSH_CONNECTION'
