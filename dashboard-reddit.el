(require 'dashboard)
(add-to-list dashboard-item-generators 'reddit . dashboard-insert-reddits )

(defun dashboard-insert-reddit-list (reddit-list list)
  "Render REDDIT-LIST title and items of LIST."
  (when (car list)
    (insert reddit-list)
    (mapc (lambda (el)
	    (setq url (nth 1 (split-string el "__")) )
	    (setq title (nth 0 (split-string el "__")) )
            (insert "\n    ")
            (widget-create 'push-button
                           :action `(lambda (&rest ignore)
				      (browse-url url))
                           :mouse-face 'highlight
                           :follow-link "\C-m"
                           :button-prefix ""
                           :button-suffix ""
                           :format "%[%t%]"	    
			   title
			   ))
          list)))
(defun dashboard-insert-reddits (list-size)
  "Add the list of LIST-SIZE items from recently edited files."
  (if (> list-size 0 )
      (progn
	
	(set-face-attribute 'region nil :background "#666" :foreground "#ffffff")
	(setq file-path "/tmp/dashboard_reddits.json")
	(condition-case nil
	    (delete-file file-path)
	  (error nil))

	(require 'json)
	(url-copy-file "https://www.reddit.com/r/emacs/.json"  file-path)
	(setq reddit-list (mapcar (lambda (entry)
				    (format "%s__%s " (let-alist entry .data.title ) (let-alist entry .data.url )))
					;(concat (let-alist entry .data.title ) (concat " - " (let-alist entry .data.url ))))
				  (let-alist (json-read-file  file-path) .data.children)))


	(mark)
	(when (dashboard-insert-reddit-list
	       "Recent Posts to /r/emacs:"
	       (dashboard-subseq reddit-list 0 list-size)))	 
	(dashboard-insert--shortcut "p" "Recent Posts:")
	(mark-defun)
	)
    
    ))

