# Hospital Patient Transfer System on Aptos Blockchain

A decentralized application (dApp) built on the Aptos blockchain for managing and tracking patient transfers between hospitals. This system ensures transparent, secure, and immutable record-keeping of patient transfers while maintaining the privacy and integrity of medical data.

## Features

- **Secure Patient Transfer Records**: Track and manage patient transfers between hospitals
- **Hospital Authentication**: Only registered hospitals can create and update transfer records
- **Real-time Status Updates**: Monitor transfer status (Pending, Completed, Cancelled)
- **Medical Notes**: Secure storage of relevant medical information
- **Blockchain Security**: Immutable audit trail of all transfer records
- **User-friendly Interface**: React-based frontend for easy interaction

## Project Structure

```
aptos-patient-transfer/
├── sources/
│   └── patient_transfer.move    # Smart contract
├── frontend/                    # React frontend application
├── tests/                      # Move contract tests
└── Move.toml                   # Move package configuration
```

## Prerequisites

- [Aptos CLI](https://aptos.dev/cli-tools/aptos-cli-tool/install-aptos-cli)
- [Node.js](https://nodejs.org/) (v14 or higher)
- [NPM](https://www.npmjs.com/) (v6 or higher)
- [Petra Wallet](https://petra.app/) or any other Aptos-compatible wallet

## Setup Instructions

### Smart Contract Deployment

1. Install Aptos CLI
```bash
aptos init
```

2. Compile the Move contract
```bash
cd aptos-patient-transfer
aptos move compile
```

3. Deploy the contract
```bash
aptos move publish
```

### Frontend Setup

1. Install dependencies
```bash
cd frontend
npm install
```

2. Start the development server
```bash
npm start
```

The application will be available at `http://localhost:3000`

## Smart Contract Functions

### Initialize System
```move
public entry fun initialize(account: &signer)
```
Initializes the patient transfer system and hospital configuration.

### Register Hospital
```move
public entry fun register_hospital(admin: &signer, hospital_address: address)
```
Registers a new hospital in the system.

### Create Transfer
```move
public entry fun create_transfer(
    hospital: &signer,
    patient_id: String,
    from_hospital: String,
    to_hospital: String,
    reason: String,
    medical_notes: String
)
```
Creates a new patient transfer record.

### Update Transfer Status
```move
public entry fun update_transfer_status(
    hospital: &signer,
    transfer_id: u64,
    new_status: u8
)
```
Updates the status of an existing transfer record.

## Frontend Features

- Connect wallet functionality
- Dashboard for viewing transfer records
- Forms for creating new transfers
- Status update interface
- Hospital registration portal

## Security Considerations

- Only registered hospitals can create and update transfer records
- Patient data is stored securely on the blockchain
- All transactions are verified and immutable
- Hospital authentication is required for sensitive operations

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, please open an issue in the repository or contact the development team. 