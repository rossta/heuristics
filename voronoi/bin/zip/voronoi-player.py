##############################################################################
## Voronoi architecture test program
## 10/19/2003
## 
## Charles J. Scheffold
## cjs285@nyu.edu
##
## Heuristic Problem Solving
## Fall 2003
##############################################################################

import socket
import string
import random

from time import sleep

HOST = '127.0.0.1'
PORT = 20000

#=============================================================================
# This function reads one character at a time from a socket until a newline
# is received.
#=============================================================================

def SReadLine (conn):
	data = ""
	while True:
		c = conn.recv(1)
		if not c:
			sleep (1)
			break
		data = data + c
		if c == "\n":
			break

	return data

#=============================================================================
# MAIN PROGRAM begins here
#=============================================================================

# Initialize random number generator
random.seed ()

# Open connection to voronoi server
s = socket.socket (socket.AF_INET, socket.SOCK_STREAM)
s.connect ((HOST, PORT))

print "Connected to", HOST, "port", PORT

# Read status line
data = SReadLine (s)
line = string.strip (data)

# Split status fields into a list
status = string.split (line)

print "BoardSize:", status[0]
print "NumTurns:", status[1]
print "NumPlayers:", status[2]
print "MyPlayerNumber:", status[3]
print

# Save the board size for later
BoardSize = int (status[0])

Moves = []

while True:
	# Read one line from server
	data = SReadLine (s)

	# If it's empty, we are finished here
	if data == None or data == '':
		break
	
	# Strip the newline
	line = string.strip (data)

	# Receive YOURTURN
	if (line == "YOURTURN"):		
		print
		print line

		# Generate a random move		
		x = random.randint (0, BoardSize)
		y = random.randint (0, BoardSize)

		# If it's been done, generate until
		# we get a fresh one.
		while(x,y) in Moves:
			x = random.randint (0, BoardSize)
			y = random.randint (0, BoardSize)

		# Save move for duplicate checking
		Moves.append ((x,y))

		print "MY MOVE:", (x,y)

		# Wait a little (so we can watch the game at a decent speed)
		# and then send the move
		sleep (.5)
		s.send ("%d %d\n" % (x,y))

	# Receive WIN
	elif (line == "WIN"):
		print ("I WIN!")
		break
	
	# Receive LOSE
	elif (line == "LOSE"):
		print ("I LOSE :(")
		break

	# Receive an opponent's move data
	else:
		move = string.split (line)
		Moves.append ((move[0], move[1]))
		print "OPPONENT MOVE:", move

# Poof!		
s.close ()	