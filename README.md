# Shuffler
Version 0.5.1, "Memory"

A tool for shuffling around custom answers.
Can be paired with streaming applications like 'OBS'.

### Download Application:

|[Linux 64-bit](https://github.com/agameraaron/shuffler/releases/download/v0.5.1/shuffler_0_5_1_linux64.7z)|[Linux 32-bit](https://github.com/agameraaron/shuffler/releases/download/v0.5.1/shuffler_0_5_1_linux32.7z)|[Windows 64-bit](https://github.com/agameraaron/shuffler/releases/download/v0.5.1/shuffler_0_5_1_windows64.zip)|[Windows 32-bit](https://github.com/agameraaron/shuffler/releases/download/v0.5.1/shuffler_0_5_1_windows32.zip)|[OSX](https://github.com/agameraaron/shuffler/releases/download/v0.5.1/shuffler_0_5_1_osx.zip)|
|:---:|:---:|:---:|:---:|:---:|

### Preview:

![alt text](https://raw.githubusercontent.com/agameraaron/shuffler/master/demo1.gif)*
![alt text](https://raw.githubusercontent.com/agameraaron/shuffler/master/demo2.gif)*

### About:
MIT licensed, created by AGamerAaron.

Created & editable in Godot Engine v3.0: https://godotengine.org/

### Description:
Much like how one could determine an answer by shuffling cards, throwing dice, shaking a magic 8-ball or spinning a prize wheel, this will give you a seemingly random response out of the answers you list. I created this with the intent to whimsically choose whatever I wish over a stream.

### Features:
- Preferable to a coin toss.
- Custom lists.
- Holding the power button determines the shuffling time.
- Saving & loading of lists.
- Background color can be changed. Useful for chroma keying.

### To Do:

##### High priority:
- Removes only top entry, not selected as intended
- Load prompt does not show files under specified suffix
- New Button graphics for sorts and renaming
- Wider name entry screen to accomodate more buttons
- Sort up/down options
- Rename entry option (button and by double clicking)
- Instead of reversing direction, the cycle should start again from the beginning of the list.

##### Low priority:
- Save and load prompts should be unmovable

##### Wish list:
- Allow textures to represent each entry

### History:
I wanted something to make decisions for me during streaming sessions. This is what I came up with. It works something like a digital roulette wheel including initial spin power and deceleration over time. Maybe a graphic representation of a wheel can be implemented in the future.
