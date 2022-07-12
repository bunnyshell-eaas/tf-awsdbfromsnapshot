# Bunnyshell Terraform create RDS database from snapshot

This module will identify the latest snapshot and then spin a new RDS instance. It can be used on Bunnyshell EAAS in order to spin up ephemeral environments that have access to a new DB that is seeded from a snapshot.
