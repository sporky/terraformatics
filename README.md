# terraformatics
Experiments in application deployment with Terraform

### Usage
If you want to use make, define the ENV and APP environment variables and then 'make plan'
```
bash-9.5$ ENV=prod APP=bip4stl20 make plan
```
Assuming that works out, try it again with 'make apply' and watch thing being built before your eyes
```
bash-9.5$ ENV=prod APP=bip4stl20 make apply
```

### Need a new app deployment or BIGIP added?
If you already have a module (template) for the thing you want to deploy, there's a really 
hacky script to help with the boilerplate of defining a new deployment.  It's (creatively) named
'newroot.sh'

```
bash-3.2$ ./newroot.sh 

usage: ./newroot.sh name type

     name - name of the new application/bigip to deploy
            For instance, green_dot_trading or bip4stl20

     type - this should either be DO or AS3.  Don't try and get cute.
```