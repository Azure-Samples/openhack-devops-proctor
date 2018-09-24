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
- Team has open challenge: Prompt user to complete challenge as they will not be able to add a new one till last is closed. DONE
- StartDateTime: >= end time of last completed challenge TODO

### Guards
- Can Deactivate: ask if want to lose changes DONE

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
- EndDateTime if null set to time greater than start time DONE
- Disable team, challenge, score DONE

### Validations
- Team: required DONE
- Challenge: required DONE
- StartDateTime: greater than enddate < end time of last completed challenge TODO
- EndDateTime: greater than start time and < end Event Time TODO

### Guards
- Can Deactivate: ask if want to lose changes DONE
- On Save, prompt that you cannot change once saved. DONE


## Add unsubscribe to list views DONE
## Add delete to the challenges list with modal. DONE
