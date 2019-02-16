# Piggy Block
Block access from little shit [1]. While there is plenty of good content on youtube, the avalanche of suggestions renders it a hellish and addictive environment.

## This solution:
• Sets up a block by writing 
```
0.0.0.0 youtube.com
```
to the ```/etc/hosts``` file and reloading the browsers - for some reason you need to restart them in order for the block to take effect.

• Read's in a file of youtube htmls and downloads them to a folder. This occurs even when the domain itself is blocked by the procedure above.
```
youtube-dl
```


[1] Little shit is a sister born in 2008 with an ever increasing addiction to youtube.
