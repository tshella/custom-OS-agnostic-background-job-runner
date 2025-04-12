<?php

return [
    'whitelisted_jobs' => [
        \App\Jobs\SendEmailJob::class => ['handle'],
    ],
    'retries' => 3,
    'retry_delay' => 5, // seconds
];
