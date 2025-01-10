import 'dart:async';

//For some applications there needs to be a limitor on how often they can run
//This debouncer should be implemented in if statements to see if code can run
class Debouncer{
  Debouncer({required this.milliseconds});
  final int milliseconds;
  Timer? _debounceTimer;
  
  //This function will check wether a timer is running. If one doesnt exist yet or one does but isnt active a new timer will be created
  //The function will then return true to allow for functions that should be run at the creation of the timer to be run
  //If a timer exists and is active the function returns false to dissuade those functions from running
  bool ifNotRunningRun(){
    bool setTimer(){
      _debounceTimer = Timer(Duration(milliseconds: milliseconds),(){});
      return true;
    }

    if(_debounceTimer == null){
      print("debounce isnull");
      return setTimer();
    }
    else if(!_debounceTimer!.isActive){
      print("debounce isactive");
      return setTimer();
    }
    else{
      return false;
    }
  }
}