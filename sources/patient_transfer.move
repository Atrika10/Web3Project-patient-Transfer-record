module patient_transfer::records {
    use std::string::{String};
    use std::signer;
    use aptos_framework::timestamp;
    use aptos_framework::account;
    use aptos_std::table::{Self, Table};

    // Error codes
    const ENO_PERMISSIONS: u64 = 1;
    const EPATIENT_NOT_FOUND: u64 = 2;
    const EINVALID_HOSPITAL: u64 = 3;

    struct PatientTransfer has key {
        transfers: Table<u64, TransferRecord>,
        transfer_count: u64
    }

    struct TransferRecord has store, drop {
        patient_id: String,
        from_hospital: String,
        to_hospital: String,
        reason: String,
        timestamp: u64,
        status: u8, // 0: Pending, 1: Completed, 2: Cancelled
        medical_notes: String
    }

    struct HospitalConfig has key {
        registered_hospitals: Table<address, bool>
    }

    // Initialize the patient transfer system
    public entry fun initialize(account: &signer) {
        let account_addr = signer::address_of(account);
        
        // Initialize transfer records
        if (!exists<PatientTransfer>(account_addr)) {
            move_to(account, PatientTransfer {
                transfers: table::new(),
                transfer_count: 0
            });
        };

        // Initialize hospital config
        if (!exists<HospitalConfig>(account_addr)) {
            move_to(account, HospitalConfig {
                registered_hospitals: table::new()
            });
        };
    }

    // Register a hospital
    public entry fun register_hospital(
        admin: &signer,
        hospital_address: address
    ) acquires HospitalConfig {
        let admin_addr = signer::address_of(admin);
        let config = borrow_global_mut<HospitalConfig>(admin_addr);
        table::upsert(&mut config.registered_hospitals, hospital_address, true);
    }

    // Create a new transfer record
    public entry fun create_transfer(
        hospital: &signer,
        patient_id: String,
        from_hospital: String,
        to_hospital: String,
        reason: String,
        medical_notes: String
    ) acquires PatientTransfer, HospitalConfig {
        let hospital_addr = signer::address_of(hospital);
        
        // Verify hospital is registered
        let config = borrow_global<HospitalConfig>(@patient_transfer);
        assert!(table::contains(&config.registered_hospitals, hospital_addr), EINVALID_HOSPITAL);

        let transfers = borrow_global_mut<PatientTransfer>(@patient_transfer);
        let transfer_id = transfers.transfer_count + 1;

        let transfer = TransferRecord {
            patient_id,
            from_hospital,
            to_hospital,
            reason,
            timestamp: timestamp::now_microseconds(),
            status: 0, // Pending
            medical_notes
        };

        table::add(&mut transfers.transfers, transfer_id, transfer);
        transfers.transfer_count = transfer_id;
    }

    // Update transfer status
    public entry fun update_transfer_status(
        hospital: &signer,
        transfer_id: u64,
        new_status: u8
    ) acquires PatientTransfer, HospitalConfig {
        let hospital_addr = signer::address_of(hospital);
        
        // Verify hospital is registered
        let config = borrow_global<HospitalConfig>(@patient_transfer);
        assert!(table::contains(&config.registered_hospitals, hospital_addr), EINVALID_HOSPITAL);

        let transfers = borrow_global_mut<PatientTransfer>(@patient_transfer);
        assert!(table::contains(&transfers.transfers, transfer_id), EPATIENT_NOT_FOUND);

        let transfer = table::borrow_mut(&mut transfers.transfers, transfer_id);
        transfer.status = new_status;
    }

    // Get transfer record (view function)
    #[view]
    public fun get_transfer(transfer_id: u64): (String, String, String, String, u64, u8, String) acquires PatientTransfer {
        let transfers = borrow_global<PatientTransfer>(@patient_transfer);
        assert!(table::contains(&transfers.transfers, transfer_id), EPATIENT_NOT_FOUND);

        let transfer = table::borrow(&transfers.transfers, transfer_id);
        (
            transfer.patient_id,
            transfer.from_hospital,
            transfer.to_hospital,
            transfer.reason,
            transfer.timestamp,
            transfer.status,
            transfer.medical_notes
        )
    }
} 