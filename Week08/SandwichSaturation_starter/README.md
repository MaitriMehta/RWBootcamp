#  <#Title#>
Describe at least one other option for packaging seed data like this with an app. Which do you think makes the most sense if you were shipping SandwichSaturation, and why

1.  Using UserDefaults Save dictionary in if small data and not having relationships
2.  PList : iOS specific 1 extra step if data comes from server otherwise its the same
3.  Used JSON for easy to migrate if data comes dynamically in future from some server 
4.  Store data in local Sqlite database 

