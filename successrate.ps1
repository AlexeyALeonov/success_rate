param(
    $Path
)

if (-not $Path) {
    $log = cmd.exe /c "docker logs storagenode 2>&1"
} else {
    $log = Get-Content $Path
}

Write-Host "========== AUDIT ============="  -ForegroundColor Cyan

$auditsSuccess = ($log | Select-String GET_AUDIT | Select-String downloaded).Count

$auditsFailed = ($log | Select-String GET_AUDIT | Select-String failed | Select-String open -NotMatch).Count

$auditsFailedCritical = ($log | Select-String GET_AUDIT | Select-String failed | Select-String open).Count

if (($auditsSuccess + $auditsFailed + $auditsFailedCritical) -ge 1) {
    $audits_failed_ratio = $auditsFailed / ($auditsSuccess + $auditsFailed + $auditsFailedCritical) * 100
    $audits_critical_ratio = $auditsFailedCritical / ($auditsSuccess + $auditsFailed + $auditsFailedCritical) * 100
    $audits_success_ratio = $auditsSuccess / ($auditsSuccess + $auditsFailed + $auditsFailedCritical) * 100
} else {
    $audits_failed_ratio = 0.00
    $audits_critical_ratio = 0.00
    $audits_success_ratio = 0.00
}

Write-Host ("Critically failed:`t" + $auditsFailedCritical) -ForegroundColor Red
Write-Host ("Critical Fail Rate:`t{0:N}%" -f $audits_critical_ratio)
Write-Host ("Recoverable failed:`t" + $auditsFailed) -ForegroundColor DarkYellow
Write-Host ("Recoverable Fail Rate:`t{0:N}%" -f $audits_failed_ratio)
Write-Host ("Successful:`t`t" + $auditsSuccess) -ForegroundColor Green
Write-Host ("Success Rate:`t`t{0:N}%" -f $audits_success_ratio)

Write-Host "========== DOWNLOAD =========="  -ForegroundColor Cyan

$dl_success = ($log | Select-String '"GET"' | Select-String downloaded).Count

$dl_canceled = ($log | Select-String '"GET"' | Select-String canceled).Count

$dl_failed = ($log | Select-String '"GET"' | Select-String failed).Count

if (($dl_success + $dl_failed + $dl_canceled) -ge 1) {
    $dl_failed_ratio = $dl_failed / ($dl_success + $dl_failed + $dl_canceled) * 100
    $dl_canceled_ratio = $dl_canceled / ($dl_success + $dl_failed + $dl_canceled) * 100
    $dl_ratio = $dl_success / ($dl_success + $dl_failed + $dl_canceled) * 100
} else {
    $dl_failed_ratio = 0.00
    $dl_canceled_ratio = 0.00
    $dl_ratio = 0.00
}

Write-Host ("Failed:`t`t`t" + $dl_failed) -ForegroundColor Red
Write-Host ("Fail Rate:`t`t{0:N}%" -f $dl_failed_ratio)
Write-Host ("Canceled:`t`t" + $dl_canceled) -ForegroundColor DarkYellow
Write-Host ("Cancel Rate:`t`t{0:N}%" -f $dl_canceled_ratio)
Write-Host ("Successful:`t`t" + $dl_success) -ForegroundColor Green
Write-Host ("Success Rate:`t`t{0:N}%" -f $dl_ratio)

Write-Host "========== UPLOAD ============"  -ForegroundColor Cyan

$put_success = ($log | Select-String '"PUT"' | Select-String uploaded).Count

$put_rejected = ($log | Select-String '"PUT"' | Select-String rejected).Count

$put_canceled = ($log | Select-String '"PUT"' | Select-String canceled).Count

$put_failed = ($log | Select-String '"PUT"' | Select-String failed).Count

if (($put_success + $put_rejected + $put_failed + $put_canceled) -ge 1) {
    $put_failed_ratio = $put_failed / ($put_success + $put_rejected + $put_failed + $put_canceled) * 100
    $put_canceled_ratio = $put_canceled / ($put_success + $put_rejected + $put_failed + $put_canceled) * 100
    $put_accept_ratio = ($put_success + $put_canceled + $put_failed) / ($put_success + $put_rejected + $put_failed + $put_canceled) * 100
    $put_ratio = $put_success / ($put_success + $put_rejected + $put_failed + $put_canceled) * 100
} else {
    $put_failed_ratio = 0.00
    $put_canceled_ratio = 0.00
    $put_accept_ratio = 0.00
    $put_ratio = 0.00
}

Write-Host ("Rejected:`t`t" + $put_rejected)
Write-Host ("Acceptance Rate:`t{0:N}%" -f $put_accept_ratio)
"---------- accepted ----------"
Write-Host ("Failed:`t`t`t" + $put_failed) -ForegroundColor Red
Write-Host ("Fail Rate:`t`t{0:N}%" -f $put_failed_ratio)
Write-Host ("Canceled:`t`t" + $put_canceled) -ForegroundColor DarkYellow
Write-Host ("Cancel Rate:`t`t{0:N}%" -f $put_canceled_ratio)
Write-Host ("Successful:`t`t" + $put_success) -ForegroundColor Green
Write-Host ("Success Rate:`t`t{0:N}%" -f $put_ratio)

Write-Host "========== REPAIR DOWNLOAD ==="  -ForegroundColor Cyan

$get_repair_success = ($log | Select-String GET_REPAIR | Select-String downloaded).Count

$get_repair_canceled = ($log | Select-String GET_REPAIR | Select-String canceled).Count

$get_repair_failed = ($log | Select-String GET_REPAIR | Select-String failed).Count

if (($get_repair_success + $get_repair_failed + $get_repair_canceled) -ge 1) {
    $get_repair_failed_ratio = $get_repair_failed / ($get_repair_success + $get_repair_failed + $get_repair_canceled) * 100
    $get_repair_canceled_ratio = $get_repair_canceled / ($get_repair_success + $get_repair_failed + $get_repair_canceled) * 100
    $get_repair_ratio = $get_repair_success / ($get_repair_success + $get_repair_failed + $get_repair_canceled) * 100
} else {
    $get_repair_failed_ratio = 0.00
    $get_repair_canceled_ratio = 0.00
    $get_repair_ratio = 0.00
}

Write-Host ("Failed:`t`t`t" + $get_repair_failed) -ForegroundColor Red
Write-Host ("Fail Rate:`t`t{0:N}%" -f $get_repair_failed_ratio)
Write-Host ("Canceled:`t`t" + $get_repair_canceled) -ForegroundColor DarkYellow
Write-Host ("Cancel Rate:`t`t{0:N}%" -f $get_repair_canceled_ratio)
Write-Host ("Successful:`t`t" + $get_repair_success) -ForegroundColor Green
Write-Host ("Success Rate:`t`t{0:N}%" -f $get_repair_ratio)

Write-Host "========== REPAIR UPLOAD ====="  -ForegroundColor Cyan

$put_repair_success = ($log | Select-String PUT_REPAIR | Select-String uploaded).Count

$put_repair_canceled = ($log | Select-String PUT_REPAIR | Select-String canceled).Count

$put_repair_failed = ($log | Select-String PUT_REPAIR | Select-String failed).Count

if (($put_repair_success + $put_repair_failed + $put_repair_canceled) -ge 1) {
    $put_repair_failed_ratio = $put_repair_failed / ($put_repair_success + $put_repair_failed + $put_repair_canceled) * 100
    $put_repair_canceled_ratio = $put_repair_canceled / ($put_repair_success + $put_repair_failed + $put_repair_canceled) * 100
    $put_repair_ratio = $put_repair_success / ($put_repair_success + $put_repair_failed + $put_repair_canceled) * 100
} else {
    $put_repair_failed_ratio = 0.00
    $put_repair_canceled_ratio = 0.00
    $put_repair_ratio = 0.00
}

Write-Host ("Failed:`t`t`t" + $put_repair_failed) -ForegroundColor Red
Write-Host ("Fail Rate:`t`t{0:N}%" -f $put_repair_failed_ratio)
Write-Host ("Canceled:`t`t" + $put_repair_canceled) -ForegroundColor DarkYellow
Write-Host ("Cancel Rate:`t`t{0:N}%" -f $put_repair_canceled_ratio)
Write-Host ("Successful:`t`t" + $put_repair_success) -ForegroundColor Green
Write-Host ("Success Rate:`t`t{0:N}%" -f $put_repair_ratio)
