# fuse-snackbar
Android Snackbar binding for Fusetools

# How to use:
1- Import "src/fuse-snackbar.unoproj" into you project `.unoproj` file.
2- To show the `SnackBar` you have to paste the following `JavaScript` to use it
 
 Import the uno library.

```
		var snackBar = require("Snackbar");
```


Use `Show` method to show the Snackbar with title and message for as many as you need in milliseconds.


```
    	snackBar.Show("Title","Action message",30000).then(function(){
    	    // Handle click on action message
    		console.log("Just fired !");
    	});
```
# Paramters
1- (`required`) Title: the main text on the SnackBar.
2- (`required`) Action Message: the text of the action button.
3- (`required`) Timeout: the timeout for the SnackBar message to live on the screen on milliseconds.

# Handle the click on action message
After the user click on the button the promise will fired so you can handle you business login inside it like :
```
    	snackBar.Show("Title","Action message",30000).then(function(){
    	    // e.g: Undo the delete 
    	    // You business logic should go down here.
    	});

```

If you find any problems just post it on a new issue; Also if you have any findings you can create a Pull Request so you're welcome 

*Have fun !*