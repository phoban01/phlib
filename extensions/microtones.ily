%{
Define 1/8 alterations.
%}
#(define (naturalize-pitch p)
   (let ((o (ly:pitch-octave p))
         (a (* 4 (ly:pitch-alteration p)))
         ;; alteration, a, in quarter tone steps,
         ;; for historical reasons
         (n (ly:pitch-notename p)))
     (cond
      ((and (> a 1) (or (eq? n 6) (eq? n 2)))
       (set! a (- a 2))
       (set! n (+ n 1)))
      ((and (< a -1) (or (eq? n 0) (eq? n 3)))
       (set! a (+ a 2))
       (set! n (- n 1))))
     (cond
      ((> a 2) (set! a (- a 4)) (set! n (+ n 1)))
      ((< a -2) (set! a (+ a 4)) (set! n (- n 1))))
     (if (< n 0) (begin (set! o (- o 1)) (set! n (+ n 7))))
     (if (> n 6) (begin (set! o (+ o 1)) (set! n (- n 7))))
     (ly:make-pitch o n (/ a 4))))

#(define (naturalize music)
   (let ((es (ly:music-property music 'elements))
         (e (ly:music-property music 'element))
         (p (ly:music-property music 'pitch)))
     (if (pair? es)
         (ly:music-set-property!
          music 'elements
          (map (lambda (x) (naturalize x)) es)))
     (if (ly:music? e)
         (ly:music-set-property!
          music 'element
          (naturalize e)))
     (if (ly:pitch? p)
         (begin
           (set! p (naturalize-pitch p))
           (ly:music-set-property! music 'pitch p)))
     music))

naturalizeMusic =
#(define-music-function (location m)
   (ly:music?)
   (naturalize m))


#(define-public SHARP 1/2)
#(define-public FLAT -1/2)
#(define-public ESHARP 1/8)
#(define-public EFLAT -1/8)
#(define-public QSHARP 1/4)
#(define-public QFLAT -1/4)
#(define-public TQFLAT -3/4)

#(define-public SHARPEF 3/8)
#(define-public SHARPES 5/8)

#(define-public FLATES -3/8)
#(define-public FLATEF -5/8)

%{
Define pitch names
%}

makamPitchNames = #`(
  (c . ,(ly:make-pitch -1 0 NATURAL))
  (d . ,(ly:make-pitch -1 1 NATURAL))
  (e . ,(ly:make-pitch -1 2 NATURAL))
  (f . ,(ly:make-pitch -1 3 NATURAL))
  (g . ,(ly:make-pitch -1 4 NATURAL))
  (a . ,(ly:make-pitch -1 5 NATURAL))
  (b . ,(ly:make-pitch -1 6 NATURAL))

  (cs . ,(ly:make-pitch -1 0 SHARP))
  (ds . ,(ly:make-pitch -1 1 SHARP))
  (es . ,(ly:make-pitch -1 2 SHARP))
  (fs . ,(ly:make-pitch -1 3 SHARP))
  (gs . ,(ly:make-pitch -1 4 SHARP))
  (as . ,(ly:make-pitch -1 5 SHARP))
  (bs . ,(ly:make-pitch -1 6 SHARP))

  (cf . ,(ly:make-pitch -1 0 FLAT))
  (df . ,(ly:make-pitch -1 1 FLAT))
  (ef . ,(ly:make-pitch -1 2 FLAT))
  (ff . ,(ly:make-pitch -1 3 FLAT))
  (gf . ,(ly:make-pitch -1 4 FLAT))
  (af . ,(ly:make-pitch -1 5 FLAT))
  (bf . ,(ly:make-pitch -1 6 FLAT))

  (cqs . ,(ly:make-pitch -1 0 QSHARP))
  (dqs . ,(ly:make-pitch -1 1 QSHARP))
  (eqs . ,(ly:make-pitch -1 2 QSHARP))
  (fqs . ,(ly:make-pitch -1 3 QSHARP))
  (gqs . ,(ly:make-pitch -1 4 QSHARP))
  (aqs . ,(ly:make-pitch -1 5 QSHARP))
  (bqs . ,(ly:make-pitch -1 6 QSHARP))

  (cqf . ,(ly:make-pitch -1 0 QFLAT))
  (dqf . ,(ly:make-pitch -1 1 QFLAT))
  (eqf . ,(ly:make-pitch -1 2 QFLAT))
  (fqf . ,(ly:make-pitch -1 3 QFLAT))
  (gqf . ,(ly:make-pitch -1 4 QFLAT))
  (aqf . ,(ly:make-pitch -1 5 QFLAT))
  (bqf . ,(ly:make-pitch -1 6 QFLAT))

  (ctqf . ,(ly:make-pitch -1 0 TQFLAT))
  (dtqf . ,(ly:make-pitch -1 1 TQFLAT))
  (etqf . ,(ly:make-pitch -1 2 TQFLAT))
  (ftqf . ,(ly:make-pitch -1 3 TQFLAT))
  (gtqf . ,(ly:make-pitch -1 4 TQFLAT))
  (atqf . ,(ly:make-pitch -1 5 TQFLAT))
  (btqf . ,(ly:make-pitch -1 6 TQFLAT))

  (ces . ,(ly:make-pitch -1 0 ESHARP))
  (des . ,(ly:make-pitch -1 1 ESHARP))
  (ees . ,(ly:make-pitch -1 2 ESHARP))
  (fes . ,(ly:make-pitch -1 3 ESHARP))
  (ges . ,(ly:make-pitch -1 4 ESHARP))
  (aes . ,(ly:make-pitch -1 5 ESHARP))
  (bes . ,(ly:make-pitch -1 6 ESHARP))

  (cef . ,(ly:make-pitch -1 0 EFLAT))
  (def . ,(ly:make-pitch -1 1 EFLAT))
  (eef . ,(ly:make-pitch -1 2 EFLAT))
  (fef . ,(ly:make-pitch -1 3 EFLAT))
  (gef . ,(ly:make-pitch -1 4 EFLAT))
  (aef . ,(ly:make-pitch -1 5 EFLAT))
  (bef . ,(ly:make-pitch -1 6 EFLAT))

  (csef . ,(ly:make-pitch -1 0 SHARPEF))
  (dsef . ,(ly:make-pitch -1 1 SHARPEF))
  (esef . ,(ly:make-pitch -1 2 SHARPEF))
  (fsef . ,(ly:make-pitch -1 3 SHARPEF))
  (gsef . ,(ly:make-pitch -1 4 SHARPEF))
  (asef . ,(ly:make-pitch -1 5 SHARPEF))
  (bsef . ,(ly:make-pitch -1 6 SHARPEF))

  (cses . ,(ly:make-pitch -1 0 SHARPES))
  (dses . ,(ly:make-pitch -1 1 SHARPES))
  (eses . ,(ly:make-pitch -1 2 SHARPES))
  (fses . ,(ly:make-pitch -1 3 SHARPES))
  (gses . ,(ly:make-pitch -1 4 SHARPES))
  (ases . ,(ly:make-pitch -1 5 SHARPES))
  (bses . ,(ly:make-pitch -1 6 SHARPES))

  (cfes . ,(ly:make-pitch -1 0 FLATES))
  (dfes . ,(ly:make-pitch -1 1 FLATES))
  (efes . ,(ly:make-pitch -1 2 FLATES))
  (ffes . ,(ly:make-pitch -1 3 FLATES))
  (gfes . ,(ly:make-pitch -1 4 FLATES))
  (afes . ,(ly:make-pitch -1 5 FLATES))
  (bfes . ,(ly:make-pitch -1 6 FLATES))

  (cfef . ,(ly:make-pitch -1 0 FLATEF))
  (dfef . ,(ly:make-pitch -1 1 FLATEF))
  (efef . ,(ly:make-pitch -1 2 FLATEF))
  (ffef . ,(ly:make-pitch -1 3 FLATEF))
  (gfef . ,(ly:make-pitch -1 4 FLATEF))
  (afef . ,(ly:make-pitch -1 5 FLATEF))
  (bfef . ,(ly:make-pitch -1 6 FLATEF))

)


%% set pitch names.
pitchnames = \makamPitchNames
#(ly:parser-set-note-names makamPitchNames)

eighthToneGlyphs = #'(
    (-7/8 . "accidentals.mirroredflat.backslash")
    (-3/4 . "accidentals.mirroredflat.flat")
    (-5/8 . "accidentals.flat.arrowdown")
    (-1/2 . "accidentals.flat")
    (-3/8 . "accidentals.flat.arrowup")
    (-1/4 . "accidentals.mirroredflat")
    (-1/8 . "accidentals.natural.arrowdown")
    (0 . "accidentals.natural")
    (1/8 . "accidentals.natural.arrowup")
    (1/4 . "accidentals.sharp.slashslash.stem")
    (3/8 . "accidentals.sharp.arrowdown")
    (1/2 . "accidentals.sharp")
    (5/8 . "accidentals.sharp.arrowup")
    (6/8 . "accidentals.sharp.slashslash.stemstemstem")
    (7/8 . "accidentals.sharp.slashslashslash.stem")
  )


%%%add to template file->>>>>
\layout {
    \context {
      \Score
      \override Accidental #'glyph-name-alist = \eighthToneGlyphs
      \override AccidentalCautionary #'glyph-name-alist = \eighthToneGlyphs
    }
 }

