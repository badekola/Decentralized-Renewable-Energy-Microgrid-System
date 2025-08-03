# Decentralized Renewable Energy Microgrid System

A comprehensive blockchain-based system for managing community renewable energy resources, peer-to-peer trading, and microgrid resilience.

## System Overview

This system consists of five interconnected smart contracts that enable a fully decentralized renewable energy microgrid:

### 1. Energy Generation Tracking Contract (`energy-generation.clar`)
- Monitors electricity production from rooftop solar panels and small wind turbines
- Tracks generation capacity, actual output, and efficiency metrics
- Maintains historical production data for analytics
- Validates and records energy generation certificates

### 2. Peer-to-Peer Energy Trading Contract (`p2p-energy-trading.clar`)
- Enables direct energy trading between community members
- Manages buy/sell orders with dynamic pricing
- Handles energy credits and settlement
- Tracks trading history and reputation scores

### 3. Smart Appliance Load Balancing Contract (`load-balancing.clar`)
- Optimizes energy consumption based on renewable availability
- Manages appliance scheduling and priority systems
- Coordinates demand response programs
- Tracks energy usage patterns and efficiency

### 4. Battery Storage Coordination Contract (`battery-storage.clar`)
- Manages community battery storage systems
- Coordinates charging/discharging cycles
- Optimizes storage allocation across the microgrid
- Tracks battery health and performance metrics

### 5. Microgrid Resilience Management Contract (`resilience-management.clar`)
- Ensures power supply continuity during outages
- Manages emergency power distribution protocols
- Coordinates disaster response and recovery
- Maintains critical infrastructure priority lists

## Key Features

- **Decentralized Governance**: Community-driven decision making
- **Real-time Monitoring**: Live tracking of energy flows and storage
- **Automated Trading**: Smart contract-based energy marketplace
- **Grid Resilience**: Automatic failover and emergency protocols
- **Incentive Alignment**: Rewards for renewable generation and grid stability

## Technical Architecture

### Data Structures
- Energy generation records with timestamps and validation
- Trading orders with pricing and settlement mechanisms
- Appliance schedules with priority and flexibility parameters
- Battery status with capacity, health, and availability metrics
- Emergency protocols with activation triggers and response procedures

### Security Features
- Multi-signature requirements for critical operations
- Rate limiting to prevent system abuse
- Validation checks for all energy measurements
- Emergency pause mechanisms for system protection

## Getting Started

### Prerequisites
- Clarinet CLI installed
- Node.js and npm for testing
- Basic understanding of Clarity smart contracts

### Installation
\`\`\`bash
git clone <repository-url>
cd renewable-energy-microgrid
npm install
clarinet check
\`\`\`

### Testing
\`\`\`bash
npm test
\`\`\`

### Deployment
\`\`\`bash
clarinet deploy
\`\`\`

## Contract Interactions

### Energy Generation
- Register new generation sources
- Record daily production data
- Claim generation certificates
- View historical performance

### Energy Trading
- Create buy/sell orders
- Execute trades automatically
- Track energy credits
- View market prices

### Load Management
- Schedule appliance operations
- Set consumption priorities
- Participate in demand response
- Monitor usage efficiency

### Storage Management
- Contribute battery capacity
- Schedule charging cycles
- Earn storage rewards
- Monitor system health

### Resilience Operations
- Register critical loads
- Activate emergency protocols
- Coordinate disaster response
- Maintain backup systems

## Economic Model

The system uses a token-based economy where:
- Energy producers earn tokens for generation
- Consumers pay tokens for energy consumption
- Storage providers earn rewards for grid services
- Emergency responders receive incentives for participation

## Governance

Community governance enables:
- Parameter adjustments (pricing, limits, etc.)
- Protocol upgrades and improvements
- Dispute resolution mechanisms
- Emergency response coordination

## Future Enhancements

- Integration with IoT devices for automated data collection
- Machine learning for demand prediction and optimization
- Cross-microgrid trading capabilities
- Carbon credit tracking and trading
- Advanced weather integration for generation forecasting

## Contributing

Please read our contributing guidelines and submit pull requests for any improvements.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
