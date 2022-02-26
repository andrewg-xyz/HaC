# ci-template

Helper to update cloud init templates. Currently, no solution has been found to 'convert to template'. Instead follow these steps:

1. update the template name `variable "clone_template"` in variables.tf
2. provision using terraform
3. manually perform updates and maintenance
4. manually convert to template
5. manually rename template on revan to be "ci-ubuntu-template-v*" (the terraform doesn't like the same template name)
6. manually delete the `terraform.tfstate` file to prevent conflicts in future operations

## TLDR

1. `source .env`
2. `tf init`
3. `tf plan`
4. `tf apply`

## CHANGELOG

ci-ubuntu-template-v1 : 26FEB2022
- update packages
- resolve dpkg file lock

ci-ubuntu-template (v0) : 
- Initial Configuration