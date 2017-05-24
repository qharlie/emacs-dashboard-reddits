(require 'json)
(add-to-list 'dashboard-item-generators  '(reddits . dashboard-insert-reddit))
(add-to-list 'dashboard-items '(reddits) t)

(defun dashboard-insert-reddit-list (title list)
  "Render REDDIT-LIST title and items of LIST."
  (when (car list)
    (insert title )
    (mapc (lambda (el)
	    (setq url (nth 1 (split-string el "__")) )
	    (setq title (nth 0 (split-string el "__")) )
            (insert "\n    ")
            (widget-create 'push-button
                           :action `(lambda (&rest ignore)
				      (browse-url ,url))
                           :mouse-face 'highlight
                           :follow-link "\C-m"
                           :button-prefix ""
                           :button-suffix ""
                           :format "%[%t%]"	    
			   title
			   ))
          list)))
(defun dashboard-insert-reddit (list-size)
  "Add the list of LIST-SIZE items from recently edited files."
  (if (> list-size 0 )
      (progn
	
	(setq file-path "/tmp/dashboard_reddit.json")
	(condition-case nil
	    (delete-file file-path)
	  (error nil))


	(url-copy-file "https://www.reddit.com/r/emacs/.json"  file-path)
	(setq reddit-list (mapcar (lambda (entry)
				    (format "^%s\t  %s__%s " (let-alist entry .data.score ) (let-alist entry .data.title ) (let-alist entry .data.url )))
					;(concat (let-alist entry .data.title ) (concat " - " (let-alist entry .data.url ))))
				  (let-alist (json-read-file  file-path) .data.children)))


	(when (dashboard-insert-reddit-list
	       "Recent Posts to /r/emacs:"
	       (dashboard-subseq reddit-list 0 list-size)))	 
	;(dashboard-insert--shortcut "p" "Recent Posts:")
	)
    
    ))

