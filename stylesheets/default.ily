%%DRAWS A TRADITIONAL PIANO CLUSTER --HIDES INTERIOR NOTES AND ACCIDENTALS
#(define (draw-cluster grob)
    (let* (
        (noteheads (ly:grob-array->list (ly:grob-object grob 'note-heads)))
        (cluster-bar-width 0.5)
        (cluster-bar-length (- (interval-length (ly:relative-group-extent (list (first noteheads) (last noteheads)) grob Y)) 1.75))
        (cluster-bar-stencil (ly:stencil-translate (make-connected-path-stencil
                `((0 -0.25) (0 ,(- cluster-bar-length 0.35)) (1 ,cluster-bar-length) (1 0) (0 -0.25)) 0.1 cluster-bar-width 1 #f #t)
                    (cons 0.4 0.5)))
        (first-stencil (ly:grob-property (first noteheads) 'stencil))
        (new-stencil (ly:stencil-add first-stencil cluster-bar-stencil))
        )
    (map (lambda (x)
            (if (and (not (equal? x (first noteheads))) (not (equal? x (last noteheads))))
                    (begin
                        (ly:grob-set-property! x 'stencil #f)
                        (ly:grob-translate-axis! x (+ (- (ly:grob-property x 'Y-offset)) (ly:grob-property (first noteheads) 'Y-offset)) Y)
                        (if (not (equal? (ly:grob-object x 'accidental-grob) '()))
                            (ly:grob-set-property! (ly:grob-object x 'accidental-grob) 'stencil #f)
                        ))
                    (if (not (= 0 (ly:grob-relative-coordinate x grob 0)))
                            (ly:grob-translate-axis! x (- (ly:grob-relative-coordinate x grob 0)) X))
                )
            ) noteheads)
    (ly:grob-set-property! (first noteheads) 'stencil new-stencil)
    grob
    )
)


cluster = {
    \once\override NoteColumn.before-line-breaking = #draw-cluster
}

sciarrino_flute_trill_on = {
    \override TrillSpanner.bound-details.left.text = \markup {\raise #1 \override #'(baseline-skip . 0.5) \left-column \small {"D" \concat {"D" \fontsize #-3 \raise #1 \sharp}}}
    \override TrillSpanner.bound-details.left.padding = #-1
    \override TrillSpanner.bound-details.right.padding = #-1
}

sciarrino_flute_trill_off = {
    \undo \sciarrino_flute_trill_on
}

\layout  {
    \context {\Score
        %default beam and stem look
        \override Beam.breakable = ##t
        \override Beam.length-fraction = 1.7
        \override Beam.beam-thickness = 0.8
%         \override Stem.stemlet-length = 1.5
        \override Flag.stencil = #flat-flag
%         \override Stem.length-fraction = #2

        %tuplets
        \override TupletNumber.whiteout = ##t
%         \override TupletNumber.font-size = #-2
%         \override TupletNumber.font-name = #"Contax"
%         \override TupletNumber.text = #tuplet-number::calc-fraction-text
%         \override TupletBracket.full-length-padding = #0
        \override TupletBracket.bracket-visibility = ##t
        \override TupletBracket.breakable = ##t
        tupletFullLength = ##t
        tupletFullLengthNote = ##f

        %metronome mark
        \override MetronomeMark.flag-style = #'flat-flag
        \override MetronomeMark.font-name = "Optima"
        \override MetronomeMark.stencil = #(make-stencil-boxer 0.1 0.75 ly:text-interface::print)
    }
    \context {
        \TabStaff
        \override Beam.length-fraction = 1
        \override Beam.beam-thickness = 0.5
    }
    \context {
        \Staff
            %beams
            subdivideBeams = ##f
            %stems
%             \override Stem.avoid-note-head = ##t
            %noteheads
%             \override NoteHead.stencil = #(ly:stencil-scale (make-circle-stencil 0.5 0.1 #f) 1.25 1)
%             \override NoteHead.stem-attachment = #'(0 . 1)
    }
}


% \paper {
%   ragged-right = ##f
% }

% #(set-global-staff-size 24)
% #(set-default-paper-size "a3" 'landscape)

