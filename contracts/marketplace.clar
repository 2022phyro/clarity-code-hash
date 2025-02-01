;; CodeHash Marketplace Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u100))
(define-constant err-template-exists (err u101))
(define-constant err-invalid-price (err u102))

;; Data structures
(define-map templates
  { template-id: uint }
  {
    creator: principal,
    price: uint,
    metadata-url: (string-utf8 256),
    is-active: bool
  }
)

;; Template listing
(define-public (list-template (template-id uint) (price uint) (metadata-url (string-utf8 256)))
  (let
    ((template-exists (contract-call? .template get-owner template-id)))
    (asserts! (is-eq (some tx-sender) template-exists) err-not-owner)
    (ok (map-set templates
      { template-id: template-id }
      {
        creator: tx-sender,
        price: price,
        metadata-url: metadata-url,
        is-active: true
      }
    ))
  )
)

;; Purchase template
(define-public (purchase-template (template-id uint))
  (let
    ((template (unwrap! (map-get? templates { template-id: template-id }) (err u103)))
     (price (get price template)))
    (try! (stx-transfer? price tx-sender (get creator template)))
    (try! (contract-call? .template transfer template-id (get creator template) tx-sender))
    (ok true)
  )
)
