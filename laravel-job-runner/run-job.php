#!/usr/bin/env php
<?php

require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

$config = require __DIR__.'/config/background-jobs.php';

[$_, $class, $method, $argsJson] = $argv + [null, null, null, '[]'];

if (!isset($config['whitelisted_jobs'][$class]) || !in_array($method, $config['whitelisted_jobs'][$class])) {
    file_put_contents(__DIR__.'/storage/logs/background_jobs_errors.log', "[UNAUTHORIZED] $class::$method\n", FILE_APPEND);
    exit(1);
}

$args = json_decode($argsJson, true) ?? [];

$retries = $config['retries'];
$delay = $config['retry_delay'];
$logPath = __DIR__.'/storage/logs/background_jobs.log';

for ($i = 0; $i <= $retries; $i++) {
    try {
        file_put_contents($logPath, now()." RUNNING: $class::$method\n", FILE_APPEND);
        $job = app()->make($class);
        call_user_func_array([$job, $method], [$args]);
        file_put_contents($logPath, now()." COMPLETED: $class::$method\n", FILE_APPEND);
        exit(0);
    } catch (\Throwable $e) {
        file_put_contents(
            __DIR__.'/storage/logs/background_jobs_errors.log',
            now()." FAILED ($i/$retries): $class::$method\n".$e."\n",
            FILE_APPEND
        );
        if ($i < $retries) sleep($delay);
    }
}

exit(1);
