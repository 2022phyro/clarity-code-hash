;; Reviews Contract

;; Data structures
(define-map reviews
  { template-id: uint, reviewer: principal }
  {
    rating: uint,
    comment: (string-utf8 500),
    timestamp: uint
  }
)

;; Add review
(define-public (add-review (template-id uint) (rating uint) (comment (string-utf8 500)))
  (begin
    (asserts! (and (>= rating u1) (<= rating u5)) (err u301))
    (ok (map-set reviews
      { template-id: template-id, reviewer: tx-sender }
      {
        rating: rating,
        comment: comment,
        timestamp: block-height
      }
    ))
  )
)

;; Get review
(define-read-only (get-review (template-id uint) (reviewer principal))
  (map-get? reviews { template-id: template-id, reviewer: reviewer })
)
