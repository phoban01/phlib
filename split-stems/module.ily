% \version "2.18"
% \language "english"
% \pointAndClickOff

%Two cases:

%1: first case is single noteheads which are part of a multi-instrument cluster...
%i.e orchestral natural harmonics in string parts

%2: second case are double stopped artificial harmonics.

#(define (curved-stem grob pos-list)
    (let* (
        (stencil (ly:stem::print grob))
        (dir (ly:grob-property grob 'direction))
        (th (* (ly:grob-property grob 'thickness) 0.1))
        (positions (ly:stencil-extent stencil Y))
        (positions (if (equal? dir 1) (cons (cdr positions) (car positions)) positions))
        (beam (ly:grob-object grob 'beam))
        (beam-thickness (if (not (equal? '() beam)) (ly:grob-property beam 'beam-thickness) 0))
        (start (- (car positions) (/ beam-thickness 2)))
        (end (cdr positions))
        (length-val 0.35)
        (new-stem empty-stencil)
    )
    (begin
        (map (lambda (x)
                (set! new-stem
                    (ly:stencil-add
                    (if (equal? #f (first x))
                            (ly:stem::print grob)
                    (if (third x)
                        (grob-interpret-markup grob
                            (markup
                            #:postscript (ly:format "
                                /lv ~4f def /start ~4f def /end ~4f def /offset ~4f def /thick ~4f def
                                /length end start sub def
                                /direction ~4f def
                                direction 1 eq
                                    {/offset offset thick 1.25 mul add def}
                                    {/offset offset thick 0.25 mul sub def}
                                ifelse
                                thick setlinewidth
                                offset end moveto
                                0 -0.55 rlineto
                                stroke
                                " 0.5 (+ start (* th dir)) (first x) (second x) th dir)
                            ))
                    (grob-interpret-markup grob
                        (markup
                        #:postscript (ly:format "
                            /lv ~4f def /start ~4f def /end ~4f def /offset ~4f def /thick ~4f def
                            /length end start sub def
                            /direction ~4f def /hasbeam ~4f def
                            hasbeam 0 eq
                                {/beam-adjust-fac 1.325 def}
                                {/beam-adjust-fac 1.5 def}
                            ifelse
                            direction 1 eq
                                {/offset offset thick 0.25 mul add def}
                                {/offset offset thick 0.35 mul sub def}
                            ifelse
                            1 setlinecap
                            thick setlinewidth
                            thick 1 mul 0 translate
                            direction 1 eq
                                {thick neg start thick beam-adjust-fac mul sub moveto}
                                {thick neg start thick beam-adjust-fac mul add moveto}
                            ifelse
                            0 length lv mul rlineto
                            0 length lv mul
                            direction 1 eq
                                {offset length 1 lv sub 0.5 mul mul}
                                {offset length 1 lv sub 0.65 mul mul}
                            ifelse
                            direction 1 eq
                                {offset length 1 lv sub 0.8 mul mul rcurveto}
                                {offset length 1 lv sub 0.8 mul mul rcurveto}
                            ifelse
                            0 length lv 0.4 mul mul rlineto
                            stroke
                            " length-val (+ start (* th dir)) (first x) (second x) th dir beam-thickness)
                        ))))
                new-stem))
        ) pos-list)
    (ly:grob-set-property! grob 'stencil new-stem))
    #t
    )
)

#(define (move-note notehead offset . args)
    (let* (
        (acc (ly:grob-object notehead 'accidental-grob))
        (acc-width (if (not (equal? '() acc)) (interval-length (ly:grob-property acc 'X-extent))))
        (acc-offset 0)
        (note-width (interval-length (ly:grob-property notehead 'X-extent)))
        (dot (ly:grob-object notehead 'dot))
        (stem-value #f)
        )
    (if (equal? offset #f)
        (begin
            (cond
                ((= (length args) 1) (set! acc-offset (car args)))
            )
            (set! (ly:grob-object notehead 'draw-normal-stem) #t)
            (ly:grob-set-property! notehead 'X-offset 0)
            (if (not (equal? '() acc)) (ly:grob-set-property! acc 'X-offset (- acc-offset acc-width)))
            (if (not (equal? '() dot)) (ly:grob-set-property! dot 'X-offset (* 1.1 note-width)))
        )
        (begin
            (cond
                ((= (length args) 1) (set! acc-offset (car args)))
                ((= (length args) 2) (begin (set! acc-offset (car args)) (set! stem-value (cdr args))))
            )
            (set! (ly:grob-object notehead 'is-artificial-touch-point) stem-value)
            (ly:grob-set-property! notehead 'X-offset offset)
            (if (not (equal? '() acc)) (ly:grob-set-property! acc 'X-offset (- acc-offset acc-width)))
            (if (not (equal? '() dot)) (ly:grob-set-property! dot 'X-offset (+ offset (* 1 note-width))))
        )
    ))
)

#(define (make-pos-list noteheads)
    (map (lambda (x)
        (if (equal? #t (ly:grob-object x 'draw-normal-stem))
            (list #f)
            (list
                (+ (ly:grob-property x 'Y-offset) (* (ly:grob-property (ly:grob-object x 'stem) 'direction) 0.5))
                (+ (* (* (ly:grob-property (ly:grob-object x 'stem) 'direction) -0.5) (interval-length (ly:grob-property x 'X-extent))) (ly:grob-property x 'X-offset))
                (ly:grob-object x 'is-artificial-touch-point)
            ))
        ) noteheads)
)

#(define (calc-split-stem grob positions)
    (let* (
        (stem (ly:grob-object grob 'stem))
        (note-heads (ly:grob-array->list (ly:grob-object grob 'note-heads)))
        )
     (map (lambda (x y)
            (cond
                ((= (length y) 1) (move-note x (first y)))
                ((= (length y) 2) (move-note x (first y) (second y)))
                ((= (length y) 3) (move-note x (first y) (second y) (third y)))
            )
         ) note-heads positions)
    ;;store this for later so we can call it after line breaking has occured
    (set! (ly:grob-object stem 'notehead-positions) (make-pos-list note-heads))
    )
)

#(define (draw-split-stem grob)
    (let* (
        (positions (ly:grob-object grob 'notehead-positions))
        )
    (curved-stem grob positions)
    )
)

splitStem = #(define-music-function (layout props position-list music) (list? ly:music?)
    #{
        \temporary \override Staff.NoteHead.stem-attachment = #ly:note-head::calc-stem-attachment
        \once\override NoteColumn.before-line-breaking = #(lambda (grob) (calc-split-stem grob position-list))
        \once\override Stem.after-line-breaking = #draw-split-stem
        $music
        \revert Staff.NoteHead.stem-attachment

    #}
)

%Doesn't work in polyphonic situations
%Apart from that it's robust...
% smallNote = {
%         \once\override Accidental.font-size = #-3
%         \once\override NoteHead.font-size = #-5
%         \once\override Dots.transparent = ##t
% }

% \score {
%     \new Staff \with {
%         \remove "Dot_column_engraver"
%         \override Stem.stemlet-length = #1
%         \override Flag.font-size = #2
%         \override Flag.stencil = #flat-flag
%         \override Dots.X-offset = #(lambda (grob)
%                 (let* (
%                     (parent (ly:grob-parent grob X))
%                     (size (interval-length (ly:grob-property parent 'X-extent)))
%                 )
%                 (* size 1.1)
%                 ))
%         #(set-accidental-style 'neo-modern)
%     }{
%         \omit Score.BarNumber
%         \stemDown
%         \splitStem #'((-2 -3.5) (-2 -2.5 #t) (1 0.75) (1 0 #t))
%         <cqs' fqs'\harmonic fqf' bqf'\harmonic>8 [
%         r32

%         \splitStem #'((-4.5 -4.8) (-0.9 -1.25) (3.5 3.1))
%         <gqs' \tweak #'font-size #3 a'! g'!>8. r32 ]

%         \harmonicsOn
%         \stemUp
%         \once\override Stem.length = #9
%         \splitStem #'((-0.5 -0.75) (2.25 2))
%         <c' cqs'>8  r8

%         \stemDown
%         \harmonicsOff
%         \once\override Beam.positions = #'(-4 . -4)
%         \splitStem #'((-1.7 -2.2) (1.3 1))
%         <c'' dqf''\harmonic>16 [ r8.]

%         r32 [
%         \splitStem #'((4 3.5) (#f -0.3) (#f -0.8) (#f -0.5))
%         <fs' bqf' fqf''\harmonic \single\smallNote \parenthesize fqf''' >16. ]
%         \break
%         \splitStem #'((-3 -4.2) (-3 -3.2 #t) (4 3.3) (6 5.7))
%         <cqs'' fqs''\harmonic \single\smallNote \parenthesize  g''' d''>8. r16
%         r2
%         \tuplet 5/4 {\repeat unfold 5 {\splitStem #'((-2 -2.1) (1 0.65)) <aqf'!\harmonic a'! >16 }}
%     }
%     \layout {
%         indent = 0\cm
%     }
% }

% \header {
%   tagline = ""
% }

% \paper {
%   system-system-spacing = #'((basic-distance . 20))
%   left-margin = 3\cm
%   ragged-right = ##t
%   print-page-numbers = ##f
% }
% #(set-global-staff-size 42)
% #(set-default-paper-size "a4" 'landscape)