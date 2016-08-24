library(pdq)

# Arrival rate into the network:
arate <- 0.50
# Node service times:
stime <- c(1.0,2.0,1.0)
# Set up traffic eqns from network diagram:
# L1 = 0.5 + 0.2 L3
# L2 = 0.5 L1
# L3 = 0.5 L1 + 0.8 L2
# Rearrange the terms into matrix form:
#  1.0 L1 + 0.0 L2 - 0.2 L3 = 0.5
# -0.5 L1 + 1.0 L2 + 0.0 L3 = 0.0
# -0.5 L1 - 0.8 L2 + 1.0 L3 = 0.0
# All diagonal coeffs should be 1.0
# Map the coeffs into R matrices:
A <- matrix(c(1.0,0.0,-0.2, -0.5,1.0,0.0, -0.5,-0.8,1.0), 3, 3, byrow=TRUE)
B <- c(0.5,0.0,0.0)
# Solve for the local throughputs (L):
L <- solve(A,B)
# Use L matrix to calculate visit ratios at each router
v <- c(L[1]/arate, L[2]/arate, L[3]/arate)
# Service demands at each node:
sd <- c(v[1]*stime[1], v[2]*stime[2], v[3]*stime[3])
#
# Set up PDQ-R model of the Jackson network
#------------------------------------------
pdq::Init("Jackson Network in PDQ-R")
wname <- "Traffic"
rname <- c("Router1", "Router2", "Router3")

# Create the traffic arriving into the network
pdq::CreateOpen(wname, arate)
pdq::SetWUnit("Msg")
pdq::SetTUnit("Sec")
# Create network routers
for(i in 1:length(rname)) {
  pdq::CreateNode(rname[i], CEN, FCFS)
  pdq::SetDemand(rname[i], wname, sd[i])
}

pdq::Solve(CANON)
pdq::Report()

print("Check traffic eqns:")
cat(sprintf("L1: %f == %f: 0.5 + 0.2 L3\n", L[1], (0.5 + 0.2*L[3]), L[3]))
cat(sprintf("L2: %f == %f: 0.5 L1\n", L[2], (0.5*L[1])))
cat(sprintf("L3: %f == %f: 0.5 L1 + 0.8 L2\n", L[3], (0.5*L[1] + 0.8*L[2])))

Running this R script, produces the following PDQ report.

PRETTY DAMN QUICK REPORT         
==========================================
  ***  on   Fri Sep  4 06:12:57 2015     ***
  ***  for  Jackson Network in PDQ-R     ***
  ***  PDQ  Version 6.2.0 Build 082015   ***
  ==========================================
  
  ==========================================
  ********    PDQ Model INPUTS      ********
  ==========================================
  
  WORKLOAD Parameters:
  
  Node Sched Resource   Workload   Class     Demand
---- ----- --------   --------   -----     ------
  1  FCFS  Router1    Traffic    Open      1.2195
1  FCFS  Router2    Traffic    Open      1.2195
1  FCFS  Router3    Traffic    Open      1.0976

Queueing Circuit Totals
Streams:   1
Nodes:     3

Traffic        0.5000        3.5366


==========================================
  ********   PDQ Model OUTPUTS      ********
  ==========================================
  
  Solution Method: CANON

********   SYSTEM Performance     ********
  
  Metric                     Value    Unit
------                     -----    ----
  Workload: "Traffic"
Number in system          4.3412    Msg
Mean throughput           0.5000    Msg/Sec
Response time             8.6824    Sec
Stretch factor            2.4550

Bounds Analysis:
  Max throughput            0.8200    Msg/Sec
Min response              3.5366    Sec


********   RESOURCE Performance   ********
  
  Metric          Resource     Work              Value   Unit
------          --------     ----              -----   ----
  Capacity        Router1      Traffic               1   Servers
Throughput      Router1      Traffic          0.5000   Msg/Sec
In service      Router1      Traffic          0.6098   Msg
Utilization     Router1      Traffic         60.9756   Percent
Queue length    Router1      Traffic          1.5625   Msg
Waiting line    Router1      Traffic          0.9527   Msg
Waiting time    Router1      Traffic          1.9055   Sec
Residence time  Router1      Traffic          3.1250   Sec

Capacity        Router2      Traffic               1   Servers
Throughput      Router2      Traffic          0.5000   Msg/Sec
In service      Router2      Traffic          0.6098   Msg
Utilization     Router2      Traffic         60.9756   Percent
Queue length    Router2      Traffic          1.5625   Msg
Waiting line    Router2      Traffic          0.9527   Msg
Waiting time    Router2      Traffic          1.9055   Sec
Residence time  Router2      Traffic          3.1250   Sec

Capacity        Router3      Traffic               1   Servers
Throughput      Router3      Traffic          0.5000   Msg/Sec
In service      Router3      Traffic          0.5488   Msg
Utilization     Router3      Traffic         54.8780   Percent
Queue length    Router3      Traffic          1.2162   Msg
Waiting line    Router3      Traffic          0.6674   Msg
Waiting time    Router3      Traffic          1.3349   Sec
Residence time  Router3      Traffic          2.4324   Sec


[1] "Check traffic eqns:"
L1: 0.609756 == 0.609756: 0.5 + 0.2 L3
L2: 0.304878 == 0.304878: 0.5 L1
L3: 0.548780 == 0.548780: 0.5 L1 + 0.8 L2

