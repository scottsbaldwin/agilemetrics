class StatisticalArray < Array
	def initialize(array)
		self.concat array
	end

	# sum of an array of numbers
	def sum
		return self.reduce(:+)
	end

	# the mean/average of an array of numbers
	def average
		return self.sum / self.length.to_f
	end

	# the median of an array of numbers
	def median
		sorted = self.sort
		median = 0
		if self.length % 2 == 0
			# we have an even number, average the two middle
			median_point_1 = self.length / 2
			median_point_2 = ((self.length + 1) / 2.to_f).round(0)
			# subtract 1 because our arrays are 0-based, not 1-based
			median_point_1 -= 1
			median_point_2 -= 1
			median = (sorted[median_point_1] + sorted[median_point_2]) / 2.to_f
		else
			median = sorted[self.length/2]
		end
		return median
	end

	# variance of an array of numbers
	def variance
		return variance_population
	end

	def variance_population
		avg = self.average
		sum = self.inject(0) { |acc, i| acc + (i - avg)**2 }
		return 1 / self.length.to_f * sum
	end

	def variance_sample
		avg = self.average
		sum = self.inject(0) { |acc, i| acc + (i - avg)**2 }
		return 1 / (self.length.to_f - 1) * sum
	end

	# the standard deviation of an array of numbers
	def standard_deviation
		return standard_deviation_population
	end

	def standard_deviation_population
		return Math.sqrt(self.variance_population)
	end

	def standard_deviation_sample
		return Math.sqrt(self.variance_sample)
	end

	def max_error
		# see http://www.sjsu.edu/faculty/gerstman/StatPrimer/t-table.pdf for t-table
		# using z score for 90%
		merr = 1.645 * (standard_deviation_population / (self.length ** 0.5))
		return merr
	end

	def confidence_interval_low
		low = self.length/2 - 1.96 * ((self.length * 0.25) ** 0.5)
		sorted = self.sort
		return sorted[low.ceil-1]
	end

	def confidence_interval_high
		high = self.length/2 + 1.96 * ((self.length * 0.25) ** 0.5)
		sorted = self.sort
		return sorted[high.ceil-1]
	end
end
