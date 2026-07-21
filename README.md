# Developed as an internal automation tool to streamline customer software upgrades and automate the recovery of open business data into newly created intermediate databases.


A Tcl-based automation tool developed to restore open business data into newly created intermediate databases after software upgrades.

Overview

During software upgrades at customer sites, the existing intermediate database was recreated as part of the installation process. As a result, all pending business records stored in that database were removed.

Although the intermediate database was recreated, the open business data was still available through the company's internal Web Service. Before this tool was developed, these records had to be restored manually, which was time-consuming and prone to human error.

This project automates the entire recovery process by retrieving open records from the Web Service, generating deterministic keys, transforming the data, and inserting it into the appropriate intermediate database.

The tool was developed internally for use within the company to simplify customer software upgrades and reduce manual effort.

Problem Statement
Before

Software Upgrade
        │
        ▼
Intermediate Database Recreated
        │
        ▼
Open business data no longer exists
        │
        ▼
Employee manually restores records
        │
        ▼
Long processing time
High risk of mistakes
After
Software Upgrade
        │
        ▼
Run Open Data Migration Tool
        │
        ▼
Retrieve open records
        │
        ▼
Generate unique keys
        │
        ▼
Insert records automatically
        │
        ▼
Intermediate database is restored
Features
Automatic retrieval of open business records from the internal Web Service
Automatic migration into newly created intermediate databases
Support for multiple business data models
Mandant-specific database processing
Deterministic composite key generation
Hash-based unique identifiers
Centralized logging
Structured error handling
Configurable processing
Reduced migration time and manual work
Supported Data Models

The tool supports multiple business object types.

Examples include:

Goods Receipt
Order Confirmation

Each data model defines its own strategy for generating a unique composite key.

For example:

Goods Receipt
Document Number
+
Position Number
Order Confirmation
Document Number
+
Position Number
+
Confirmation Type

Some business objects require additional information inside the key to guarantee uniqueness.

The generated composite key is then hashed before being stored in the destination database.

Processing Workflow
Read configuration
        │
        ▼
Process Mandant
        │
        ▼
Request open records from Web Service
        │
        ▼
Determine data model
        │
        ▼
Generate composite key
        │
        ▼
Hash the key
        │
        ▼
Transform source data
        │
        ▼
Insert into Mandant database
        │
        ▼
Write processing result to log
Architecture
                Configuration
                      │
                      ▼
              Main Tcl Application
                      │
      ┌───────────────┼────────────────┐
      │               │                │
      ▼               ▼                ▼
 Web Service      Data Parser      Logger
      │
      ▼
Key Generator
      │
      ▼
Hash Generator
      │
      ▼
Database Writer
Key Generation

One of the most important parts of the project is deterministic key generation.

Each business object is converted into a composite key based on its identifying fields.

The composite key is then hashed before insertion into the database.

This approach guarantees that identical business objects always generate the same identifier while different business objects produce different keys.

Some business models require additional fields inside the key.

For example, Order Confirmation records include the confirmation type because multiple confirmations may exist for the same document and position.

Mandant Processing

Each Mandant is responsible for a specific business data model.

The tool processes every Mandant independently and writes the transformed records into the intermediate database assigned to that Mandant.

This design keeps the processing isolated and prevents data from being inserted into the wrong database.

Error Handling

The project follows a centralized error handling strategy.

Errors occurring while processing one Mandant do not stop the processing of the remaining Mandants.
Lower-level procedures report errors to higher layers instead of handling them unnecessarily.
Processing errors are logged together with contextual information.
Fatal application errors are handled at the application's entry point.

This design keeps the migration process robust while maximizing the number of successfully restored records.

Logging

The application produces detailed processing logs.

Typical log entries include:

Start and end of execution
Processed Mandant
Current business object
Number of retrieved records
Number of inserted records
Processing errors
Unexpected failures

The centralized logging mechanism simplifies troubleshooting and post-migration verification.

Configuration

Application behavior is configured through a dedicated configuration file.

Typical configuration values include:

Web Service endpoint
Database connection information
Mandant definitions
Logging location
Processing options
Runtime Environment

The tool runs entirely inside the company's internal infrastructure.

It does not implement application-level authentication because the execution environment is already authorized to communicate with the internal Web Service.

Project Structure
project/
│
├── main.tcl
├── config/
├── database/
├── parser/
├── hashing/
├── logging/
├── webservice/
├── migration/
└── utils/

Folder names may differ depending on the project version.

Benefits

Compared to the previous manual workflow, the tool provides:

Faster customer upgrades
Elimination of repetitive manual work
Consistent key generation
Reliable restoration of open business data
Lower risk of human error
Easier maintenance through modular components
Technologies
Tcl
Internal Company Web Service
SQL Database
Hash-based key generation
Configuration-driven processing
Future Improvements

Possible future enhancements include:

Parallel processing for multiple Mandants
Migration reports
Progress monitoring
Performance metrics
Automatic retry for temporary Web Service failures
Additional business object support
