# success_rate

1. Download the script and save it in to the convenient place
2. Run it
```
.\successrate.ps1
```

To specify path to the log file, you can use an optional parameter `-Path`:
```
.\successrate.ps1 -Path x:\storagenode\node.log
```

## You may need to enable the execution policy
Execute in the elevated Powershell
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
```
