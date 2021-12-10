# Jump

Helps in jumping between directories
works like bookmarks
* written in bash
## Options

```
  // to jump to respective directory of
  j [jump_string]
  
  // add current directory to list
  j --add / -a [jump_string] [full_directory]

  // delete a directory based on jump string
  j --del / -d [jump_string]

  // list all saved directories along with corresponding 
  j --list / -l
  
  // show help 
  j --help / -h
```

## Tips

```
  // adds current directory into jump list with jump string ','
  j .
  // to go to last added directory using above command
  j ,
  
  // adds current directory with user given jump string
  j -a [jump_string] .
