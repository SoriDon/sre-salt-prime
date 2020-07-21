include:
  - infra.aws
  - infra.ec2_instance_web
  - infra.rds
  - infra.us-east-2
  - infra.us-east-2.core


infra:
  github:
    ssh_key:
      comment: cc-sre-salt-formulas-bot_rsa_github_20190123
  provisioning:
    ssh_key:
      aws_name: saltstack-rsa-provisioning-20181221_core_ec2key
      comment: saltstack_rsa_provisioning_20181221
      pub: |
        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCoaEwPTYnUgMBUJkWyX9Fe3aEgpQljlLPgaJTuxGGtPXIQdVaycoyXpU/CiSC3tVmuc/oxw5PGMfQQ739WiLc2gAqgM1itjO5YaV0FC+kaOrSUtY/rMCREuWC/gPWtfcOVQAoySXS7LA3fvcyWLnHTIiHqfH6BpoZdZjZnG/z+mKH0S11fvJAwz6ymJVKEnNaMa6J4gT1vEqmMtDK8NUIwVlaAT32H7+t0wQRKO16LrshFOvrrmaJZfUA1uE6+AjQ5liQbG36SK4Lvzc/5cwrGrztYBdxwbP3HNmrQvtoHt8dQtTb5+PWQNHDb1rCst9AA6j2/AFvkig22QFUzgr4mBQWpLtBttd1u1MHZFaEuRbXWPDG/q/UeKHa7AjP6c+cU40iezQwXscVtx4tJ3LjwQkhtSVybjtFNBSt4zXRfpU0jOm8cHUj0Gl5RjRWy/3YlfI1ahUWmdMqZ++qPz4we/nDT8mxv2dyf7e8TxEpkrTmTMuW/Fl4Dvwy97KsLme/80Mg3FYRGoIvZ7/dnjeY18hoRTnutBXkcrl6+QmjX7sTru3HjAB94KKUEKvLTr7mf4KRBltW/566CRzOHk/FblAdcAZbiPh+OZumEL4UyYixoXwdS65p6F0Hk2sfm/pPLdbVHvkgBVJqXSX1BYxB58TQzWU+7j4889kqFZ5/JFw== saltstack_rsa_provisioning_20181221
