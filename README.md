# Integration Test Suite (Liscio)

This directory houses the specs to test integrations accross Liscio front end.

# Getting Started

* Clone the repo to your local directory
* Run
  ```bash
    bundle install
  ```
* You will need to obtain the `MASTER_KEY` in order to push results to testrail. That will be available on request.
* If you have credentials, run the following command
  ```bash
    MASTER_KEY=<master key> rspec spec
  ```
