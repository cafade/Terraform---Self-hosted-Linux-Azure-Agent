#!/bin/sh

su - testing-user -c "
mkdir myagent
cd myagent
wget -O vsts-agent-linux-x64-2.190.0.tar.gz https://vstsagentpackage.azureedge.net/agent/2.190.0/vsts-agent-linux-x64-2.190.0.tar.gz
tar zxvf ./vsts-agent-linux-x64-2.190.0.tar.gz >/dev/null  2>&1
./config.sh --unattended --agent "${AZP_AGENT_NAME:-$(cat /proc/sys/kernel/hostname)}" --url "https://dev.azure.com/<ORG_NAME>" --auth PAT --token "<PAT_TOKEN>" --pool "Default" --replace --acceptTeeEula $ wait $!
./run.sh &
exit
"
