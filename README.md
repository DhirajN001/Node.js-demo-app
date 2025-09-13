# AWS DevOps Demo — Quickstart

## Goal
Deploy a small React app using Terraform (S3 + CloudFront) and GitHub Actions for CI/CD.

## Prerequisites
- AWS account with programmatic IAM user (Access Key + Secret) with permissions: S3, CloudFront, IAM (if creating roles).
- GitHub repo with this code
- GitHub Secrets set: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `S3_BUCKET_NAME`, `CLOUDFRONT_DIST_ID` (optional)

## Steps — Terraform (create infra)
1. `cd iac`
2. `terraform init`
3. `terraform apply -auto-approve`
4. Note outputs: `website_bucket_name` and `cloudfront_domain`.

## Steps — GitHub Actions (deploy)
1. Push code to `main` branch.
2. Add GitHub Secrets (see above). Use the `website_bucket_name` output to set `S3_BUCKET_NAME`.
3. The workflow will build and sync `app/build` to S3 and invalidate CloudFront.

## Demo account (app-level)
- Email: `hire-me@anshumat.org`
- Password: `HireMe@2025!`

## Security notes
- Do NOT commit AWS secrets to the repo.
- Use least-privilege IAM user for the pipeline; consider creating a secure CI role and using OIDC.

## Architecture diagram
GitHub Actions → S3 → CloudFront → Users
