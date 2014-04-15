# Example client using the zeroconf package.
package require Tcl 8.5
package require zeroconf

# Called when a service is resolved (details are retrieved).
proc serviceResolved {serviceName hostname port txtRecords} {
    puts "Resolved: $serviceName on $hostname:$port"
    puts "   txtRecords: $txtRecords"

    # Try resolving an address for the hostname
    ::zeroconf::resolve_address $hostname [list addressResolved $hostname]
}

# Called when a service address is resolved.
proc addressResolved {name address} {
    puts "Host \"$name\" resolved to: $address"
}

# Called when a service is found.
proc serviceFound {regType action name domain} {
    puts "$regType on $name.$domain: $action"
    if {$action eq "add"} {
        ::zeroconf::resolve $name $regType $domain serviceResolved
    }
}

# Start looking for ssh services.
::zeroconf::browse start _ssh._tcp [list serviceFound _ssh._tcp]

# Start looking for myservice services.
::zeroconf::browse start _myservice._tcp [list serviceFound _myservice._tcp]
::zeroconf::browse start _myotherservice._tcp [list serviceFound _myotherservice._tcp]

# Enter the event loop.
vwait forever
