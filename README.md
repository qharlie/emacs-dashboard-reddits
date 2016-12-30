# emacs-dashboard-reddits
Adds a /r/emacs section to the dashboard.

Until I get this into MELPA you will have to clone this repository and load it with customizing your dashboard in your .emacs file, for example: 
```lisp
(require 'dashboard)
(load-file "~/workspace/emacs-dashboard-reddits/dashboard-reddit.el")
(setq dashboard-items '(
   (reddits . 5)
   (recents  . 5)
   (bookmarks . 5)
   (projects . 5)))
```


![Screenshot](screenshot.png?raw=true "Screenshot")
