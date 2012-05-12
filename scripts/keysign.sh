#!/bin/bash
#
# GPG keysigning utility, because it's uberannoying to type all these commands
# over and over again.
#
# @author Isis Lovecruft, 0x2cdb8b35
# @version 0.0.2
# @license GPLv3

CCZE_IS_INSTALLED=$(dpkg -l | awk '/^ii/{print $2}' | grep ccze)

if [[ "$#" == "0" ]]; then
    echo -e "\033[40m\033[1;32m  Usage: ./keysign <keyID>  \033[0m"; echo;
    echo -e "\033[40m\033[0;32m  Requests the given keyID from the default keyserver, displays the fingerprint,  \033[0m"
    echo -e "\033[40m\033[0;32m  and enters the 'gpg --edit-key' menu for that key. From that menu, the user  \033[0m"
    echo -e "\033[40m\033[0;32m  will commonly want to type 'trust' to set the validity of the key, and then  \033[0m"
    echo -e "\033[40m\033[0;32m  type 'sign' to sign the key. More options can obviously be seen by typing 'help'.  \033[0m"
    echo -e "\033[40m\033[0;32m  Type 'save' to exit the edit-key menu.  \033[0m"; echo;
    echo -e "\033[40m\033[0;32m  Lastly, there is an option to send the newly signed key to the default keyserver,  \033[0m"
    echo -e "\033[40m\033[0;32m  store it locally only, or export it as an ascii-armoured file to give to the key's  \033[0m"
    echo -e "\033[40m\033[0;32m  owner.  \033[0m"; echo;
    echo -e "\033[40m\033[0;32m  If multiple keyIDs are specified, they will be processed in the order given.  \033[0m"; echo;
    exit 1
fi

for i in "$@"; do
    clear
    if [[ "$i" != "" ]]; then
        gpg --recv-key $i
        FP=$(gpg --fingerprint $i | grep fingerprint)
        echo; echo -e "\033[40m\033[1;36m  $FP  \033[0m"; echo; sleep 2;
        echo; echo -e "\033[40m\033[0;36m  Would you like to see $i's signatures before signing? (y/N): \033[0m"
        read opt
        case "$opt" in
            "Y"|"y"|"Yes"|"yes")
                if [[ "$CCZE_IS_INSTALLED" != "" ]]; then
                    gpg --list-sigs $i | ccze -A
                else
                    gpg --list-sigs $i | less
                fi
                ;;
            * )
                ;;
        esac
        echo -e "\033[40m\033[1;36m  Entering GPG edit-key menu... \033[0m"; echo;
        echo -e "\033[40m\033[0;36m  Type \033[40m\033[1;36m'trust'\033[0m \033[40m\033[0;36mto assign trust for key $i, before typing \033[40m\033[1;36m'sign'\033[0m\033[40m\033[0;36m to\033[0m"
        echo -e "\033[40m\033[0;36m  sign. Type \033[40m\033[1;36m'help'\033[0m \033[40m\033[0;36m for a list of more options, \033[40m\033[1;36m'quit'\033[0m\033[40m\033[0;36m to exit, or"
        echo -e "\033[40m\033[1;36m  'save'\033[0m \033[40m\033[0;36m to save. \033[0m"; echo;
        gpg --no-greeting --edit-key $i
        echo; echo -e "\033[40m\033[1;36m  Would you like to send the signed key to a keyserver? (Y/n): \033[0m"; echo;
        read choice
        case "$choice" in
            "N"|"n"|"No"|"no")
                echo -e "\033[40m\033[0;36m  Keeping signed key locally... \033[0m"; echo;
                echo -e "\033[40m\033[1;36m  Would you like to export this key to send to its owner? (Y/n): \033[0m"; echo;
                read yn
                case "$yn" in
                    "N"|"n"|"No"|"no")
                        echo -e "\033[40m\033[0;36m  Exiting... \033[0m"; echo;
                        exit 0
                        ;;
                    * )
                        echo -e "\033[40m\033[0;36m  Saving as "$HOME"/"$i"-signed.asc... \033[0m"; echo;
                        gpg -a -o $HOME/$i-signed.asc --export $i
                        exit 0
                        ;;
                esac
                ;;
            * )
                gpg --send-key $i; echo;
                exit 0
                ;;
        esac
    fi
done
