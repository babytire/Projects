(load "simulator")
(load "new-symbol")
(load "messages")

                                        ;SEMI IMPORTANT: Some agents when running will print out errors saying null isn't a operation they can do
                                        ;I don't know why they do this but they still work reguardless



;Just a member function I made to better fin my needs,regular member wasn't cutting it
(defun better-member (item list)
  (let ((output nil))
    (dolist (n list)
      (if (equal n item)
        (setf output t)        
    )
      ) output
    )

)


(defclass reflex-agent (robot) 
  ((moves :accessor moves        ;Just for counting number of moves   
          :initform 0))
  )

(export 'reflex-agent)

;This one's pretty self explainatory
(defmethod agent-program ((self reflex-agent) percept)
  (setf (moves self) (+ 1 (moves self)))
  (princ "Current total moves of reflex-agent:")
  (print (moves self))
  (print " ")
  (if (cadr (assoc :front-bump percept))
      :right
      :forward
  ) 
)

(defclass model-based-agent (robot)
  ;VERY IMPORTANT: I implemented something weird and am too lazy to fix it. My coordinates are backwards from the professors code. x is what row number you are in and y is what collumn number you are in.

  ((stack :accessor stack       ;Stack of moves
          :initform '())      
  (visited :accessor visited    ;List of visited nodes
            :initform '((0 0)))  
   (current :accessor current   ;Current node as a coordinate plane pair (x y)
            :initform '(0 0))   ;Note this is not Current position in the simulation, but the current position where (0 0) is the robot's starting position
   (corner :accessor corner     ;Boolean if corner has been found
           :initform 'nil)
   (moves :accessor moves
          :initform 0)          ;Just for counting number of move
  ) 
)

(export 'model-based-agent)

(defmethod agent-program ((self model-based-agent) percept)

  
  
  ;Variable checking if last turn was a bump
  (let ((bump 'nil)) 
    (if (or (or (or (cadr (assoc :right-bump percept)) (cadr (assoc :left-bump percept))) (cadr (assoc :front-bump percept))) (cadr (assoc :rear-bump percept)))
        (setq bump 't))
    ;If front sensor and either right or left bump are lit or corner is true
    (if (or (and (or (cadr (assoc :right-bump percept)) (cadr (assoc :left-bump percept))) (cadr (assoc :front-sensor percept))) (corner self))
        ;if corner is not true, set it to true. then :nop
        (cond ((corner self) :nop)
              (t (setf (corner self) t)
                 :nop))
        ;checking which direction to move in
        ;This test basically reads: not (direction in visited or bump last turn)
        (cond ((not (or (better-member (list (+ 1 (car (current self))) (cadr (current self))) (visited self)) bump))                      ;Move forward
               ;Add place we're moving to visited, add operation to stack, set current to where we're moving, amd move there
               (setf (visited self) (append (visited self) (list (list (+ 1 (car (current self))) (cadr (current self))))))
               (setf (stack self) (append (list 'up) (stack self)))
               (setf (current self) (list (+ 1 (car (current self))) (cadr (current self))))
               (setf (moves self) (+ 1 (moves self)))
               (print "Current total moves of model-based-agent:")
               (print (moves self))
               :forward)
              ((not (or (better-member (list (car (current self)) (+ 1 (cadr (current self)))) (visited self)) bump))                      ;Move right
               (setf (visited self) (append (visited self) (list (list (car (current self)) (+ 1 (cadr (current self)))))))
               (setf (stack self) (append (list 'right) (stack self)))
               (setf (current self) (list (car (current self)) (+ 1 (cadr (current self)))))
               (setf (moves self) (+ 1 (moves self)))
               (print "Current total moves of model-based-agent:")
               (print (moves self))
               :right)
              ((not (or (better-member (list (car (current self)) (- (cadr (current self)) 1)) (visited self)) bump))                      ;Move left
               (setf (visited self) (append (visited self) (list (list (car (current self)) (- (cadr (current self)) 1)))))
               (setf (stack self) (append (list 'left) (stack self)))
               (setf (current self) (list (car (current self)) (- (cadr (current self)) 1)))
               (setf (moves self) (+ 1 (moves self)))
               (print "Current total moves of model-based-agent:")
               (print (moves self))
               :left)
              ((not (or (better-member (list (- (car (current self)) 1) (cadr (current self))) (visited self)) bump))                      ;Move backward
               (setf (visited self) (append (visited self) (list (list (- (car (current self)) 1) (cadr (current self))))))
               (setf (stack self) (append (list 'down) (stack self)))
               (setf (current self) (list (- (car (current self)) 1) (cadr (current self))))
               (setf (moves self) (+ 1 (moves self)))
               (print "Current total moves of model-based-agent:")
               (print (moves self))
               :backward)
              ;Eithere there was a bump last turn or we're backtracking
              (t (cond ((equal (car (stack self)) 'up)      ;if last move was up
                        ;set current to 1 square down either because we bounced and are actually there or are backtracking to there
                        (setf (current self) (list (- (car (current self)) 1) (cadr (current self))))
                        ;take top move off stack
                        (setf (stack self) (cdr (stack self)))
                        ;If there wasn't a bump last turn, backtrack, otherwise do nothing
                        (if (not bump)
                            (progn
                              (setf (moves self) (+ 1 (moves self)))
                              (print "Current total moves of model-based-agent:")
                              (print (moves self))
                              :backward
                              )
                            :nop))
                       ((equal (car (stack self)) 'down) ; if last move was dowm
                        (setf (current self) (list (+ 1 (car (current self))) (cadr (current self))))
                        (setf (stack self) (cdr (stack self)))
                        (if (not bump)
                            (progn
                              (setf (moves self) (+ 1 (moves self)))
                              (print "Current total moves of model-based-agent:")
                              (print (moves self))
                              :forward)
                            :nop))
                       ((equal (car (stack self)) 'left) ;if last move was left
                        (setf (current self) (list (car (current self)) (+ 1 (cadr (current self)))))
                        (setf (stack self) (cdr (stack self)))
                        (if (not bump)
                            (progn
                              (setf (moves self) (+ 1 (moves self)))
                              (print "Current total moves of model-based--agent:")
                              (print (moves self))
                              :right)
                            :nop))
                       ((equal (car (stack self)) 'right) ;if last move was right
                        (setf (current self) (list (car (current self)) (- (cadr (current self)) 1)))
                        (setf (stack self) (cdr (stack self)))
                        (if (not bump)
                            (progn
                              (setf (moves self) (+ 1 (moves self)))
                              (print "Current total moves of model-based--agent:")
                              (print (moves self))
                              :left)
                            :nop))
                       (t :nop)
                       )
                 )
              )
      )
    )
  )

(defclass hill-climb-agent (robot)
                                 ;VERY IMPORTANT: I implementd something weird and am too lazy to fix it. My coordinates are backwards from the professors code. x is what row number you are in and y is what collumn number you are in.
                                 ;This is impportant because when you use (make-instance) :location will follow the professor's pattern but :current, :visited, and :goal follow my pattern
                                 ;When you make this object you need to make sure the information in current, visited, goal, and nesw are accurate buy doing it yourself. especially visited which must be a list containing current
  
  ((stack :accessor stack        ;Stack of moves
          :initform '())        
   (current :accessor current    ;Current node as a coordinate plane pair (x y)
            :initform '(0 0)     ;Note this is the Current/Start position in the simulation, unlike the model-based-agent
            :initarg :current)
   (visited :accessor visited    ;List of visited nodes
            :initform '((0 0)) 
            :initarg :visited)
   (goal :accessor goal          ;Where the corner is in coordinate plain pair (x y)
         :initform 'nil
         :initarg :goal)
   (nesw :accessor nesw          ;Orientation: n=north, e=east, s=south, or w=west
         :initform 'n
         :initarg :nesw)
   (moves :accessor moves        ;Just for counting number of move
          :initform 0)
   ) 
)

(export 'hill-climb-agent)

(defmethod agent-program ((self hill-climb-agent) percept)
  
  (let ((bump 'nil)) ;setting a bump variable for if last move was a bump 
    (if (or (or (or (cadr (assoc :right-bump percept)) (cadr (assoc :left-bump percept))) (cadr (assoc :front-bump percept))) (cadr (assoc :rear-bump percept)))
        (setq bump 't))
    ;Orient the robot so it always faces north. Otherwise the moving forward, backward, left, and right gets complicated in a grid
    (if (not (equal (nesw self) 'n))
        (cond ((equal (nesw self) 'w)
               (setf (nesw self) 'n)
               :turn-right)
              ((equal (nesw self) 'e)
               (setf (nesw self) 'n)
               :turn-left)
              ((equal (nesw self) 's)
               (setf (nesw self) 'e)
               :turn-left)
              )
    ;If at the goal, do nothing
        (if (equal (current self) (goal self))
            (progn
              (print "Hill Climb agent found the goal.")
              (print "Total moves:")
              (print (moves self))
              :nop)
                                        ;creating variables that show distance of each current neighbor to goal
        ;These lines basically say: direction is equal to the max of either a. The distance from the forward neighbor to goal and b. if we've visited forward 999999999, else -1
            (let ((forward (max (+ (abs (- (car (goal self)) (+ 1 (car (current self))))) (abs (- (cadr (goal self)) (cadr (current self)))))
                                (if (better-member (list (+ 1 (car (current self))) (cadr (current self))) (visited self)) 999999999 -1)))                                   
                  (down (max (+ (abs (- (car (goal self)) (- (car (current self)) 1))) (abs (- (cadr (goal self)) (cadr (current self)))))
                                (if (better-member (list (- (car (current self)) 1) (cadr (current self))) (visited self)) 999999999 -1 )))
                  (right (max (+ (abs (- (car (goal self)) (car (current self)))) (abs (- (cadr (goal self)) (+ 1 (cadr (current self))))))
                                (if (better-member (list (car (current self)) (+ 1 (cadr (current self)))) (visited self)) 999999999 -1)))
                  (left (max (+ (abs (- (car (goal self)) (car (current self)))) (abs (- (cadr (goal self)) (- (cadr (current self)) 1))))
                                (if (better-member (list (car (current self)) (- (cadr (current self)) 1)) (visited self)) 999999999 -1))))
                                        ;condition tests to determine which direction we should go
                                        ;These lines basically say: if direction is minimum of four directions and last turn we didn't bump and forward does not bring us to a place we've already visited.
          ;We test for if it's not a place we've already visited because of the scenario where we've visited all neightbors, in which case we want to backtrack 
          (cond ((and (and (equal forward (min forward down right left)) (not bump)) (not (better-member (list (+ 1 (car (current self))) (cadr (current self))) (visited self))))                      ;Move forward
                 ;add place we're visiting to visited, add our move to the stack, set current to where we're visiting, and move
                 (setf (visited self) (append (visited self) (list (list (+ 1 (car (current self))) (cadr (current self))))))
                 (setf (stack self) (append (list 'up) (stack self)))
                 (setf (current self) (list (+ 1 (car (current self))) (cadr (current self))))
                 (setf (moves self) (+ 1 (moves self)))
                 (print "Current total moves of hill-climb-agent:")
                 (print (moves self))
               :forward)
              ((and (and (equal right (min down right left)) (not bump)) (not (better-member (list (car (current self)) (+ 1 (cadr (current self)))) (visited self))))                                  ;Move right
               (setf (visited self) (append (visited self) (list (list (car (current self)) (+ 1 (cadr (current self)))))))
               (setf (stack self) (append (list 'right) (stack self)))
               (setf (current self) (list (car (current self)) (+ 1 (cadr (current self)))))
               (setf (moves self) (+ 1 (moves self)))
               (print "Current total moves of hill-climb-agent:")
               (print (moves self))
               :right)
              ((and (and (equal left (min down left)) (not bump)) (not (better-member (list (car (current self)) (- (cadr (current self)) 1)) (visited self))))                                         ;Move left
               (setf (visited self) (append (visited self) (list (list (car (current self)) (- (cadr (current self)) 1)))))
               (setf (stack self) (append (list 'left) (stack self)))
               (setf (current self) (list (car (current self)) (- (cadr (current self)) 1)))
               (setf (moves self) (+ 1 (moves self)))
               (print "Current total moves of hill-climb-agent:")
               (print (moves self))
               :left)
              ((and (not bump) (not (better-member (list (- (car (current self)) 1) (cadr (current self))) (visited self))))                                                                            ;Move backward
               (setf (visited self) (append (visited self) (list (list (- (car (current self)) 1) (cadr (current self))))))
               (setf (stack self) (append (list 'down) (stack self)))
               (setf (current self) (list (- (car (current self)) 1) (cadr (current self))))
               (setf (moves self) (+ 1 (moves self)))
               (print "Current total moves of hill-climb-agent:")
               (print (moves self))
               :backward)
              ;If we want to Backtrack or we bumped, we enter here
              (t (cond ((equal (car (stack self)) 'up)      ;if last move was up
                        ;set current to 1 square down either because we bounced and are actually there or are backtracking to there
                        (setf (current self) (list (- (car (current self)) 1) (cadr (current self))))
                        ;Take top move off of stack
                        (setf (stack self) (cdr (stack self)))
                        ;If there wasn't a bump last turn, backtrack, otherwise do nothing
                        (if (not bump)
                            (progn
                              (setf (moves self) (+ 1 (moves self)))
                              (print "Current total moves of hill-climb-agent:")
                              (print (moves self))
                              :backward)
                            :nop))
                       ((equal (car (stack self)) 'down) ; if last move was dowm
                        (setf (current self) (list (+ 1 (car (current self))) (cadr (current self))))
                        (setf (stack self) (cdr (stack self)))
                        (if (not bump)
                            (progn
                              (setf (moves self) (+ 1 (moves self)))
                              (print "Current total moves of hill-climb-agent:")
                              (print (moves self))
                              :forward)
                            :nop))
                       ((equal (car (stack self)) 'left) ;if last move was left
                        (setf (current self) (list (car (current self)) (+ 1 (cadr (current self)))))
                        (setf (stack self) (cdr (stack self)))
                        (if (not bump)
                            (progn
                              (setf (moves self) (+ 1 (moves self)))
                              (print "Current total moves of hill-climb-agent:")
                              (print (moves self))
                              :right)
                            :nop))
                       ((equal (car (stack self)) 'right) ;if last move was right
                        (setf (current self) (list (car (current self)) (- (cadr (current self)) 1)))
                        (setf (stack self) (cdr (stack self)))
                        (if (not bump)
                            (progn
                              (setf (moves self) (+ 1 (moves self)))
                              (print "Current total moves of hill-climb-agent:")
                              (print (moves self))
                              :left)
                            :nop))
                       ;We should never get here, but if we do something is obviously wrong so we just do nothing
                       (t :nop)
                       )
                 )
              )
        )
        )
    )
    )
  )

(defclass uniform-cost-agent (robot)
  
                                        ;This code is exactly the same as astar-crow and uniform-costs agents. I copy and pasted them for my convenience
                                        ;The only difference is the changed the heuristic function for each agent
  
                                        ;This should be implemented with the professor's (x y) system
  
                                        ;nodes in form of: '((x y) z g h f)
                                        ;x -
                                        ;y -
                                        ;z - node's parent
                                        ;g - distance between node and start
                                        ;h - heurisitc between node and end
                                        ;f - g + h
  
  ((start-node :accessor start                   ;Where the robot starts - also represents current spot robot is at when astar is done running
               :initform '((1 1) nil 0 0 0)      ;When initialized, (x y) - where you start, the rest must be nil 0 0 0
               :initarg :start)
   (end-node :accessor end                       ;End goal of agent
             :initform '((1 1) nil 0 0 0)         ;When initialized, (x y) - end goal, the rest must be nil 0 0 0
             :initarg :end)
   (open-list :accessor open-list                ;List of open nodes
              :initform '(((1 1) nil 0 0 0))                      ;Initialize as list with start-node in it
              :initarg :open)
   (closed-list :accessor closed                 ;List of closed nodes
                :initform '())
   (final-path :accessor final                   ;Final solution
               :initform '())
   (map-width :accessor width                    ;Width of map
              :initform 10
              :initarg :width)
   (map-height :accessor height                  ;Height of map
               :initform 10
               :initarg :height)
   (obstacles :accessor obstacles                ;List of ordered pairs indicating where obstacles are
              :initform '()
              :initarg :obstacles)
   (nesw :accessor nesw                          ;Orientation or agent: n=north, e=east, s=south, or w=west
         :initform 'n
         :initarg :nesw)
   (astar-run :accessor arun                     ;Boolean whether astar has run yet
              :initform nil)
   (nodes-visited :accessor nodes                ;Tracking number of nodes visited
                 :initform 0)
   (max-open-list-size :accessor max-size        ;Tracking max open-list size
                       :initform 0)
   )
  )

(export 'uniform-cost-agent)

;Because it's uniform cost the heuristic just returns 0
;Requires two ordered pair lists. one representing the node and the other the goal
(defmethod uniform-cost-heuristic ()
  0
  )

(defmethod agent-program ((self uniform-cost-agent) percept)
  
    ;This entire block is astar, everything else is robot handling
    (block astar
      (if (arun self)
          (return-from astar)
          )
      
      ;Iterate until open-list is empty
      (loop
        
        (if (> (length (open-list self)) (max-size self))
            (setf (max-size self) (length (open-list self)))
            )
        
        ;current node
        (let ((current '(nil nil nil nil 999999999)))

          ;set current to node in open-list with smallest f value
          (dolist (n (open-list self))
            (if (< (car (last n)) (car (last current)))
                (setf current n)
                
                )
            )

          ;remove current from open-list and add to closed-list
          (setf (open-list self) (remove current (open-list self) :test #'equal))
          (setf (closed self) (cons current (closed self)))
          (setf (nodes self) (+ 1 (nodes self)))
          
          ;if current is end goal
          (if (equal (car current) (car (end self)))
              (progn
                ;backtrack through from node to parent, reconstructing path for final answer
                (loop
                  (setf (final self) (cons (car current) (final self)))
                  (dolist (n (closed self))
                    (if (equal (cadr current) (car n))
                        (progn
                          (setf current n)
                          (return)
                          )
                        )
                    )
                  (when (equal (cadr current) '()) (return))
                  )
                ;set arun t, and exit from astar loop
                (setf (arun self) t)
                (return-from astar)
                )
              )
          (let
              ;list of children nodes
              ((children '())
               ;list of potential children coordinates
               (potentials (list
                            (list (caar current) (+ (cadar current) 1))
                            (list (caar current) (- (cadar current) 1))
                            (list (+ (caar current) 1) (cadar current))
                            (list (- (caar current) 1) (cadar current))
                            )
                           )
               )

            
            ;check if each potential child/move is walkable
            (dolist (x potentials)
              (if        
               (and
                ;is move within bounds of map
                (and (and (> (car x) 0) (<= (car x) (width self))) (and (> (cadr x) 0) (<= (cadr x) (height self))))
                ;is move not an obstacle
                (block obstacle-block
                  (dolist (n (obstacles self))
                    (if (equal n x)
                        (return-from obstacle-block nil)
                        )
                    )
                  (return-from obstacle-block t)
                  )
                )
               ;make move a node and add to children
               (setf children (cons (list x (car current) nil nil nil) children))
               )
              )
            ;for each child
            (dolist (n children)
              ;unless child is already closed
              (unless
                  (block check-closed
                    ;Iterate through closed, if child has same indices as element in closed, return t
                    (dolist (x (closed self))
                      (if (equal (car x) (car n))
                          (return-from check-closed t)
                          )
                      )
                    (return-from check-closed nil)
                    )

                ;iterate through closed 
                (dolist (x (closed self))
                  
                                        ;if found node's parent
                  (if (equal (cadr n) (car x))
                      ;calculate and set nodes g, h, and f
                      (setf n (list (car n) (cadr n) (+ 1 (caddr x)) (uniform-cost-heuristic) (+ (+ 1 (caddr x)) (uniform-cost-heuristic))))
                      )
                      
                  )

                
                ;unless child is already on open list with a smaller g, add child to open list
                (unless
                    (block check-open
                      ;for open node
                      (dolist (w (open-list self))
                        ;if node is same as child
                        (if (equal (car n) (car w))
                            ;if child g is smaller than node in open g
                            (if (> (caddr w) (caddr n))
                                ;remove node on open and replace it with child, then break out of loop with t
                                (progn
                                  (setf (open-list self) (remove w (open-list self) :test #'equal))
                                  (setf (open-list self) (cons n (open-list self)))
                                  (return-from check-open t))
                                ;break out of loop with t
                                (return-from check-open t)
                                )
                            )
                        )
                      (return-from check-open nil)
                      )
                  
                  ;if loop wasn't broken out of with t, add child to open list
                  (setf (open-list self) (cons n (open-list self)))
                  )
                )
              )
            )
          
          )
        (when (equal (open-list self) '()) (return-from astar))
        )
      )
      ;End of block astar
    
    ;If not facing north, orient the robot so it always faces north.
    (if (not (equal (nesw self) 'n))
        (cond ((equal (nesw self) 'w)
               (setf (nesw self) 'n)
               :turn-right)
              ((equal (nesw self) 'e)
               (setf (nesw self) 'n)
               :turn-left)
              ((equal (nesw self) 's)
               (setf (nesw self) 'e)
               :turn-left)
              )
        (progn
          (print "Max Open-list size was:")
          (print (max-size self))
          (print "Number of nodes visited was:")
          (print (nodes self))
          (print " ")
        ;Otherwise figure out what direction to go
        (cond
          ;If at goal, do nothing
          ((equal (start self) (end self))
           :nop)
           ;If next step in final to right of start 
          ((equal (car (final self)) (list (+ 1 (caar (start self))) (cadar (start self))))
           ;Set start one space to the right, remove step from final, move right
           (setf (start self) (dolist (n (closed self)) (if (equal (car n) (car (final self))) (return n))))
           (setf (final self) (cdr (final self)))
           :right)
           ;If next step in final to left of start 
          ((equal (car (final self)) (list (- (caar (start self)) 1) (cadar (start self))))
           ;Set start one space to the left, remove step from final, move left
           (setf (start self) (dolist (n (closed self)) (if (equal (car n) (car (final self))) (return n))))
           (setf (final self) (cdr (final self)))
           :left)
           ;If next step in final to back of start 
          ((equal (car (final self)) (list (caar (start self)) (- (cadar (start self)) 1)))
           ;Set start one space back, remove step from final, move backwards
           (setf (start self) (dolist (n (closed self)) (if (equal (car n) (car (final self))) (return n))))
           (setf (final self) (cdr (final self)))
           :backward)
           ;If next step in final to front of start 
          ((equal (car (final self)) (list (caar (start self)) (+ (cadar (start self)) 1)))
           ;Set start one space forward, remove step from final, move forward
           (setf (start self) (dolist (n (closed self)) (if (equal (car n) (car (final self))) (return n))))
           (setf (final self) (cdr (final self)))
           :forward)
          )
        )
        )
    )

(defclass astar-agent-manhatten (robot)

                                        ;This code is exactly the same as astar-crow and uniform-costs agents. I copy and pasted them for my convenience
                                        ;The only difference is the changed the heuristic function for each agent
  
                                        ;This should be implemented with the professor's (x y) system
  
                                        ;nodes in form of: '((x y) z g h f)
                                        ;x -
                                        ;y -
                                        ;z - node's parent
                                        ;g - distance between node and start
                                        ;h - heurisitc between node and end
                                        ;f - g + h
  
  ((start-node :accessor start                   ;Where the robot starts - also represents current spot robot is at when astar is done running
               :initform '((1 1) nil 0 0 0)      ;When initialized, (x y) - where you start, the rest must be nil 0 0 0
               :initarg :start)
   (end-node :accessor end                       ;End goal of agent
             :initform '((1 1) nil 0 0 0)         ;When initialized, (x y) - end goal, the rest must be nil 0 0 0
             :initarg :end)
   (open-list :accessor open-list                ;List of open nodes
              :initform '(((1 1) nil 0 0 0))     ;Initialize as list with start-node in it
              :initarg :open)
   (closed-list :accessor closed                 ;List of closed nodes
                :initform '())
   (final-path :accessor final                   ;Final solution
               :initform '())
   (map-width :accessor width                    ;Width of map
              :initform 10
              :initarg :width)
   (map-height :accessor height                  ;Height of map
               :initform 10
               :initarg :height)
   (obstacles :accessor obstacles                ;List of ordered pairs indicating where obstacles are
              :initform '()
              :initarg :obstacles)
   (nesw :accessor nesw                          ;Orientation or agent: n=north, e=east, s=south, or w=west
         :initform 'n
         :initarg :nesw)
   (astar-run :accessor arun                     ;Boolean whether astar has run yet
              :initform nil)
   (nodes-visited :accessor nodes                ;Tracking Number of Nodes visited
                  :initform 0)
   (max-open-list-size :accessor max-size        ;Tracking max open-list size
                       :initform 0)
   )
  )


(export 'astar-agent-manhatten)

;Calculates heuristic for manhatten distance
;Requires two ordered pair lists. one representing the node and the other the goal
(defmethod manhatten-heuristic (node goal)
  (+ (abs (- (caar goal) (caar node))) (abs (- (cadar goal) (cadar node))))
)

(defmethod agent-program ((self astar-agent-manhatten) percept)
  
  ;This entire block is astar, everything else is robot handling
  (block astar
    (if (arun self)
        (return-from astar)
        )
    
    ;Iterate until open-list is empty
    (loop
      (setf (nodes self) (+ 1 (nodes self)))
      (if (> (length (open-list self)) (max-size self))
          (setf (max-size self) (length (open-list self)))
          )
      
      ;current node
      (let ((current '(nil nil nil nil 999999999)))

        ;set current to node in open-list with smallest f value
        (dolist (n (open-list self))
          (if (< (car (last n)) (car (last current)))
              (setf current n)
              
              )
          )
        ;remove current from open-list and add to closed-list
        (setf (open-list self) (remove current (open-list self) :test #'equal))
        (setf (closed self) (cons current (closed self)))
        
        ;if current is end goal
        (if (equal (car current) (car (end self)))
            (progn
              ;backtrack through from node to parent, reconstructing path for final answer
              (loop
                (setf (final self) (cons (car current) (final self)))
                (dolist (n (closed self))
                  (if (equal (cadr current) (car n))
                      (progn
                        (setf current n)
                        (return)
                        )
                      )
                  )
                (when (equal (cadr current) '()) (return))
                )
              ;set arun t, and exit from astar loop
              (setf (arun self) t)
              (return-from astar)
              )
            )

        (let
            ;list of children nodes
            ((children '())
             ;list of potential children coordinates
             (potentials (list
                          (list (caar current) (+ (cadar current) 1))
                          (list (caar current) (- (cadar current) 1))
                          (list (+ (caar current) 1) (cadar current))
                          (list (- (caar current) 1) (cadar current))
                          )
                         )
             )

          ;check if each potential child/move is walkable
          (dolist (x potentials)
            (if        
             (and
              ;is move within bounds of map
              (and (and (> (car x) 0) (<= (car x) (width self))) (and (> (cadr x) 0) (<= (cadr x) (height self))))
              ;is move not an obstacle
              (block obstacle-block
                (dolist (n (obstacles self))
                  (if (equal n x)
                      (return-from obstacle-block nil)
                      )
                  )
                (return-from obstacle-block t)
                )
              )
             ;make move a node and add to children
             (setf children (cons (list x (car current) nil nil nil) children))
             )
            )
          ;for each child
          (dolist (n children)
            ;unless child is already closed
            (unless
                (block check-closed
                  ;Iterate through closed, if child has same indices as element in closed, return t
                  (dolist (x (closed self))
                    (if (equal (car x) (car n))
                        (return-from check-closed t)
                        )
                    )
                  (return-from check-closed nil)
                  )

              ;iterate through closed 
              (dolist (x (closed self))
                ;if found node's parent
                (if (equal (cadr n) (car x))
                                        ;calculate and set nodes g, h, and f
                    (setf n (list (car n) (cadr n) (+ 1 (caddr x)) (manhatten-heuristic n (end self)) (+ (+ 1 (caddr x)) (manhatten-heuristic n (end self)))))
                    ) 
                )

              ;unless child is already on open list with a smaller g, add child to open list
              (unless
                  (block check-open
                    ;for open node
                    (dolist (w (open-list self))
                      ;if node is same as child
                      (if (equal (car n) (car w))
                          ;if child g is smaller than node in open g
                          (if (> (caddr w) (caddr n))
                              ;remove node on open and replace it with child, then break out of loop with t
                              (progn
                                (setf (open-list self) (remove w (open-list self) :test #'equal))
                                (setf (open-list self) (cons n (open-list self)))
                                (return-from check-open t))
                              ;break out of loop with t
                              (return-from check-open t)
                              )
                          )
                      )
                    (return-from check-open nil)
                    )
                ;if loop wasn't broken out of with t, add child to open list
                (setf (open-list self) (cons n (open-list self)))
                )
              )
            )
          )
        
        )
      (when (equal (open-list self) '()) (return-from astar))
      )
    )
    ;End of block astar
  
  ;If not facing north, orient the robot so it always faces north.
  (if (not (equal (nesw self) 'n))
      (cond ((equal (nesw self) 'w)
             (setf (nesw self) 'n)
             :turn-right)
            ((equal (nesw self) 'e)
             (setf (nesw self) 'n)
             :turn-left)
            ((equal (nesw self) 's)
             (setf (nesw self) 'e)
             :turn-left)
            )
      (progn
        (print "Max Open-list size was:")
        (print (max-size self))
        (print "Number of nodes visited was:")
        (print (nodes self))
        (print " ")
        ;Otherwise figure out what direction to go
        (cond
          ;If at goal, do nothing
          ((equal (start self) (end self))
           :nop)
         ;If next step in final to right of start 
          ((equal (car (final self)) (list (+ 1 (caar (start self))) (cadar (start self))))
                                        ;Set start one space to the right, remove step from final, move right
           (setf (start self) (dolist (n (closed self)) (if (equal (car n) (car (final self))) (return n))))
           (setf (final self) (cdr (final self)))
           :right)
          ;If next step in final to left of start 
          ((equal (car (final self)) (list (- (caar (start self)) 1) (cadar (start self))))
                                        ;Set start one space to the left, remove step from final, move left
           (setf (start self) (dolist (n (closed self)) (if (equal (car n) (car (final self))) (return n))))
           (setf (final self) (cdr (final self)))
           :left)
          ;If next step in final to back of start 
          ((equal (car (final self)) (list (caar (start self)) (- (cadar (start self)) 1)))
           ;Set start one space back, remove step from final, move backwards
           (setf (start self) (dolist (n (closed self)) (if (equal (car n) (car (final self))) (return n))))
           (setf (final self) (cdr (final self)))
           :backward)
          ;If next step in final to front of start 
          ((equal (car (final self)) (list (caar (start self)) (+ (cadar (start self)) 1)))
           ;Set start one space forward, remove step from final, move forward
           (setf (start self) (dolist (n (closed self)) (if (equal (car n) (car (final self))) (return n))))
           (setf (final self) (cdr (final self)))
           :forward)
          )
        )
      )
  )

(defclass astar-agent-crow (robot)
                                        ;This code is exactly the same as astar-manhatten and uniform-costs agents. I copy and pasted them for my convenience
                                        ;The only difference is the changed the heuristic function for each agent
                                        
                                        ;This should be implemented with the professor's (x y) system
  
                                        ;nodes in form of: '((x y) z g h f)
                                        ;x -
                                        ;y -
                                        ;z - node's parent
                                        ;g - distance between node and start
                                        ;h - heurisitc between node and end
                                        ;f - g + h
  
  ((start-node :accessor start                   ;Where the robot starts - also represents current spot robot is at when astar is done running
               :initform '((1 1) nil 0 0 0)      ;When initialized, (x y) - where you start, the rest must be nil 0 0 0
               :initarg :start)
   (end-node :accessor end                       ;End goal of agent
             :initform '((1 1) nil 0 0 0)         ;When initialized, (x y) - end goal, the rest must be nil 0 0 0
             :initarg :end)
   (open-list :accessor open-list                ;List of open nodes
              :initform '(((1 1) nil 0 0 0))     ;Initialize as list with start-node in it
              :initarg :open)
   (closed-list :accessor closed                 ;List of closed nodes
                :initform '())
   (final-path :accessor final                   ;Final solution
               :initform '())
   (map-width :accessor width                    ;Width of map
              :initform 10
              :initarg :width)
   (map-height :accessor height                  ;Height of map
               :initform 10
               :initarg :height)
   (obstacles :accessor obstacles                ;List of ordered pairs indicating where obstacles are
              :initform '()
              :initarg :obstacles)
   (nesw :accessor nesw                          ;Orientation or agent: n=north, e=east, s=south, or w=west
         :initform 'n
         :initarg :nesw)
   (astar-run :accessor arun                     ;Boolean whether astar has run yet
              :initform nil)
   (nodes-visited :accessor nodes                ;Tracking number of nodes visited
                  :initform 0)
   (max-open-list-size :accessor max-size        ;Tracking max open-list size
                       :initform 0)
   )
  )                                    

(export 'astar-agent-crow)

;Calculates heuristic for distance as the crow flies
;Requires two ordered pair lists. one representing the node and the other the goal
(defmethod crow-heuristic (node goal)
  (sqrt (+ (expt (abs (- (caar goal) (caar node))) 2) (expt (abs (- (cadar goal) (cadar node))) 2)))
  )

(defmethod agent-program ((self astar-agent-crow) percept)
    
    ;This entire block is astar, everything else is robot handling
    (block astar
      (if (arun self)
          (return-from astar)
          )
      
      ;Iterate until open-list is empty
      (loop
        (setf (nodes self) (+ 1 (nodes self)))
        (if (> (length (open-list self)) (max-size self))
            (setf (max-size self) (length (open-list self)))
            )
        
        ;current node
        (let ((current '(nil nil nil nil 999999999)))

          ;set current to node in open-list with smallest f value
          (dolist (n (open-list self))
            (if (< (car (last n)) (car (last current)))
                (setf current n)
                
                )
            )

          ;remove current from open-list and add to closed-list
          (setf (open-list self) (remove current (open-list self) :test #'equal))
          (setf (closed self) (cons current (closed self)))
          
          ;if current is end goal
          (if (equal (car current) (car (end self)))
              (progn
                ;backtrack through from node to parent, reconstructing path for final answer
                (loop
                  (setf (final self) (cons (car current) (final self)))
                  (dolist (n (closed self))
                    (if (equal (cadr current) (car n))
                        (progn
                          (setf current n)
                          (return)
                          )
                        )
                    )
                  (when (equal (cadr current) '()) (return))
                  )
                ;set arun t, and exit from astar loop
                (setf (arun self) t)
                (return-from astar)
                )
              )
          (let
              ;list of children nodes
              ((children '())
               ;list of potential children coordinates
               (potentials (list
                            (list (caar current) (+ (cadar current) 1))
                            (list (caar current) (- (cadar current) 1))
                            (list (+ (caar current) 1) (cadar current))
                            (list (- (caar current) 1) (cadar current))
                            )
                           )
               )

            ;check if each potential child/move is walkable
            (dolist (x potentials)
              (if        
               (and
                ;is move within bounds of map
                (and (and (> (car x) 0) (<= (car x) (width self))) (and (> (cadr x) 0) (<= (cadr x) (height self))))
                ;is move not an obstacle
                (block obstacle-block
                  (dolist (n (obstacles self))
                    (if (equal n x)
                        (return-from obstacle-block nil)
                        )
                    )
                  (return-from obstacle-block t)
                  )
                )
               ;make move a node and add to children
               (setf children (cons (list x (car current) nil nil nil) children))
               )
              )
            ;for each child
            (dolist (n children)
              ;unless child is already closed
              (unless
                  (block check-closed
                    ;Iterate through closed, if child has same indices as element in closed, return t
                    (dolist (x (closed self))
                      (if (equal (car x) (car n))
                          (return-from check-closed t)
                          )
                      )
                    (return-from check-closed nil)
                    )

                ;iterate through closed 
                (dolist (x (closed self))
                  ;if found node's parent
                  (if (equal (cadr n) (car x))
                      ;calculate and set nodes g, h, and f
                      (setf n (list (car n) (cadr n) (+ 1 (caddr x)) (crow-heuristic n (end self)) (+ (+ 1 (caddr x)) (crow-heuristic n (end self)))))
                      ) 
                  )

                ;unless child is already on open list with a smaller g, add child to open list
                (unless
                    (block check-open
                      ;for open node
                      (dolist (w (open-list self))
                        ;if node is same as child
                        (if (equal (car n) (car w))
                            ;if child g is smaller than node in open g
                            (if (> (caddr w) (caddr n))
                                ;remove node on open and replace it with child, then break out of loop with t
                                (progn
                                  (setf (open-list self) (remove w (open-list self) :test #'equal))
                                  (setf (open-list self) (cons n (open-list self)))
                                  (return-from check-open t))
                                ;break out of loop with t
                                (return-from check-open t)
                                )
                            )
                        )
                      (return-from check-open nil)
                      )
                  ;if loop wasn't broken out of with t, add child to open list
                  (setf (open-list self) (cons n (open-list self)))
                  )
                )
              )
            )
          
          )
        (when (equal (open-list self) '()) (return-from astar))
        )
      )
      ;End of block astar
    
    ;If not facing north, orient the robot so it always faces north.
    (if (not (equal (nesw self) 'n))
        (cond ((equal (nesw self) 'w)
               (setf (nesw self) 'n)
               :turn-right)
              ((equal (nesw self) 'e)
               (setf (nesw self) 'n)
               :turn-left)
              ((equal (nesw self) 's)
               (setf (nesw self) 'e)
               :turn-left)
              )
        (progn
          (print "Max Open-list size was:")
          (print (max-size self))
          (print "Number of nodes visited was:")
          (print (nodes self))
          (print " ")
        ;Otherwise figure out what direction to go
        (cond
         ;If at goal, do nothing
          ((equal (start self) (end self))
           :nop)
          ;If next step in final to right of start 
          ((equal (car (final self)) (list (+ 1 (caar (start self))) (cadar (start self))))
           ;Set start one space to the right, remove step from final, move right
           (setf (start self) (dolist (n (closed self)) (if (equal (car n) (car (final self))) (return n))))
           (setf (final self) (cdr (final self)))
           :right)
          ;If next step in final to left of start 
          ((equal (car (final self)) (list (- (caar (start self)) 1) (cadar (start self))))
           ;Set start one space to the left, remove step from final, move left
           (setf (start self) (dolist (n (closed self)) (if (equal (car n) (car (final self))) (return n))))
           (setf (final self) (cdr (final self)))
           :left)
          ;If next step in final to back of start 
          ((equal (car (final self)) (list (caar (start self)) (- (cadar (start self)) 1)))
           ;Set start one space back, remove step from final, move backwards
           (setf (start self) (dolist (n (closed self)) (if (equal (car n) (car (final self))) (return n))))
           (setf (final self) (cdr (final self)))
           :backward)
           ;If next step in final to front of start 
          ((equal (car (final self)) (list (caar (start self)) (+ (cadar (start self)) 1)))
           ;Set start one space forward, remove step from final, move forward
           (setf (start self) (dolist (n (closed self)) (if (equal (car n) (car (final self))) (return n))))
           (setf (final self) (cdr (final self)))
           :forward)
          )
        )
        )
    )

;***********************************************************************************************************************************************************************************
;Important: Everything beyond this line is incomplete. The 8-puzzle game *should* work, but I am still in the process of translating the A* Code
;***********************************************************************************************************************************************************************************



(defclass 8-puzzle ()

                                        ;Important: Not all start and and goal states of 8-puzzle are solvable.
                                        ;This is not me, this is just the reality of the puzzle. This will not work if the end state is not reachable from the start state
  
  (;These are the puzzle variables
   (initial :accessor initial
            :initform '((1 8 2) (x 4 3) (7 6 5))
            :initarg :initial)
   (indices :accessor indices                              ;  (((1 1) (1 2) (1 3))      what coordinates map to what spot on board
            :initform '(2 1)                               ;  ((2 1) (2 2) (2 3))
            :initarg :indices)                             ;  ((3 1) (3 2) (3 3)))



                                                                        ;These are the astar variables. Astar will not touch the puzzle variables at all.
   
   (start-node :accessor start                                          ;Where astar the robot starts - also represents current spot astar is at when astar is done running
                :initform '(((1 8 2) (x 4 3) (7 6 5)) nil (2 1) 0 0 0)        ;When initialized it must be in the form of: ((starting board position) nil (where x is) 0 0 0)
                :initarg :start)
   (end-node :accessor end                                              ;End goal of agent
             :initform '(((1 2 3) (4 5 6) (7 8 x)) nil (3 3) 0 0 0)           ;When initialized it must be in the form of: ((final board position) nil (where x will be)  0 0 0)
              :initarg :end)
    (open-list :accessor open-list                                      ;List of open nodes
               :initform '((((1 8 2) (x 4 3) (7 6 5)) nil (2 1) 0 0 0))       ;Initialize as list with start-node in it
               :initarg :open)
    (closed-list :accessor closed                                       ;List of closed nodes
                 :initform '())
    (final-path :accessor final                                         ;Final solution
                :initform '())
  )
  )

(export '8-puzzle)

;slide piece to right of empty slot left, into the empty slot
(defmethod slide-left ((self 8-puzzle))
  
  (if (or (or (equal (caddar (initial self)) 'x) (equal (car (cddadr (initial self))) 'x)) (equal (cadr (cdaddr (initial self))) 'x))
      (print "Not valid move. Try again")
      (progn
        (setf (nth (- (cadr (indices self)) 1) (nth (- (car (indices self)) 1) (initial self))) (nth (cadr (indices self)) (nth (- (car (indices self)) 1) (initial self))))
        (setf (nth (cadr (indices self)) (nth (- (car (indices self)) 1) (initial self))) 'x)
        (setf (indices self) (list (car (indices self)) (+ (cadr (indices self)) 1)))
        )
      ) 
  )

(defmethod slide-right ((self 8-puzzle)) 
  (if (or (or (equal (caar (initial self)) 'x) (equal (caadr (initial self)) 'x)) (equal (caaddr (initial self)) 'x))
      (print "Not valid move. Try again")
      (progn
        (setf (nth (- (cadr (indices self)) 1) (nth (- (car (indices self)) 1) (initial self))) (nth (- (cadr (indices self)) 2) (nth (- (car (indices self)) 1) (initial self))))
        (setf (nth (- (cadr (indices self)) 2) (nth (- (car (indices self)) 1) (initial self))) 'x)
        (setf (indices self) (list (car (indices self)) (- (cadr (indices self)) 1)))
        )
      )  
  )

(defmethod slide-up ((self 8-puzzle))

  (if (or (or (equal (caaddr (initial self)) 'x) (equal (cadr (caddr (initial self))) 'x)) (equal (caddr (caddr (initial self))) 'x))
      (print "Not valid move. Try again")
      (progn
        (setf (nth (- (cadr (indices self)) 1) (nth (- (car (indices self)) 1) (initial self))) (nth (- (cadr (indices self)) 1) (nth (car (indices self)) (initial self))))
        (setf (nth (- (cadr (indices self)) 1) (nth (car (indices self)) (initial self))) 'x)
        (setf (indices self) (list (+ (car (indices self)) 1) (cadr (indices self))))
        )
      )

  )

(defmethod slide-down ((self 8-puzzle))

  (if (or (or (equal (caar (initial self)) 'x) (equal (cadar (initial self)) 'x)) (equal (caddar (initial self)) 'x))
      (print "Not valid move. Try again") 
      (progn
        (setf (nth (- (cadr (indices self)) 1) (nth (- (car (indices self)) 1) (initial self))) (nth (- (cadr (indices self)) 1) (nth (- (car (indices self)) 2) (initial self))))
        (setf (nth (- (cadr (indices self)) 1) (nth (- (car (indices self)) 2) (initial self))) 'x)
        (setf (indices self) (list (- (car (indices self)) 1) (cadr (indices self))))
        )
      )
  )


(defmethod print-puzzle ((self 8-puzzle))
  (print (car (initial self)))
  (print (cadr (initial self)))
  (print (caddr (initial self)))

  )

(defmethod heuristic (node goal)

  (let ((count 0))
    (loop for n in (car node)
          for g in (car goal)
          do (loop for nn in n
                for gg in g
                do (if (not (equal nn gg))
                    (setf count (+ 1 count))
                    )
                )
          )
    count
    )
  )

(defmethod astar-puzzle ((self 8-puzzle))


    ;Iterate until open-list is empty
    (loop
      ;current node
      (let ((current '(nil nil nil nil nil 999999999)))

        ;set current to node in open-list with smallest f value
        (dolist (n (open-list self))
          (if (< (car (last n)) (car (last current)))
              (setf current n)
              
              )
          )

        ;remove current from open-list and add to closed-list
        (setf (open-list self) (remove current (open-list self) :test #'equal))
        (setf (closed self) (cons current (closed self)))
        
        ;if current is end goal
        (if (equal (car current) (car (end self)))
            ;backtrack through from node to parent, reconstructing path for final answer
            (loop
              (setf (final self) (cons (caddr current) (final self)))
              (dolist (n (closed self))
                (if (equal (cadr current) (car n))
                    (progn
                      (setf current n)
                      (return)
                      )
                    )
                )
              (when (equal (cadr current) '()) (return))
              )
            )
        (let
            ;list of children nodes
            ((children '())
             ;list of potential children node states
             (potentials (list
                          (nth (cadr (caddr current)) (nth (- (car (caddr current)) 1) (car current)))
                          (nth (- (cadr (caddr current)) 2) (nth (- (car (caddr current)) 1) (car current)))
                          (nth (- (cadr (caddr current)) 1) (nth (car (caddr current)) (car current)))
                          (nth (- (cadr (caddr current)) 1) (nth (- (car (caddr current)) 2) (car current)))
                          )
                         )
             )

          ;check if each potential is walkable
          (if (not (or (or (equal (caddar (initial self)) 'x) (equal (car (cddadr (initial self))) 'x)) (equal (cadr (cdaddr (initial self))) 'x)))
              (setf children (cons (list (car potentials) (car current) (caddr current)  nil nil nil) children))
              )

          (if (or (or (equal (caar (initial self)) 'x) (equal (caadr (initial self)) 'x)) (equal (caaddr (initial self)) 'x))
              (setf children (cons (list (cadr potentials) (car current) (caddr current) nil nil nil) children))
              )

          (if (or (or (equal (caaddr (initial self)) 'x) (equal (cadr (caddr (initial self))) 'x)) (equal (caddr (caddr (initial self))) 'x))
              (setf children (cons (list (caddr potentials) (car current) (caddr current) nil nil nil) children))
              )
          
          (if (or (or (equal (caar (initial self)) 'x) (equal (cadar (initial self)) 'x)) (equal (caddar (initial self)) 'x))
              (setf children (cons (list (cadddr potentials) (car current) (caddr current) nil nil nil) children))
              )
              
          ;for each child
          (dolist (n children)
            ;unless child is already closed
            (unless
                (block check-closed
                  ;Iterate through closed, if child has same indices as element in closed, return t
                  (dolist (x (closed self))
                    (if (equal (car x) (car n))
                        (return-from check-closed t)
                        )
                    )
                  (return-from check-closed nil)
                  )

              ;iterate through closed 
              (dolist (x (closed self))
                ;if found node's parent
                (if (equal (cadr n) (car x))
                    ;calculate and set nodes g, h, and f
                    (setf n (list (car n) (cadr n) (caddr n) (+ 1 (cadddr x)) (heuristic n (end self)) (+ (+ 1 (cadddr x)) (heuristic n (end self)))))
                    ) 
                )

              ;unless child is already on open list with a smaller g, add child to open list
              (unless
                  (block check-open
                    ;for open node
                    (dolist (w (open-list self))
                      ;if node is same as child
                      (if (equal (car n) (car w))
                          ;if child g is smaller than node in open g
                          (if (> (cadddr w) (cadddr n))
                              ;remove node on open and replace it with child, then break out of loop with t
                              (progn
                                (setf (open-list self) (remove w (open-list self) :test #'equal))
                                (setf (open-list self) (cons n (open-list self)))
                                (return-from check-open t))
                              ;break out of loop with t
                              (return-from check-open t)
                              )
                          )
                      )
                    (return-from check-open nil)
                    )
                ;if loop wasn't broken out of with t, add child to open list
                (setf (open-list self) (cons n (open-list self)))
                )
              )
            )
          )
        
        )
      (when (equal (open-list self) '()) (return))
      )
    
    (loop 
      
      ;figure out what direction to go
      (cond
        ;If at goal,exit  loop
        ((equal (start self) (end self))
         (return nil))
        ;Slide up
        ((equal (caddr (final self)) (list (+ 1 (caaddr (start self))) (car (cdaddr (start self)))))
         ;Set start one space to down, remove step from final, slide up
         (setf (start self) (dolist (n (closed self)) (if (equal (car n) (car (final self))) (return n))))
         (setf (final self) (cdr (final self)))
         (slide-up self)
        (print-puzzle self))
         ;Slide down 
        ((equal (caddr (final self)) (list (+ 1 (caaddr (start self))) (car (cdaddr (start self)))))
         ;Set start one space to up, remove step from final, slide down
         (setf (start self) (dolist (n (closed self)) (if (equal (car n) (car (final self))) (return n))))
         (setf (final self) (cdr (final self)))
         (slide-down self)
         (print-puzzle self))
         ;Slide left
        ((equal (caddr (final self)) (list (caaddr (start self)) (+ (car (cdaddr (start self))) 1)))
         ;Set start one space to right, remove step from final, slide left
         (setf (start self) (dolist (n (closed self)) (if (equal (car n) (car (final self))) (return n))))
         (setf (final self) (cdr (final self)))
         (slide-left self)
         (print-puzzle self))
         ;Slide right 
        ((equal (caddr (final self)) (list (caaddr (start self)) (- (car (cdaddr (start self))) 1)))
         ;Set start one space to left, remove step from final, slide right
         (setf (start self) (dolist (n (closed self)) (if (equal (car n) (car (final self))) (return n))))
         (setf (final self) (cdr (final self)))
         (slide-right self)
         (print-puzzle self))
        )
      )
  )
  


