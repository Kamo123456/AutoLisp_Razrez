(defun c:razrez ( / ent ss ed vxLIST dstLIST newEd n Y X hlist distlist pt c h0 pt0 i)
  (vl-load-com)
   (princ "Выберите полилинию ")
   (setq ent (car (entsel "\nВыберите ось стенки: ")))
   (setq ed (entget ent))
   (mapcar '(lambda(x)(if(= (car x) 10)(setq vxLIST (cons (cdr x) vxLIST)))) ed)
   (setq ss nil vxLIST (reverse vxLIST))
   (setq dstLIST (mapcar 'distance vxLIST  (cdr vxLIST)))
   (setq dstLIST (cons 0 dstLIST))
   (setq n '-1 Y (cadar vxLIST) X (caar vxLIST))
   (setq hlist (list))
   (setq distlist (list))
   (while (setq pt (getpoint "\nSpecify a point :"))
     (setq hlist (cons (getreal "\nВведите высоту данной точки: ") hlist))
     (setq c (vlax-curve-getclosestpointto ent pt))
     (setq distlist (cons (vlax-curve-getDistAtPoint ent c) distlist)))
   (setq h0 (getreal "\nВведите высоту основания: "))
   (setq pt0 (getpoint "\nВведите точку расположения разреза :"))
   (princ)
   (setq X (car pt0) Y (cadr pt0))
   (command "_pline" "_non")
   (setq i -1)
   (while (< (setq i (+ 1 i)) (length hlist))
     (command (list (+ X (nth i distlist)) (+ Y (- (nth i hlist) h0))) "_non" ))
   ;(mapcar '(lambda ( h d ) (command "_non" (list (+ X d) (+ Y (- h h0))))) hlist distlist)
   (command "")
  (setq hlist (vl-sort hlist '>))
  (setq i 0)
  (while (/= (fix (/ (- (car hlist) h0) (expt 10 (setq i (+ i 1))))) 0)) 
  (foreach item ed
     (if (= (car item) 10) (progn
       (setq item (list 10 (setq X (+ X (nth (setq n (1+ n)) dstLIST))) Y))
       (command "_line" "_non" (list X Y) "_non" (list X (+ (expt 10 i) Y)) "_non" ""))
       )
     (setq newEd (cons item newEd)))
     
 (entmakex (reverse newED))
 ;(command "_line" 


(entmake
(list
(cons 0 "TEXT")
(cons 1 (rtos h0 2 2))
(cons 10 (list (- (car pt0) (* 3.0 (expt 10 (- i 1)))) (cadr pt0)))
(cons 40 (/ (expt 10 (- i 1)) 2.0))))
  
  (princ)
  )
