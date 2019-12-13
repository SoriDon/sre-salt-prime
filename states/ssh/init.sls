# This state assumes Debian 9 (Stretch) or Debian 10 (buster). For each section
# below, the stanzas are in order they appear in /etc/ssh/sshd_config.


{{ sls }} installed packages:
  pkg.installed:
    - pkgs:
      - openssh-server


{{ sls }} service:
  service.running:
    - name: ssh
    - enable: True
    - require:
      - pkg: {{ sls }} installed packages


{{ sls }} backup original config:
  file.copy:
    - name: /etc/ssh/sshd_config.orig
    - source: /etc/ssh/sshd_config
    - force: False
    - preserve: True


### Changes


{{ sls }} decrease LoginGraceTime:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^[# ]*LoginGraceTime .*
    - repl: LoginGraceTime 30s
    - flags:
      - IGNORECASE
      - MULTILINE
    # The default is 120 seconds.
    - append_if_not_found: True
    - require:
      - file: {{ sls }} backup original config
    - watch_in:
      - service: {{ sls }} service


{{ sls }} disable PermitRootLogin:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^[# ]*PermitRootLogin .*
    - repl: PermitRootLogin no
    - flags:
      - IGNORECASE
      - MULTILINE
    # The default is prohibit-password.
    - append_if_not_found: True
    - require:
      - file: {{ sls }} backup original config
    - watch_in:
      - service: {{ sls }} service


# TCPKeepAlive is disabled in favor of ClientAliveInterval and
# ClientAliveCountMax. TCPKeepAlive too often results in disruption due to
# WiFi roaming and route flaps.
{{ sls }} disable TCPKeepAlive:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^[# ]*TCPKeepAlive .*
    - repl: TCPKeepAlive no
    - flags:
      - IGNORECASE
      - MULTILINE
    # The default is yes
    - append_if_not_found: True
    - require:
      - file: {{ sls }} backup original config
    - watch_in:
      - service: {{ sls }} service


# A ClientAliveInterval of 30s combined with a ClientAliveCountMax of 60 will
# result in disconnections of unresponsive clients after half an hour.
#
# The relatively short ClientAliveInterval should ensure aggressive TTLs do not
# severe connections. The larger ClientAliveCountMax should allow brief
# interruptions without disrupting work.
{{ sls }} set ClientAliveInterval:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^[# ]*ClientAliveInterval .*
    - repl: ClientAliveInterval 30s
    - count: 1
    - flags:
      - IGNORECASE
      - MULTILINE
    # The default is 0
    - append_if_not_found: True
    - watch_in:
      - service: {{ sls }} service
    - require:
      - file: {{ sls }} remove duplicate ClientAliveInterval


{{ sls }} set ClientAliveCountMax:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^[# ]*ClientAliveCountMax .*
    - repl: ClientAliveCountMax 60
    - flags:
      - IGNORECASE
      - MULTILINE
    # The default is 3
    - append_if_not_found: True
    - require:
      - file: {{ sls }} backup original config
    - watch_in:
      - service: {{ sls }} service


{% if grains['oscodename'] == "stretch" -%}
  {% set pattern = "ClientAliveInterval 420\nClientAliveInterval 120\n" -%}
{% else -%}
  {% set pattern = "ClientAliveInterval 120\n" -%}
{% endif -%}
{{ sls }} remove duplicate ClientAliveInterval:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: {{ pattern }}
    - repl: ""
    - flags:
      - IGNORECASE
    - append_if_not_found: False
    - require:
      - file: {{ sls }} backup original config
    - watch_in:
      - service: {{ sls }} service


{{ sls }} append group sudo StreamLocalBindUnlink:
  file.append:
    - name: /etc/ssh/sshd_config
    - text: |

        Match Group sudo
            StreamLocalBindUnlink yes
    - require:
      - file: {{ sls }} backup original config
    - watch_in:
      - service: {{ sls }} service


### Ensure Authentication Defaults


{{ sls }} ensure PubkeyAuthentication is enabled:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^ *PubkeyAuthentication .*
    - repl: '#PubkeyAuthentication yes'
    - flags:
      - IGNORECASE
      - MULTILINE
    # The default is yes.
    - append_if_not_found: False
    - require:
      - file: {{ sls }} backup original config
    - watch_in:
      - service: {{ sls }} service


{{ sls }} ensure PasswordAuthentication is disabled:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^ *PasswordAuthentication .*
    - repl: PasswordAuthentication no
    - flags:
      - IGNORECASE
      - MULTILINE
    # The default is no.
    - append_if_not_found: False
    - require:
      - file: {{ sls }} backup original config
    - watch_in:
      - service: {{ sls }} service


{{ sls }} ensure ChallengeResponseAuthentication is disabled:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^ *ChallengeResponseAuthentication .*
    - repl: ChallengeResponseAuthentication no
    - flags:
      - IGNORECASE
      - MULTILINE
    # The default is no.
    - append_if_not_found: False
    - require:
      - file: {{ sls }} backup original config
    - watch_in:
      - service: {{ sls }} service
