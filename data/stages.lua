-- Minlevel and multiplier are MANDATORY
-- Maxlevel is OPTIONAL, but is considered infinite by default
-- Create a stage with minlevel 1 and no maxlevel to disable stages
experienceStages = {
	{
		minlevel = 1,
		maxlevel = 100,
		multiplier = 30,
	},
	{
		minlevel = 101,
		multiplier = 3,
	},
}

skillsStages = {
	{
		minlevel = 10,
		maxlevel = 100,
		multiplier = 30,
	},
	{
		minlevel = 101,
		multiplier = 10,
	},
}

magicLevelStages = {
	{
		minlevel = 0,
		maxlevel = 100,
		multiplier = 30,
	},
	{
		minlevel = 101,
		multiplier = 10,
	},
}
