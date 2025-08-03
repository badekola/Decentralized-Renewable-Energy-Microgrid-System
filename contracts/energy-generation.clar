;; Energy Generation Tracking Contract
;; Monitors renewable energy production from solar panels and wind turbines

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INVALID-INPUT (err u101))
(define-constant ERR-GENERATOR-EXISTS (err u102))
(define-constant ERR-GENERATOR-NOT-FOUND (err u103))
(define-constant ERR-INVALID-PRODUCTION (err u104))

;; Data Variables
(define-data-var total-generators uint u0)
(define-data-var total-production uint u0)

;; Data Maps
(define-map generators
  { generator-id: uint }
  {
    owner: principal,
    generator-type: (string-ascii 20),
    capacity: uint,
    location: (string-ascii 50),
    installation-date: uint,
    status: (string-ascii 10),
    total-generated: uint
  }
)

(define-map daily-production
  { generator-id: uint, date: uint }
  {
    production: uint,
    efficiency: uint,
    weather-factor: uint,
    validated: bool
  }
)

(define-map generator-certificates
  { generator-id: uint, certificate-id: uint }
  {
    production-amount: uint,
    issue-date: uint,
    valid-until: uint,
    claimed: bool
  }
)

;; Public Functions

;; Register a new energy generator
(define-public (register-generator (generator-type (string-ascii 20)) (capacity uint) (location (string-ascii 50)))
  (let ((generator-id (+ (var-get total-generators) u1)))
    (asserts! (> capacity u0) ERR-INVALID-INPUT)
    (asserts! (is-none (map-get? generators { generator-id: generator-id })) ERR-GENERATOR-EXISTS)

    (map-set generators
      { generator-id: generator-id }
      {
        owner: tx-sender,
        generator-type: generator-type,
        capacity: capacity,
        location: location,
        installation-date: block-height,
        status: "active",
        total-generated: u0
      }
    )

    (var-set total-generators generator-id)
    (ok generator-id)
  )
)

;; Record daily energy production
(define-public (record-production (generator-id uint) (production uint) (efficiency uint) (weather-factor uint))
  (let ((generator (unwrap! (map-get? generators { generator-id: generator-id }) ERR-GENERATOR-NOT-FOUND))
        (today (/ block-height u144))) ;; Approximate daily blocks

    (asserts! (is-eq (get owner generator) tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (> production u0) ERR-INVALID-INPUT)
    (asserts! (<= efficiency u100) ERR-INVALID-INPUT)
    (asserts! (<= production (get capacity generator)) ERR-INVALID-PRODUCTION)

    (map-set daily-production
      { generator-id: generator-id, date: today }
      {
        production: production,
        efficiency: efficiency,
        weather-factor: weather-factor,
        validated: false
      }
    )

    ;; Update total production
    (map-set generators
      { generator-id: generator-id }
      (merge generator { total-generated: (+ (get total-generated generator) production) })
    )

    (var-set total-production (+ (var-get total-production) production))
    (ok true)
  )
)

;; Validate production record
(define-public (validate-production (generator-id uint) (date uint))
  (let ((production-record (unwrap! (map-get? daily-production { generator-id: generator-id, date: date }) ERR-GENERATOR-NOT-FOUND)))

    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)

    (map-set daily-production
      { generator-id: generator-id, date: date }
      (merge production-record { validated: true })
    )

    (ok true)
  )
)

;; Issue generation certificate
(define-public (issue-certificate (generator-id uint) (certificate-id uint) (production-amount uint) (valid-days uint))
  (let ((generator (unwrap! (map-get? generators { generator-id: generator-id }) ERR-GENERATOR-NOT-FOUND)))

    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (asserts! (> production-amount u0) ERR-INVALID-INPUT)

    (map-set generator-certificates
      { generator-id: generator-id, certificate-id: certificate-id }
      {
        production-amount: production-amount,
        issue-date: block-height,
        valid-until: (+ block-height (* valid-days u144)),
        claimed: false
      }
    )

    (ok true)
  )
)

;; Claim generation certificate
(define-public (claim-certificate (generator-id uint) (certificate-id uint))
  (let ((generator (unwrap! (map-get? generators { generator-id: generator-id }) ERR-GENERATOR-NOT-FOUND))
        (certificate (unwrap! (map-get? generator-certificates { generator-id: generator-id, certificate-id: certificate-id }) ERR-GENERATOR-NOT-FOUND)))

    (asserts! (is-eq (get owner generator) tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (not (get claimed certificate)) ERR-INVALID-INPUT)
    (asserts! (< block-height (get valid-until certificate)) ERR-INVALID-INPUT)

    (map-set generator-certificates
      { generator-id: generator-id, certificate-id: certificate-id }
      (merge certificate { claimed: true })
    )

    (ok (get production-amount certificate))
  )
)

;; Read-only Functions

;; Get generator information
(define-read-only (get-generator (generator-id uint))
  (map-get? generators { generator-id: generator-id })
)

;; Get daily production
(define-read-only (get-daily-production (generator-id uint) (date uint))
  (map-get? daily-production { generator-id: generator-id, date: date })
)

;; Get certificate information
(define-read-only (get-certificate (generator-id uint) (certificate-id uint))
  (map-get? generator-certificates { generator-id: generator-id, certificate-id: certificate-id })
)

;; Get total system statistics
(define-read-only (get-system-stats)
  {
    total-generators: (var-get total-generators),
    total-production: (var-get total-production)
  }
)

;; Get generator production history
(define-read-only (get-generator-efficiency (generator-id uint))
  (let ((generator (map-get? generators { generator-id: generator-id })))
    (match generator
      gen (some {
        capacity: (get capacity gen),
        total-generated: (get total-generated gen),
        efficiency-ratio: (if (> (get capacity gen) u0)
                            (/ (* (get total-generated gen) u100) (get capacity gen))
                            u0)
      })
      none
    )
  )
)
