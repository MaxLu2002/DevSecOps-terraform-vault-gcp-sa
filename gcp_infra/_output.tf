locals {
  project_id = jsondecode(file("../keys/root_sa.json")).project_id
}

output "infra" {
  value = {
    gcloud_login_command = <<-EOT

    # 先登入Gcloud要用的帳號
      gcloud auth login # 要輸入帳號密碼登入IAM帳號 
      gcloud config set project ${local.project_id}

    # 啟用與關閉OS Login
      gcloud compute project-info add-metadata --metadata enable-oslogin=TRUE #FALSE

    # 1. 用ROOT登入
      gcloud auth activate-service-account --key-file="../keys/root_sa.json"
      gcloud compute ssh ${module.gce.output.name} --zone=${module.gce.output.zone} --quiet    

    # 2. 如果secret type = access_token 要用無金鑰方法登入
      gcloud compute ssh ${module.gce.output.name} --zone=${module.gce.output.zone} --quiet   

    # 3. 如果secret type = service_account_key 要用金鑰方法登入
      $VAULT_RESPONSE = vault read -format=json gcp/roleset/${var.sa_name}/key | ConvertFrom-Json
      $BASE64_KEY = $VAULT_RESPONSE.data.private_key_data
      $DECODED_KEY = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($BASE64_KEY))
      $DECODED_KEY | Out-File -FilePath "../keys/vault-temp-key.json" -Encoding ascii
      gcloud auth activate-service-account --key-file="../keys/vault-temp-key.json"
      gcloud compute ssh ${module.gce.output.name} --zone=${module.gce.output.zone} --quiet   
      
      Remove-Item "../keys/vault-temp-key.json" #也可以不用刪除，過了TTL時間金鑰匙一樣會過期
    EOT
  }
}