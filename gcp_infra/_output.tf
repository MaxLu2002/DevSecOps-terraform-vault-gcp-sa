locals {
  project_id = var.project_id
}

output "infra" {
  value = {
    gcloud_login_command = <<-EOT

    # 1. 先登入Gcloud要用的帳號
        gcloud auth login # 要輸入帳號密碼登入IAM帳號 
        gcloud config set project ${var.project_id}

    # 2.1. 如果secret type = access_token 要用無金鑰方法登入 (推薦：安全性高)
        gcloud compute ssh ${module.gce-bastion.output.name} --zone=${module.gce-bastion.output.zone} --quiet   

    # 2.2. 如果secret type = service_account_key 要用金鑰方法登入 (次要推薦：還是會需要金鑰)
        $VAULT_RESPONSE = vault read -format=json gcp/roleset/${var.sa_name}/key | ConvertFrom-Json
        $BASE64_KEY = $VAULT_RESPONSE.data.private_key_data
        $DECODED_KEY = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($BASE64_KEY))
        $DECODED_KEY | Out-File -FilePath "../keys/vault-temp-key.json" -Encoding ascii
        gcloud auth activate-service-account --key-file="../keys/vault-temp-key.json"
        gcloud compute ssh ${module.gce-bastion.output.name} --zone=${module.gce-bastion.output.zone} --quiet   
        
      # 啟用與關閉OS Login
        gcloud compute project-info add-metadata --metadata enable-oslogin=TRUE #FALSE
    EOT
  }
}