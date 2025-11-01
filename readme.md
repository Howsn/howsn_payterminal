# Payment Terminal Script

A FiveM payment terminal script that allows players to process payments both at fixed locations and using a portable payment terminal.

## Features

- Fixed payment terminals at configurable locations
- Portable payment terminal item
- Multiple payment methods (Cash/Bank)
- Animations and props during payment process
- Progress bar for payment processing
- Multi-language support (English and Norwegian)
- Job-specific terminals
- Customizable configurations

## Dependencies

- ox_lib
- ox_target
- ox_inventory
- qbx_core
- Renewed-Banking

## Credits

This script uses the following free assets:
- Payment Terminal Prop by BzZz - [Original Package](https://bzzz.tebex.io/)
  - The prop is free to use under BzZz's terms
  - We use the prop unmodified as a supplementary element
  - End users can freely edit the prop files

## Installation

1. Place the `howsn_payterminal` folder in your resources directory
2. Add `ensure howsn_payterminal` to your server.cfg
3. Add the payment terminal item to your ox_inventory/data/items.lua:
```lua
['payment_terminal'] = {
    label = 'Payment Terminal',
    weight = 500,
    stack = false,
    close = true,
    description = 'Portable payment terminal for accepting payments'
},
```
4. Configure the `config.lua` to your needs
5. Restart your server

## Configuration

### Language
Set your preferred language in `config.lua`:
```lua
language = 'en', -- Available: 'nb-NO', 'en'
```

### Terminal Locations
Add fixed payment terminals in `config.lua`:
```lua
targets = {
    {
        coords = vec3(x, y, z),
        label = 'Payment Terminal',
        icon = 'fas fa-cash-register',
        groups = "jobname"
    }
}
```

## Usage

### Fixed Terminals
1. Approach a payment terminal
2. Target the terminal using ox_target
3. Select customer, payment method, and amount
4. Wait for customer approval

### Portable Terminal
1. Use the payment terminal item from inventory
2. Select customer, payment method, and amount
3. Wait for customer approval

## Contributing

- Created by Howsn
- Contributing developers welcome!

## License

This project is licensed under the MIT License - see the LICENSE file for details. 
The payment terminal prop is subject to BzZz's free asset terms.