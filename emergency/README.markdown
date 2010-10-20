Emergency! Ambulance Problem
============================

http://www.cs.nyu.edu/courses/fall10/G22.2965-001/ambulance.html


Ambulance Planning

Dennis Shasha

Omniheurist Course

Computer Science

 
Description

The ambulance planning real-time problem is to rescue as many people as possible following a disaster. The problem statement identifies a set of ambulances at various mobile hospital nodes a set of delays on the edges, various people in need of help within a certain time. The problem is to get as many people to the hospitals on time as possible.

In our case, the graph is the Manhattan grid with every street going both ways. It takes a minute to go one block either north-south or east-west. Each hospital has an (x,y) location that you can determine when you see the distribution of victims. The ambulances need not return to the hospital where they begin. Each ambulance can carry up to four people. It takes one minute to load a person and one minute to unload up to four people. Each person will have a rescue time which is the number of minutes from now when the person should be unloaded in the hospital to survive. By the way, this problem is very similar to the vehicle routing problem about which there is an enormous literature. If anyone wants to take a break from programming, he/she may volunteer to look up that literature and propose some good heuristics.

So the data will be in the form: 
person(xloc, yloc, rescuetime)

Here is a typical scenario from Dr. Dobb's journal, except that the hospitals had fixed locations,
http://www.cs.nyu.edu/courses/fall10/G22.2965-001/ambustory.html

In our case, there will be 5 hospitals and 300 victims. Here is some typical data with only 50 victims (and again fixed hospitals) . You will have the usual 2 minutes of user time.
http://www.cs.nyu.edu/courses/fall10/G22.2965-001/ambudata.html

Here is data and the best solution we could find (from Tyler Neylon) but not in the format we want.
http://www.cs.nyu.edu/courses/fall10/G22.2965-001/ambusol.html

Here is the data from 2007 having 300 people and five hospitals (having fixed hospitals) Here is the winning strategy used by Arefin Huq but each ambulance could take only two people and had to return to the home hospital He was able to rescue 118 people, 20 more than the next best solution.
http://www.cs.nyu.edu/courses/fall10/G22.2965-001/ambuprob07
http://www.cs.nyu.edu/courses/fall10/G22.2965-001/arefinambulance
http://www.cs.nyu.edu/courses/fall10/G22.2965-001/arefinsave

Here is the data from 2009 having 300 people and five hospitals (having fixed hospitals) Rob Renaud was able to rescue 173 people. Here is a validator written by Yusuke Shinyama This tar.gz file includes README, sample_data, sample_result, and sample_wrong_result (which causes a validation error) files.
http://www.cs.nyu.edu/courses/fall10/G22.2965-001/ambu2009
http://www.cs.nyu.edu/courses/fall10/G22.2965-001/validator.tar.gz

Architect

The architect should specify a format for the output of each program and then validate the solutions. You are welcome to use Yusuke's validator as a starting point. If there is a problem with a proposed solution, please find a nice way to illustrate it.



