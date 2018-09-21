Project2 README


Team Members 

Sourabhreddy Medapati       17439921
Tanya Singhal               82547875


What is working ?

1.      Convergence of Gossip algorithm for all topologies.
2.      Convergence of Push-Sum algorithm for all topologies.

Gossip and Push-sum algorithms have been successfully implemented for the 4 given topologies of “full”, “imp2D” , “2D” and “line”. A deep level of intuition about the working of these algorithms was gained by implementing it for various topologies. 

The program can be run as follows : “./project2 1000 full gossip” . Accepted values for topology are “full”, “imp2D” , “2D” and “line” and for algorithm are “gossip” and “push-sum” 

Sample Results : 

./project2 10 full gossip

2/10 nodes have heard the rumor
3/10 nodes have heard the rumor
4/10 nodes have heard the rumor
5/10 nodes have heard the rumor
6/10 nodes have heard the rumor
7/10 nodes have heard the rumor
8/10 nodes have heard the rumor
9/10 nodes have heard the rumor
System converged in 55 ms

./project2 10 full push-sum

1/10 nodes converged, latest ratio: 5.500000000664366
2/10 nodes converged, latest ratio: 5.5000000004204015
3/10 nodes converged, latest ratio: 5.499999999261883
4/10 nodes converged, latest ratio: 5.500000000689282
5/10 nodes converged, latest ratio: 5.500000000410399
6/10 nodes converged, latest ratio: 5.500000000446189
7/10 nodes converged, latest ratio: 5.500000000300905
8/10 nodes converged, latest ratio: 5.500000000294543
System converged with ratio 5.500000000288128 in 1671



Gossip Implementation:

For Gossip protocol the convergence of the whole network occurs when 90% of the nodes have heard the rumor. This assumption was taken keeping in consideration the fact that the main motto of randomzed gossip is to spread information in a distributed network. The more the number of neighbours available to spread the gossip to the faster the information disseminates.

Interesting Observations :

1) time(full) < time(imp2D) < time(2D) < time(line)

2) Comparing the performance between imp2D and 2D topologies, the addition of just 1 extra neighbour in imperfect 2D makes a noticeable impact on the convergence time.

3) For a fully connected network, it takes O(logn) rounds to propagate the rumor which is comparable to other multicast approaches like spanning tree and centralized dissemination. Gossip along with providing low latency it also is robust to failures and is fault tolerant by default given its random nature.

4) For all topologies except line the convergence time is in the order of logN, for line it could reach in the order of N^2 . Fully connected network yields the fastest results in any case.  



Push-sum Implementation:

We read the original paper “Gossip based computation of Aggregate Information” and implemented the same. Every node starts by sending a message to itself and in later rounds all of the s,w pairs received are summed up and (s/2, w/2) is sent to a random neighbour as well as to itself. Network converged when 90% of nodes achieve convergence, individual nodes converge when s/w ratio doesn’t change more than 0.000000001 in 3 consecutive rounds. 

The algorithm converges very fast and is an excellent example of group based computation. If we set values of w in one node and to 0 in rest nodes, we can compute sum also. 

The performance order is also the same as in Gossip.  




What is the largest network you managed to deal with for each type of topology and algorithm ?

For Gossip, largest network we tried out with are as follows :

1) Full network     : 10000 nodes
2) Imperfect 2D     : 4000 nodes
3) 2D               : 6000 nodes
4) line             : 3000 nodes

For Push-sum, largest network we tried out with are as follows :

1) Full network      : 400 nodes
2) Imperfect 2D      : 100 nodes
3) 2D                : 450 nodes
4) line              : 100 nodes
