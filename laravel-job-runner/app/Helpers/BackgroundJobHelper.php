<?php

if (!function_exists('runBackgroundJob')) {
    function runBackgroundJob(string $class, string $method, array $params = [])
    {
        $jsonParams = escapeshellarg(json_encode($params));
        $class = escapeshellarg($class);
        $method = escapeshellarg($method);

        $command = "php " . base_path("run-job.php") . " $class $method $jsonParams";

        if (strncasecmp(PHP_OS, 'WIN', 3) == 0) {
            pclose(popen("start /B $command", "r"));
        } else {
            exec("$command > /dev/null 2>&1 &");
        }
    }
}
