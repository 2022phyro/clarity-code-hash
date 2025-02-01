;; Template NFT Contract

;; Define NFT
(define-non-fungible-token template uint)

;; Data vars
(define-data-var last-id uint u0)

;; Mint new template
(define-public (mint (metadata-url (string-utf8 256)))
  (let
    ((template-id (+ (var-get last-id) u1)))
    (try! (nft-mint? template template-id tx-sender))
    (var-set last-id template-id)
    (ok template-id)
  )
)

;; Transfer template
(define-public (transfer (template-id uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) (err u401))
    (nft-transfer? template template-id sender recipient)
  )
)

;; Get template owner
(define-read-only (get-owner (template-id uint))
  (nft-get-owner? template template-id)
)
