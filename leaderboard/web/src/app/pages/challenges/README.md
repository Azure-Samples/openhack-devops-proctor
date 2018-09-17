# TODO

## Add

### Fields
	• Team: required
	• Challenge: required
	• StartDateTime: set using custom control
	• EndDateTime: disabled
	• Score: read only
	• MaxScore: read only

### Init
	• Create dummy challenge

### Validations
	• Team: required
	• Challenge: required
	• Team/ChallengeCombo: Not already completed, prompt user if not completed.
	• StartDateTime: greater than enddate < end time of last completed challenge
	• EndDateTime: greater than start time

### Guards
	• Can Deactivate: ask if want to lose changes

## Edit

### Fields
	• Team: required
	• Challenge: required
	• StartDateTime: set using custom control
	• EndDateTime: disabled
	• Score: read only
	• MaxScore: read only

### Init
	• Look up challenge to edit
	• Enable startDateTime, enddatetime
	• Disable team, challenge, score

### Validations
	• Team: required
	• Challenge: required
	• Team/ChallengeCombo: Not already completed, prompt user if not completed.  Should not fire though
	• StartDateTime: greater than enddate < end time of last completed challenge
	• EndDateTime: greater than start time and < end Event Time

### Guards
	• Can Deactivate: ask if want to lose changes


## Add unsubscribe to list views
