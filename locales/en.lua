return {
    notifications = {
        payment_request_sent = "You have sent a payment request",
        payment_cancelled = "Customer cancelled the payment",
        payment_cancelled_by_user = "You cancelled the payment",
        payment_successful = "Customer has paid!",
        payment_failed = "Customer has insufficient funds",
        insufficient_funds = "You have insufficient funds"
    },
    terminal = {
        header = "Payment Terminal",
        payment_type = {
            cash = "Cash",
            bank = "Bank"
        },
        dialog = {
            player_id = {
                label = "Player ID",
                description = "ID of the player who should pay"
            },
            payment_type = {
                label = "Payment Type",
                description = "Choose payment method"
            },
            amount = {
                label = "Amount",
                description = "Enter amount"
            }
        },
        request = {
            header = "Payment Request",
            content = "You received a payment request!\nPayment type: %s\nAmount: %d,-",
            confirm = "Pay",
            cancel = "Cancel"
        },
        progress = {
            processing = "Processing payment...",
            waiting = "Waiting for approval..."
        }
    }
}