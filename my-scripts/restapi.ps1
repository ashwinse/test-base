<#
$subscription_id = "086ef973-2199-477b-9b40-c3d05c01a287"
$tenant_id = "dcf9e4d3-f44a-4c28-be12-8245c0d35668"
$bodyLogin = @{
        "grant_type" = "client_credentials"
        "client_secret" = "6c2dc7WiIEXbaBHFj8JSIJ3R2V3FJrtxe2KQrZRqZuI="
        "client_id" = "8dd7d328-2bdb-4389-9085-5733171b54a0"
        "resource" = "https://management.azure.com/"
}

$msUri = "https://login.microsoftonline.com/$tenant_id/oauth2/token"
$response = Invoke-RestMethod -Uri $msUri -Method Post -Headers @{"accept"="application/json"} -Body $bodyLogin

Write-Output $response.access_token

#>

#==================================================================================================================

$date = Get-Date

$dateRfc =  $date.GetDateTimeFormats()[103]

Write-Output $dateRfc
$header = @{
    "accept"="application/json"
    "x-ms-version" = "2015-04-08"
    #"Authorization" = "type=master&ver=1.0&sig=STDGcxhS64Pa05LfMhIdazc3Hok89RvPWowB1oy0nzGR12vJ481VG74whTd1mw7AYVF1XxmYRfE4bUyjF37kwQ=="
    "Authorization" = "type%3Dmaster%26ver%3D1.0%26sig%3Dszu7yuINDzB1Yo0BPynpK8hA7HhAMXKsmSpKV340%2BT0%3D"
    "Content-Type" = "application/json"
    "x-ms-date" = "$dateRfc"
}

$uri = "https://docdb6ekuo.documents.azure.com/dbs"

$res = Invoke-RestMethod -Uri $uri -Method Get -Headers $header 

Write-Output $res | ConvertTo-Json