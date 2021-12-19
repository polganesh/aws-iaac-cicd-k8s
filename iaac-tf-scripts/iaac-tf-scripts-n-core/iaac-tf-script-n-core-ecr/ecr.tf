
data "aws_kms_key" "n-core-kms" {
  key_id = "arn:aws:kms:eu-central-1:373612170290:key/593d6491-add5-4c62-a6ed-ddbd715dcb61"
}

resource "aws_ecr_repository" "tnet-ecr" {
  name = "ecr-euc1-n-tnet-001"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true #Image Scanning for Amazon ECR is available at no additional charge,
  }
  # Every image you push to ECR is already encrypted by default using an industry-standard AES-256 encryption algorithm.
  #This often meets your security requirements as it protects data at rest. However, your needs may change if you get
  #new customers that require a different set of standards or the type of content you store in your images changes.
  #Now with AWS KMS encryption, you can choose an AWS managed or your own managed KMS key to encrypt your images at rest.
  #This gives you the ability to support PCI-DSS compliance requirements for separate authentication of the storage
  #and cryptography, KMS-based control of your key material and allows you to audit when images are encrypted and
  #decrypted. When this feature is enabled, ECR automatically encrypts your images with a KMS key
  # when pushed and decrypts it when pulled.
  # it provide added security https://www.youtube.com/watch?v=Q-76zbnJ_7c
  encryption_configuration {
    encryption_type = "KMS"
    kms_key = data.aws_kms_key.n-core-kms
  }
}