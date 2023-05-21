# What is it?
ScriptBox is a collection of libraries and scripts that can help
you create your scripts and perform tasks on linux.

Some of these scripts work in truncated shells - such as sh, ash, dash.
I use these utilities to work with BusyBox when debugging embedded systems,
in particular for analyzing logs where there are no other scripting languages.
- var_gen_lib - work with variables
- var_mline_lib - work with multiline variables
- arr_line_lib - work with linear pseudo arrays
- arr_assoc_lib - work with associative pseudo arrays
- shtest_lib - testing shell scripts

This project is for fun while exploring the differences in how different shells work.

# Send to BusyBox
If your version of BusyBox does not have "scp", then you can send this part as
an archive to businessbox from the local machine via "netcat" as follows:

Enable listening on busybox (for example router with linux)
```
nc -l -p 12345 > repo.tar.gz
```

Send from local host PC
```
nc target_ip 12345 < repo.tar.gz
```

# Merge req
Agreement on git messages:
1. [status] - fow example broken
2. Change type feat/fix/ref
3. Script name
4. Commit message
