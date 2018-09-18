# TODO List

## Add

### Fields

- Team: required DONE
- Challenge: required DONE
- StartDateTime: DONE
- EndDateTime: disabled DONE
- MaxScore: read only TODO

### Init

- Create init challenge DONE

### Behaviors
- Challenges filter based on selected team. DONE
- Button - set startdatetime to end of last challenge. TODO


### Validations
- Team: required DONE
- Challenge: required DONE
- Team has open challenge: Prompt user to complete challenge as they will not be able to add a new one till last is closed. TODO
- StartDateTime: greater than enddate < end time of last completed challenge TODO

### Guards
- Can Deactivate: ask if want to lose changes TODO

## Edit

### Fields
- Team: required DONE
- Challenge: required DONE
- StartDateTime: DONE
- EndDateTime: enabled DONE
- Score: read only TODO
- MaxScore: read only TODO

### Init
- Look up challenge to edit DONE
- Enable startDateTime, enddatetime DONE
- Disable team, challenge, score TODO

### Validations
- Team: required DONE
- Challenge: required DONE
- Team has open challenge: Prompt user to complete challenge as they will not be able to add a new one till last is closed. TODO
- StartDateTime: greater than enddate < end time of last completed challenge TODO
- EndDateTime: greater than start time and < end Event Time TODO

### Guards
- Can Deactivate: ask if want to lose changes TODO


## Add unsubscribe to list views
