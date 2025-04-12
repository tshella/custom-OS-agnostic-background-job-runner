<?php

$queueFile = __DIR__.'/../storage/queue.json';

while (true) {
    $jobs = json_decode(file_get_contents($queueFile), true) ?? [];

    foreach ($jobs as $key => $job) {
        if (!($job['processed'] ?? false)) {
            runBackgroundJob($job['class'], $job['method'], $job['params']);
            $jobs[$key]['processed'] = true;
        }
    }

    file_put_contents($queueFile, json_encode($jobs));
    sleep(5);
}
