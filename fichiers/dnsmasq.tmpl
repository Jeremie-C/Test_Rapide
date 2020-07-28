{{/* Host main template  */}}
{{ define "host" }}
    {{ $host := .Host }}
    {{ $tld := .Tld }}
    {{ if eq $tld "" }}
        {{ range $index, $network := .Container.Networks }}
            {{ if ne $network.IP "" }}
address=/{{ $host }}/{{ $network.IP }}
            {{ end }}
        {{ end }}
    {{ else }}
        {{ range $index, $network := .Container.Networks }}
            {{ if ne $network.IP "" }}
address=/{{ $host }}.{{ $tld }}/{{ $network.IP }}
            {{ end }}
        {{ end }}
    {{ end }}
{{ end }}

{{/* Configuration for all - Use this container "HOST_TLD" environment variable */}}
{{ $ext := or ($.Env.HOST_TLD) "local" }}
{{ range $index, $container := $ }}
    {{ $hosts := coalesce $container.Name (print "*." $container.Name) }}
    {{ $host_part := split $container.Name "_" }}
    {{ $host_part_len := len $host_part }}

    {{ if eq $host_part_len 3 }}
        {{ template "host" (dict "Container" $container "Host" (print (index $host_part 0)) "Tld" $ext) }}
        {{ template "host" (dict "Container" $container "Host" (print (index $host_part 1) "." (index $host_part 0)) "Tld" $ext) }}
    {{ end }}

    {{ if eq $host_part_len 4 }}
        {{ template "host" (dict "Container" $container "Host" (print (index $host_part 0)) "Tld" $tld) }}
        {{ template "host" (dict "Container" $container "Host" (print (index $host_part 1) "." (index $host_part 0)) "Tld" $ext) }}
        {{ template "host" (dict "Container" $container "Host" (print (index $host_part 2) "." (index $host_part 1) "." (index $host_part 0)) "Tld" $ext) }}
    {{ end }}

    {{ template "host" (dict "Container" $container "Host" $container.Name "Tld" $tld) }}
{{ end }}

{{/* Configuration via "DNS_NAME" environment variables from other container */}}
{{ range $host, $containers := groupByMulti $ "Env.DNS_NAME" "," }}
    {{ range $index, $container := $containers }}
        {{ template "host" (dict "Container" $container "Host" (print $host) "Tld" "") }}
    {{ end }}
{{ end }}
