#  <#Title#>

Consists of a main button, and 3 choice buttons which pan out.
PS: All choices for buttons, images, animation constants are your choices. No enforcement.


Next up, when you create this, let’s put these buttons to some work. Add a random view, on top of the screen. This is going to be your animationObject. 
Now, on pressing every button, you have to add an animation (whether it be reducing opacity, changing background colour, translation or making the thing dance). So for three buttons there would be 3 animations chained. If I press 2 buttons, then only those 2 animations will be triggered. 

The final animations start when the center is clicked again, which closes the menu also.

Stretchhhh Goal
Feeling good today huh? 
Right now there is no way to let me know if my animation was added successfully or now. Create a notification kinda thing to intimate the user that the animation was added successfully.
Again, you’re free to choose the UI on your own.

Hints Hints Hints
You can use normal UIView.animate to make the menu. Just play with the constraints.
To add actions, declare a UIViewPropertyAnimator and use the addAnimation function to add animations. When you’re done and collapsing the menu, just call startAnimation on it.
The notification bar is also made with only a UIView.animate. Just think of animating the top constraint ;]
