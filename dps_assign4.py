import psycopg2
import os
import sys

def RangeQuery(ratingMinimumValue, ratingMaximumValue, openconnection, outputpath):
	connection = openconnection
	cursor = connection.cursor()
	rangePrefix = "RangeRatingsPart"
	cursor.execute("select *from RangeRatingsMetadata;")
	metarows = cursor.fetchall()
	for row in metarows:
		minimumRating = row[1]
		maximumRating = row[2]
		tableName = rangePrefix + str(row[0])
		if not ((ratingMinimumValue > maximumRating) or(ratingMaximumValue < minimumRating)):
			cursor.execute("select * from" + tableName + "where rating >= " + str(ratingMinimumValue) + " and rating <= " + str(ratingMaximumValue) + ";")
			results = cursor.fetchall()
			with open(outputpath, "a") as file:
				for result in results:
					file.write(str(tableName) + "," + str(result[0]) + "," + str(result[1]) + "," + str(result[2]) + "\n")

def pointQuery(ratingValue, openconnection,outputpath):
	connection = openconnection
	cursor = connection.cursor
	rangeprefix = "RangeRatingsPart"
	cursor.execute("select *from RangeRatingsMetadata;")
	metarows = cursor.fetchall()
	for row in metarows:
		minimumRating = row[1]
		maximumRating = row[2]
		tableName = rangePrefix + str(row[0])
		if ((row[0] == 0 and ratingValue >= minimumRating and ratingValue <= maximumRating) or (row[0] != 0 and ratingValue > minimumRating and ratingValue <= maximumRating)):
			cursor.execute("select * from " + tableName + " where rating = " + str(ratingValue) + ";")
			results = cursor.fetchall()
			with open(outputpath, "a") as file:
				for result in results:
					file.write(str(tableName) + "," + str(result[0]) + "," + str(result[1]) + "," + str(result[2]) + "\n")

	roundrobbinprefix = "RoundRobbinRatingsPart"
	curosr.execute("select partitionnum from RoundRobinRatingsMetadata;")
	numPartitions = cursor.fetchall()[0][0]
	for j in range(0,partitions):
		tableName = roundrobbinprefix + str(j)
		cursor.execute("select * from " + tableName + " where rating = " + str(ratingValue) + ";")
		results = cursor.fetchall()
		with open(outputpath, "a") as file:
			for result in results:
				file.write(str(tableName) + "," + str(result[0]) + "," + str(result[1]) + "," + str(result[2]) + "\n")