(load "simulator")
(load "new-symbol")
(load "messages")
(load "agents.lisp")

(shadowing-import 'sim:robot)
(shadowing-import 'sim:agent-program)
(use-package 'sim)

;********************************************************************************************************************************************************************************************
;IMPORTANT: Maybe this is not the same for you, but nothing in run-assignment.lisp would run unless you do (load "agents.lisp") before you don (load "run-assignment.lisp")
;********************************************************************************************************************************************************************************************

;Just call run-robots. There is no run-other


;Runs each agent once on worlds with identical obstacles starting at (1 1) 
(defun run-robots ()

  (print "Starting reflex-agent:")
  (setf sim-reflex (create-simulator :size '(15 15) :obstacle-locations '((1 8) (2 2) (2 4) (2 6) (2 8) (2 10) (2 12) (2 14) (3 3) (3 8) (3 13) (4 2) (4 4) (4 6) (4 8) (4 10) (4 11) (4 12) (4 14) (5 4) (6 2) (6 4) (6 6) (6 7) (6 9) (6 10) (6 12) (6 14) (7 6) (7 10) (8 1) (8 2) (8 3) (8 4) (8 8) (8 12) (8 13) (8 14) (8 15) (9 6) (9 10) (10 2) (10 4) (10 6) (10 7) (10 9) (10 10) (10 12) (10 14) (11 12) (12 2) (12 4) (12 5) (12 6) (12 8) (12 10) (12 12) (12 14) (13 3) (13 8) (13 13) (14 2) (14 4) (14 6) (14 8) (14 10) (14 12) (14 14) (15 8))))
  (setf robot-reflex (make-instance 'reflex-agent))
  (add-robot sim-reflex :robot robot-reflex :orientation :north :location '(1 1))
  (run sim-reflex :for 27 :sketch-each t)

  (print "Starting model-based-reflex-agent:")
  (setf sim-model-based (create-simulator :size '(15 15) :obstacle-locations '((1 8) (2 2) (2 4) (2 6) (2 8) (2 10) (2 12) (2 14) (3 3) (3 8) (3 13) (4 2) (4 4) (4 6) (4 8) (4 10) (4 11) (4 12) (4 14) (5 4) (6 2) (6 4) (6 6) (6 7) (6 9) (6 10) (6 12) (6 14) (7 6) (7 10) (8 1) (8 2) (8 3) (8 4) (8 8) (8 12) (8 13) (8 14) (8 15) (9 6) (9 10) (10 2) (10 4) (10 6) (10 7) (10 9) (10 10) (10 12) (10 14) (11 12) (12 2) (12 4) (12 5) (12 6) (12 8) (12 10) (12 12) (12 14) (13 3) (13 8) (13 13) (14 2) (14 4) (14 6) (14 8) (14 10) (14 12) (14 14) (15 8))))
  (setf robot-model-based (make-instance 'model-based-agent))
  (add-robot sim-model-based :robot robot-model-based :orientation :north :location '(1 1))
  (run sim-model-based :for 34 :sketch-each t)

  (print "Starting hill-climb-agent:")
  (setf sim-hill-climb (create-simulator :size '(15 15) :obstacle-locations '((1 8) (2 2) (2 4) (2 6) (2 8) (2 10) (2 12) (2 14) (3 3) (3 8) (3 13) (4 2) (4 4) (4 6) (4 8) (4 10) (4 11) (4 12) (4 14) (5 4) (6 2) (6 4) (6 6) (6 7) (6 9) (6 10) (6 12) (6 14) (7 6) (7 10) (8 1) (8 2) (8 3) (8 4) (8 8) (8 12) (8 13) (8 14) (8 15) (9 6) (9 10) (10 2) (10 4) (10 6) (10 7) (10 9) (10 10) (10 12) (10 14) (11 12) (12 2) (12 4) (12 5) (12 6) (12 8) (12 10) (12 12) (12 14) (13 3) (13 8) (13 13) (14 2) (14 4) (14 6) (14 8) (14 10) (14 12) (14 14) (15 8))))
  (setf robot-hill-climb (make-instance 'hill-climb-agent :current '(1 1) :visited '((1 1)) :goal '(15 15)))
  (add-robot sim-hill-climb :robot robot-hill-climb :orientation :north :location '(1 1) )
  (run sim-hill-climb :for 60 :sketch-each t)

  (print "Starting uniform-cost-agent:")
  (setf sim-uniform-cost (create-simulator :size '(15 15) :obstacle-locations '((1 8) (2 2) (2 4) (2 6) (2 8) (2 10) (2 12) (2 14) (3 3) (3 8) (3 13) (4 2) (4 4) (4 6) (4 8) (4 10) (4 11) (4 12) (4 14) (5 4) (6 2) (6 4) (6 6) (6 7) (6 9) (6 10) (6 12) (6 14) (7 6) (7 10) (8 1) (8 2) (8 3) (8 4) (8 8) (8 12) (8 13) (8 14) (8 15) (9 6) (9 10) (10 2) (10 4) (10 6) (10 7) (10 9) (10 10) (10 12) (10 14) (11 12) (12 2) (12 4) (12 5) (12 6) (12 8) (12 10) (12 12) (12 14) (13 3) (13 8) (13 13) (14 2) (14 4) (14 6) (14 8) (14 10) (14 12) (14 14) (15 8))))
  (setf robot-uniform-cost (make-instance 'uniform-cost-agent :end '((15 15) nil 0 0 0) :width 15 :height 15 :obstacles '((1 8) (2 2) (2 4) (2 6) (2 8) (2 10) (2 12) (2 14) (3 3) (3 8) (3 13) (4 2) (4 4) (4 6) (4 8) (4 10) (4 11) (4 12) (4 14) (5 4) (6 2) (6 4) (6 6) (6 7) (6 9) (6 10) (6 12) (6 14) (7 6) (7 10) (8 1) (8 2) (8 3) (8 4) (8 8) (8 12) (8 13) (8 14) (8 15) (9 6) (9 10) (10 2) (10 4) (10 6) (10 7) (10 9) (10 10) (10 12) (10 14) (11 12) (12 2) (12 4) (12 5) (12 6) (12 8) (12 10) (12 12) (12 14) (13 3) (13 8) (13 13) (14 2) (14 4) (14 6) (14 8) (14 10) (14 12) (14 14) (15 8))))
  (add-robot sim-uniform-cost :robot robot-uniform-cost :orientation :north :location '(1 1) )
  (run sim-uniform-cost :for 30 :sketch-each t)

  (print "Starting astar-manhatten-agent:")
  (setf sim-manhatten (create-simulator :size '(15 15) :obstacle-locations '((1 8) (2 2) (2 4) (2 6) (2 8) (2 10) (2 12) (2 14) (3 3) (3 8) (3 13) (4 2) (4 4) (4 6) (4 8) (4 10) (4 11) (4 12) (4 14) (5 4) (6 2) (6 4) (6 6) (6 7) (6 9) (6 10) (6 12) (6 14) (7 6) (7 10) (8 1) (8 2) (8 3) (8 4) (8 8) (8 12) (8 13) (8 14) (8 15) (9 6) (9 10) (10 2) (10 4) (10 6) (10 7) (10 9) (10 10) (10 12) (10 14) (11 12) (12 2) (12 4) (12 5) (12 6) (12 8) (12 10) (12 12) (12 14) (13 3) (13 8) (13 13) (14 2) (14 4) (14 6) (14 8) (14 10) (14 12) (14 14) (15 8))))
  (setf robot-manhatten (make-instance 'astar-agent-manhatten :end '((15 15) nil 0 0 0) :width 15 :height 15 :obstacles '((1 8) (2 2) (2 4) (2 6) (2 8) (2 10) (2 12) (2 14) (3 3) (3 8) (3 13) (4 2) (4 4) (4 6) (4 8) (4 10) (4 11) (4 12) (4 14) (5 4) (6 2) (6 4) (6 6) (6 7) (6 9) (6 10) (6 12) (6 14) (7 6) (7 10) (8 1) (8 2) (8 3) (8 4) (8 8) (8 12) (8 13) (8 14) (8 15) (9 6) (9 10) (10 2) (10 4) (10 6) (10 7) (10 9) (10 10) (10 12) (10 14) (11 12) (12 2) (12 4) (12 5) (12 6) (12 8) (12 10) (12 12) (12 14) (13 3) (13 8) (13 13) (14 2) (14 4) (14 6) (14 8) (14 10) (14 12) (14 14) (15 8))))
  (add-robot sim-manhatten :robot robot-manhatten :orientation :north :location '(1 1) )
  (run sim-manhatten :for 30 :sketch-each t)

  (print "Starting astar-crow-agent:")
  (setf sim-crow (create-simulator :size '(15 15) :obstacle-locations '((1 8) (2 2) (2 4) (2 6) (2 8) (2 10) (2 12) (2 14) (3 3) (3 8) (3 13) (4 2) (4 4) (4 6) (4 8) (4 10) (4 11) (4 12) (4 14) (5 4) (6 2) (6 4) (6 6) (6 7) (6 9) (6 10) (6 12) (6 14) (7 6) (7 10) (8 1) (8 2) (8 3) (8 4) (8 8) (8 12) (8 13) (8 14) (8 15) (9 6) (9 10) (10 2) (10 4) (10 6) (10 7) (10 9) (10 10) (10 12) (10 14) (11 12) (12 2) (12 4) (12 5) (12 6) (12 8) (12 10) (12 12) (12 14) (13 3) (13 8) (13 13) (14 2) (14 4) (14 6) (14 8) (14 10) (14 12) (14 14) (15 8))))
  (setf robot-crow (make-instance 'astar-agent-crow :end '((15 15) nil 0 0 0) :width 15 :height 15 :obstacles '((1 8) (2 2) (2 4) (2 6) (2 8) (2 10) (2 12) (2 14) (3 3) (3 8) (3 13) (4 2) (4 4) (4 6) (4 8) (4 10) (4 11) (4 12) (4 14) (5 4) (6 2) (6 4) (6 6) (6 7) (6 9) (6 10) (6 12) (6 14) (7 6) (7 10) (8 1) (8 2) (8 3) (8 4) (8 8) (8 12) (8 13) (8 14) (8 15) (9 6) (9 10) (10 2) (10 4) (10 6) (10 7) (10 9) (10 10) (10 12) (10 14) (11 12) (12 2) (12 4) (12 5) (12 6) (12 8) (12 10) (12 12) (12 14) (13 3) (13 8) (13 13) (14 2) (14 4) (14 6) (14 8) (14 10) (14 12) (14 14) (15 8))))
  (add-robot sim-crow :robot robot-crow :orientation :north :location '(1 1) )
  (run sim-crow :for 30 :sketch-each t)
  
  )

;run each agent  on (25 25) sim with 80 randomly generated obstacles
(defun run-sim ()

  (loop for i from 1 to 1
        do (let ((g 0) (x '(0 0)) (y '(0 0)) (k '((7 7))))

             (loop               
               (let ((temp (list (+ 1 (random 25)) (+ 1 (random 25)))) (switch 0))

                 (dolist (j k)
                   (if (equal j temp)
                       (setf switch 1)
                       )
                   )
                 (if (equal switch 0)
                     (progn
                       (setf k (cons temp k))
                       (setf g (+ g 1))
                       )
                     )
                 )
               
               (when (= g 82) (return))
               )

             (setf x (car k))
             (setf y (cadr k))
             (setf k (cddr k))
             (setf x-prime (list (cadr x) (car x)))
             (setf y-prime (list (cadr y) (car y)))

             
             
             (print "uniform cost")
             (setf sim-uniform-cost (create-simulator :size '(25 25) :obstacle-locations k))
             (setf robot-uniform-cost (make-instance 'uniform-cost-agent :orientation :north :location x :end (list y nil 0 0 0) :width 25 :height 25 :start (list x nil 0 0 0) :open  (list (list x nil 0 0 0)) :obstacles k))
             (add-robot sim-uniform-cost :robot robot-uniform-cost  :random-location nil :random-orientation nil)
             (run sim-uniform-cost :for 100 :sketch-each nil)


             (print "manhatten")
             (setf sim-manhatten (create-simulator :size '(25 25) :obstacle-locations k))
             (setf robot-manhatten (make-instance 'astar-agent-manhatten :orientation :north :location x :end (list y nil 0 0 0) :width 25 :height 25 :start (list x nil 0 0 0) :open (list (list x nil 0 0 0)) :obstacles k))
             (add-robot sim-manhatten :robot robot-manhatten  :random-location nil :random-orientation nil)
             (run sim-manhatten :for 100 :sketch-each nil)

             (print "crow")
             (setf sim-crow (create-simulator :size '(25 25) :obstacle-locations k))
             (setf robot-crow (make-instance 'astar-agent-crow :orientation :north :location x :end (list y nil 0 0 0) :width 25 :height 25 :start (list x nil 0 0 0) :open (list (list x nil 0 0 0)) :obstacles k))
             (add-robot sim-crow :robot robot-crow  :random-location nil :random-orientation nil)
             (run sim-crow :for 100 :sketch-each nil)

             (print "hill climb")
             (setf sim-hill (create-simulator :size '(25 25) :obstacle-locations k))
             (setf robot-hill (make-instance 'hill-climb-agent :orientation :north :location x :goal y-prime :current x-prime :visited (list x-prime)))
             (add-robot sim-hill :robot robot-hill  :random-location nil :random-orientation nil)
             (run sim-hill :for 100 :sketch-each nil)

             (print "model based reflex agent")
             (setf sim-model (create-simulator :size '(25 25) :obstacle-locations k))
             (setf robot-model (make-instance 'model-based-agent :orientation :north :location (list 1 1)))
             (add-robot sim-model :robot robot-model  :random-location nil :random-orientation nil)
             (run sim-model :for 100 :sketch-each nil)
             (world-sketch sim-model)

             (print "model based reflex agent")
             (setf sim-reflex (create-simulator :size '(25 25) :obstacle-locations k))
             (setf robot-reflex (make-instance 'reflex-agent :orientation :north :location (list 1 1)))
             (add-robot sim-reflex :robot robot-reflex  :random-location nil :random-orientation nil)
             (run sim-reflex :for 100 :sketch-each nil)
             (world-sketch sim-reflex)

             )
        )
  )
  

;run each agent on empty (25 25) sim
(defun run-sim-2 ()

  (loop for i from 1 to 1
        do (let ((x (+ (random 25) 1)) (y (+ 1 (random 25))) (a (+ 1 (random 25))) (b (+ 1 (random 25))))
             
             (print "uniform cost")
             (setf sim-uniform-cost (create-simulator :size '(25 25)))
             (setf robot-uniform-cost (make-instance 'uniform-cost-agent :orientation :north :location (list a b)
                                                                         :end (list (list x y) nil 0 0 0) :width 25 :height 25 :start (list (list a b) nil 0 0 0) :open (list (list (list a b) nil 0 0 0))))
             (add-robot sim-uniform-cost :robot robot-uniform-cost :random-location nil :random-orientation nil)
             (run sim-uniform-cost :for 100 :sketch-each nil)

             (print "manhatten")
             (setf sim-manhatten (create-simulator :size '(25 25)))
             (setf robot-manhatten (make-instance 'astar-agent-manhatten :orientation :north :location (list a b)
                                                                         :end (list (list x y) nil 0 0 0) :width 25 :height 25 :start (list (list a b) nil 0 0 0) :open (list (list (list a b) nil 0 0 0))))
             (add-robot sim-manhatten :robot robot-manhatten  :random-location nil :random-orientation nil)
             (run sim-manhatten :for 100 :sketch-each nil)

             (print "crow")
             (setf sim-crow (create-simulator :size '(25 25)))
             (setf robot-crow (make-instance 'astar-agent-crow :orientation :north :location (list a b)
                                                               :end (list (list x y) nil 0 0 0) :width 25 :height 25 :start (list (list a b) nil 0 0 0) :open (list (list (list a b) nil 0 0 0))))
             (add-robot sim-crow :robot robot-crow  :random-location nil :random-orientation nil)
             (run sim-crow :for 100 :sketch-each nil)

             (print "hill climb")
             (setf sim-hill (create-simulator :size '(25 25)))
             (setf robot-hill (make-instance 'hill-climb-agent :orientation :north :location (list a b) :goal (list x y) :current (list b a) :visited (list (list b a))))
             (add-robot sim-hill :robot robot-hill  :random-location nil :random-orientation nil)
             (run sim-hill :for 100 :sketch-each nil)

             (print "model based reflex agent")
             (setf sim-model (create-simulator :size '(25 25)))
             (setf robot-model (make-instance 'model-based-agent :orientation :north :location (list a b)))
             (add-robot sim-model :robot robot-model  :random-location nil :random-orientation nil)
             (run sim-model :for 100 :sketch-each nil)
             (world-sketch sim-model)

             (print "model based reflex agent")
             (setf sim-reflex (create-simulator :size '(25 25)))
             (setf robot-reflex (make-instance 'reflex-agent :orientation :north :location (list a b)))
             (add-robot sim-reflex :robot robot-reflex  :random-location nil :random-orientation nil)
             (run sim-reflex :for 100 :sketch-each nil)
             (world-sketch sim-reflex)

             )
        )
  )

;run each agent on (25 25) sim with 80 randomly generated obstacles -no fake corners
(defun run-sim-3 ()

  (loop for i from 1 to 1
        do (let ((g 0) (x '(0 0)) (y '(0 0)) (k '((7 7))))

             (loop               
               (let ((temp (list (+ 1 (random 25)) (+ 1 (random 25)))) (switch 0))

                 (dolist (j k)
                   (if (or (or (or (or (or
                                        (equal j temp)
                                        (equal (list (+ (car j) 1) (+ (cadr j) 1)) temp))
                                        (equal (list (- (car j) 1) (- (cadr j) 1)) temp))
                                        (equal (list (+ (car j) 1) (- (cadr j) 1)) temp))
                                        (equal (list (- (car j) 1) (+ (cadr j) 1)) temp))
                                        (or (or (or
                                        (equal (car temp) 1)
                                        (equal (car temp) 25))
                                        (equal (cadr temp) 1))
                                        (equal (cadr temp) 25)))
                       (setf switch 1)
                       )
                   )
                 (if (equal switch 0)
                     (progn
                       (setf k (cons temp k))
                       (setf g (+ g 1))
                       )
                     )
                 )
               
               (when (= g 82) (return))
               )

             (setf x (car k))
             (setf y (cadr k))
             (setf k (cddr k))
             (setf x-prime (list (cadr x) (car x)))
             (setf y-prime (list (cadr y) (car y)))

             
             
             (print "uniform cost")
             (setf sim-uniform-cost (create-simulator :size '(25 25) :obstacle-locations k))
             (setf robot-uniform-cost (make-instance 'uniform-cost-agent :orientation :north :location x :end (list y nil 0 0 0) :width 25 :height 25 :start (list x nil 0 0 0) :open  (list (list x nil 0 0 0)) :obstacles k))
             (add-robot sim-uniform-cost :robot robot-uniform-cost  :random-location nil :random-orientation nil)
             (run sim-uniform-cost :for 100 :sketch-each nil)


             (print "manhatten")
             (setf sim-manhatten (create-simulator :size '(25 25) :obstacle-locations k))
             (setf robot-manhatten (make-instance 'astar-agent-manhatten :orientation :north :location x :end (list y nil 0 0 0) :width 25 :height 25 :start (list x nil 0 0 0) :open (list (list x nil 0 0 0)) :obstacles k))
             (add-robot sim-manhatten :robot robot-manhatten  :random-location nil :random-orientation nil)
             (run sim-manhatten :for 100 :sketch-each nil)

             (print "crow")
             (setf sim-crow (create-simulator :size '(25 25) :obstacle-locations k))
             (setf robot-crow (make-instance 'astar-agent-crow :orientation :north :location x :end (list y nil 0 0 0) :width 25 :height 25 :start (list x nil 0 0 0) :open (list (list x nil 0 0 0)) :obstacles k))
             (add-robot sim-crow :robot robot-crow  :random-location nil :random-orientation nil)
             (run sim-crow :for 100 :sketch-each nil)

             (print "hill climb")
             (setf sim-hill (create-simulator :size '(25 25) :obstacle-locations k))
             (setf robot-hill (make-instance 'hill-climb-agent :orientation :north :location x :goal y-prime :current x-prime :visited (list x-prime)))
             (add-robot sim-hill :robot robot-hill  :random-location nil :random-orientation nil)
             (run sim-hill :for 100 :sketch-each nil)

             (print "model based reflex agent")
             (setf sim-model (create-simulator :size '(25 25) :obstacle-locations k))
             (setf robot-model (make-instance 'model-based-agent :orientation :north :location (list 1 1)))
             (add-robot sim-model :robot robot-model  :random-location nil :random-orientation nil)
             (run sim-model :for 100 :sketch-each nil)
             (world-sketch sim-model)

             (print "model based reflex agent")
             (setf sim-reflex (create-simulator :size '(25 25) :obstacle-locations k))
             (setf robot-reflex (make-instance 'reflex-agent :orientation :north :location (list 1 1)))
             (add-robot sim-reflex :robot robot-reflex  :random-location nil :random-orientation nil)
             (run sim-reflex :for 100 :sketch-each nil)
             (world-sketch sim-reflex)

             )
        )
  )
