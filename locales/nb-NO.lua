return {
    notifications = {
        payment_request_sent = "Du har sendt en betalingsforespørsel",
        payment_cancelled = "Kunden avbrøt betalingen",
        payment_cancelled_by_user = "Du har avbrutt betalingen",
        payment_successful = "Kunden har betalt!",
        payment_failed = "Kunden har ikke nok penger",
        insufficient_funds = "Du har ikke nok penger"
    },
    terminal = {
        header = "Betalingsterminal",
        payment_type = {
            cash = "Kontanter",
            bank = "Bank"
        },
        dialog = {
            player_id = {
                label = "Spiller ID",
                description = "ID til spilleren som skal betale"
            },
            payment_type = {
                label = "Betalingstype",
                description = "Velg betalingsmetode"
            },
            amount = {
                label = "Beløp",
                description = "Skriv inn beløp"
            }
        },
        request = {
            header = "Betalingsforespørsel",
            content = "Du har fått en betalingsforespørsel!\nBetalingstype: %s\nBeløp: %d,-",
            confirm = "Betal",
            cancel = "Avbryt"
        }
    },
    progress = {
        processing = "Behandler betaling...",
        waiting = "Venter på godkjenning..."
    }
}