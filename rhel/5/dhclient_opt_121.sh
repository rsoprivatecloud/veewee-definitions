#!/bin/bash

/bin/cat > /etc/dhclient.conf <<"END"
option classless-static-routes code 121 = array of unsigned integer 8;
request;
END

/bin/cat > /etc/dhclient-exit-hooks <<"END"
#
# This file is called from /sbin/dhclient-script after a DHCP run.
#

#
# parse_option_121:
# @argv: the array contents of DHCP option 121, separated by spaces.
# @returns: a colon-separated list of arguments to pass to /sbin/ip route
#
function parse_option_121() {
        result=""

        while [ $# -ne 0 ]; do
                mask=$1
                shift

                # Is the destination a multicast group?
                if [ $1 -ge 224 -a $1 -lt 240 ]; then
                        multicast=1
                else
                        multicast=0
                fi

                # Parse the arguments into a CIDR net/mask string
                if [ $mask -gt 24 ]; then
                        destination="$1.$2.$3.$4/$mask"
                        shift; shift; shift; shift
                elif [ $mask -gt 16 ]; then
                        destination="$1.$2.$3.0/$mask"
                        shift; shift; shift
                elif [ $mask -gt 8 ]; then
                        destination="$1.$2.0.0/$mask"
                        shift; shift
                else
                        destination="0.0.0.0/$mask"
                fi

                # Read the gateway
                gateway="$1.$2.$3.$4"
                shift; shift; shift; shift

                # Multicast routing on Linux
                #  - If you set a next-hop address for a multicast group, this breaks with Cisco switches
                #  - If you simply leave it link-local and attach it to an interface, it works fine.
                if [ $multicast -eq 1 ]; then
                        temp_result="$destination dev $interface"
                else
                        temp_result="$destination via $gateway dev $interface"
                fi

                if [ -n "$result" ]; then
                        result="$result:$temp_result"
                else
                        result="$temp_result"
                fi
        done

        echo "$result"
}


function modify_routes() {
        action=$1
        route_list="$2"

        IFS=:
        for route in $route_list; do
                unset IFS
                /sbin/ip route $action $route
                IFS=:
        done
        unset IFS
}

if [ "$reason" = "BOUND" -o "$reason" = "REBOOT" -o "$reason" = "REBIND" -o "$reason" = "RENEW" ]; then
        # Delete old routes, if they exist
        if [ -n "$old_classless_static_routes" ]; then
                modify_routes delete "$(parse_option_121 $old_classless_static_routes)"
        fi

        # Add new routes, if they exist...
        if [ -n "$new_classless_static_routes" ]; then
                modify_routes add "$(parse_option_121 $new_classless_static_routes)"
        fi
fi
END
