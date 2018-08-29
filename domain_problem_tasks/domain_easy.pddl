(define (domain youbot-domain)
  (:requirements :non-deterministic :strips :equality :typing)
  (:types ws object)
  (:predicates (detected ?o - object) (holding ?o - object) (emptyhand) (on-ws ?o - object ?w - ws) (have-human ?o - object) (r-at ?w - ws) (h-at ?w - ws))

  (:action move
    :parameters (?w1 ?w2 - ws)
    :precondition (and (r-at ?w1) (not (r-at ?w2)))
    :effect (and (r-at ?w2) (not(r-at ?w1)))
  )

  (:action detect
    :parameters (?w - ws ?o - object)
    :precondition (and (emptyhand) (r-at ?w) (on-ws ?o ?w))
    :effect 
      (oneof 
	      (and (detected ?o))
        (and (not(detected ?o)))
      )
  )

  (:action pick
    :parameters (?w - ws ?o - object)
    :precondition (and (emptyhand) (detected ?o) (r-at ?w) (on-ws ?o ?w))
    :effect
      (oneof 
	      (and (not (holding ?o)) (emptyhand) (on-ws ?o ?w) (not(detected ?o)))
        (and (holding ?o) (not (emptyhand)) (not (on-ws ?o ?w)))
      )
  )

  (:action drop
    :parameters (?w - ws ?o - object)
    :precondition (and (not(emptyhand)) (holding ?o) (r-at ?w))
    :effect (and (on-ws ?o ?w) (emptyhand) (not (holding ?o)))
  )

  (:action pick-from-human
    :parameters (?w - ws ?o - object)
    :precondition (and (emptyhand) (r-at ?w) (h-at ?w) (have-human ?o))
    :effect 
      (oneof
        (and (holding ?o) (not (emptyhand)) (not (have-human ?o)))
        (and (not(holding ?o)) (emptyhand) (have-human ?o))
      )
  )
  
  (:action give-to-human
    :parameters (?w - ws ?o - object)
    :precondition (and (not(emptyhand)) (holding ?o) (r-at ?w) (h-at ?w))
    :effect (and (have-human ?o) (emptyhand) (not (holding ?o)))
  )
)
