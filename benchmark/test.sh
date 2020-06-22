#!/bin/sh

pkill -f dotnet

dotnet build ./GiraffeBench/GiraffeBench.fsproj -c Release
wait $!
echo 'Giraffe build'
dotnet build ./SaturnBench/SaturnBench.fsproj -c Release
wait $!
echo 'Saturn build'
dotnet build ./SaturnEndpointBench/SaturnEndpointBench.fsproj -c Release
wait $!
echo 'Saturn-Endpoint build'

sh -c 'dotnet GiraffeBench/bin/Release/netcoreapp3.1/GiraffeBench.dll' &
G_PID=$!
echo ''
sleep 3
echo ''
echo 'Testing Giraffe'
wrk -t12 -c400 -d30s http://127.0.0.1:5000/user/test
echo ''
echo ''

kill -9 $G_PID
echo 'Giraffe tested'

sleep 5
echo ''

sh -c 'dotnet SaturnBench/bin/Release/netcoreapp3.1/SaturnBench.dll' &
S_PID=$!
echo ''
sleep 3
echo ''
echo 'Testing Saturn'
wrk -t12 -c400 -d30s http://127.0.0.1:5000/user/test
echo ''
echo ''
kill -9 $S_PID
echo 'Saturn tested'

sleep 5
echo ''

sh -c 'dotnet SaturnEndpointBench/bin/Release/netcoreapp3.1/SaturnEndpointBench.dll' &
S_PID=$!
echo ''
sleep 3
echo ''
echo 'Testing Saturn-Endpoint'
wrk -t12 -c400 -d30s http://127.0.0.1:5000/user/test
echo ''
echo ''
kill -9 $S_PID
echo 'Saturn-Endpoint tested'

sleep 5
