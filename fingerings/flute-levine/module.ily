#(define-markup-command (slashed layout props input) (markup?)
    (interpret-markup layout props
      (markup #:combine #:override '(thickness . 1.5) #:draw-line '(1.25 . 1.5) input
    )))

#(define-markup-command (levine-flute-normal-fingers layout props arg-list) (list?)
    (let *(
        (cc (first arg-list))
        (lh (second arg-list))
        (rh (third arg-list))
    )
    (interpret-markup layout props
      (markup
            #:override '(word-space . -1)
            #:override '(font-name . "Arial")
            #:line (
                    #:fontsize 0
                    #:pad-x 1.25
                    #:override '(baseline-skip . 9.1)
                    #:center-column (
                        #:vspace 1.5
                        (cond
                            ((memq 'b lh) (markup #:natural))
                            ((memq 'b-c lh) (markup #:filled-box '(0 . 0.75) '(0 . 0.75) 0.1))
                            ((memq 'bes lh) (markup #:flat))
                            ((memq 'bes-c lh) (markup #:filled-box '(0 . 0.75) '(0 . 0.75) 0.1))
                            ((markup #:null))
                        )
                    #:override '(baseline-skip . 2.5)
                    #:center-column (
                        (if (memq 'd rh) "A" (markup #:null))
                        (if (memq 'dis rh) "B" (markup #:null))
                    ))
                #:override '(baseline-skip . 2.5)
                #:center-column (
                #:box
                #:override '(baseline-skip . 2.5)
                #:center-column (
                    #:pad-markup 0.25
                    ;top
                    #:center-column (
                        (cond
                            ((memq 'one cc) "1")
                            ((memq 'one1h cc) (markup #:slashed "1"))
                            ((memq 'one-c cc) (markup #:draw-circle 0.3 0.1 #t))
                            ((markup #:transparent "1")))

                        (cond
                            ((memq 'two cc) "2")
                            ((memq 'two1h cc) (markup #:slashed "2"))
                            ((memq 'two-c cc) (markup #:draw-circle 0.3 0.1 #t))
                            ((markup #:transparent "2")))

                        (cond
                            ((memq 'three cc) "3")
                            ((memq 'three1h cc) (markup #:slashed "3"))
                            ((memq 'three-c cc) (markup #:draw-circle 0.3 0.1 #t))
                            ((markup #:transparent "3")))
                    )
                    #:lower 0.5 #:draw-line '(2 . 0)
                    #:pad-markup 0.25
                    ;bottom
                    #:center-column (
                        (cond
                            ((memq 'four cc) "4")
                            ((memq 'four1h cc) (markup #:slashed "4"))
                            ((memq 'four-c cc) (markup #:draw-circle 0.3 0.1 #t))
                            ((markup #:transparent "4")))
                        (cond
                            ((memq 'five cc) "5")
                            ((memq 'five1h cc) (markup #:slashed "5"))
                            ((memq 'five-c cc) (markup #:draw-circle 0.3 0.1 #t))
                            ((markup #:transparent "5")))
                        (cond
                            ((memq 'six cc) "6")
                            ((memq 'six1h cc) (markup #:slashed "6"))
                            ((memq 'six-c cc) (markup #:draw-circle 0.3 0.1 #t))
                            ((markup #:transparent "6")))

                    ))
                    #:override '(word-space . 0)
                    #:pad-markup 0.5
                    #:line  (
                        (if (memq 'c rh) "C" (markup #:null))
                        (if (memq 'cis rh) (markup #:concat ("C" #:raise 0.5 #:tiny #:sharp)) (markup #:null))
                        (if (memq 'ees rh) (markup #:concat ("D" #:raise 0.5 #:tiny #:sharp)) (markup #:null))
                        (if (memq 'c-c rh) (markup #:filled-box '(0 . 0.75) '(0 . 0.75) 0.1) (markup #:null))
                        (if (memq 'cis-c rh) (markup #:filled-box '(0 . 0.75) '(0 . 0.75) 0.1) (markup #:null))
                        (if (memq 'ees-c rh) (markup #:filled-box '(0 . 0.75) '(0 . 0.75) 0.1) (markup #:null))

                    ))
                    #:translate '(0 . -6.5)
                    #:pad-x 1
                    #:line (
                        (if (memq 'gis lh) (markup #:whiteout #:concat ("G" #:raise 0.5 #:tiny #:sharp)) (markup #:null))
                        (if (memq 'gis-c rh) (markup #:filled-box '(0 . 0.75) '(0 . 0.75) 0.1) (markup #:null))

                    ))))))

#(define-markup-command (levine-flute layout props arg-list) (list?)
    (let *(
        (cc (first arg-list))
        (lh (second arg-list))
        (rh (third arg-list))
    )
    (interpret-markup layout props
      (markup
            #:override '(word-space . -1)
            #:override '(font-name . "Arial")
            #:line (
                    #:fontsize 0
                    #:pad-x 1.25
                    #:override '(baseline-skip . 8.4)
                    #:center-column (
                        #:vspace 0.35
                        (cond
                            ((memq 'b lh) (markup #:natural))
                            ((memq 'bes lh) (markup #:flat))
                            ((markup #:null))
                        )
                    #:override '(baseline-skip . 2.5)
                    #:center-column (
                        (if (memq 'd rh) "A" (markup #:null))
                        (if (memq 'dis rh) "B" (markup #:null))
                    ))
                #:override '(baseline-skip . 2.5)
                #:center-column (
                #:box
                #:override '(baseline-skip . 2.5)
                #:center-column (
                    #:pad-markup 0.25
                    ;top
                    #:center-column (
                        (cond
                            ((memq 'one cc) "2")
                            ((memq 'one1h cc) (markup #:slashed "2"))
                            ((markup #:transparent "2")))

                        (cond
                            ((memq 'two cc) "3")
                            ((memq 'two1h cc) (markup #:slashed "3"))
                            ((markup #:transparent "3")))

                        (cond
                            ((memq 'three cc) "4")
                            ((memq 'three1h cc) (markup #:slashed "4"))
                            ((markup #:transparent "4")))
                    )
                    #:lower 0.5 #:draw-line '(2 . 0)
                    #:pad-markup 0.25
                    ;bottom
                    #:center-column (
                        (cond
                            ((memq 'four cc) "2")
                            ((memq 'four1h cc) (markup #:slashed "2"))
                            ((markup #:transparent "2")))
                        (cond
                            ((memq 'five cc) "3")
                            ((memq 'five1h cc) (markup #:slashed "3"))
                            ((markup #:transparent "3")))
                        (cond
                            ((memq 'six cc) "4")
                            ((memq 'six1h cc) (markup #:slashed "4"))
                            ((markup #:transparent "4")))

                    ))
                    #:override '(word-space . 0)
                    #:pad-markup 0.5
                    #:line  (
                        (if (memq 'c rh) "C" (markup #:null))
                        (if (memq 'cis rh) (markup #:concat ("C" #:raise 0.5 #:tiny #:sharp)) (markup #:null))
                        (if (memq 'ees rh) (markup #:concat ("D" #:raise 0.5 #:tiny #:sharp)) (markup #:null))
                    ))
                    #:translate '(0 . -6.5)
                    #:pad-x 1
                    #:line (
                        (if (memq 'gis lh) (markup #:whiteout #:concat ("G" #:raise 0.5 #:tiny #:sharp)) (markup #:null))
                    )))))
)
