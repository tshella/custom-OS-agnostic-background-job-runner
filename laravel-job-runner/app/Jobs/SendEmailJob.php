<?php

namespace App\Jobs;

use Illuminate\Support\Facades\Log;

class SendEmailJob
{
    public function handle(array $data)
    {
        Log::info("Sending email to {$data['email']}");
        // Simulate work
        sleep(2);
        Log::info("Email sent to {$data['email']}");
    }
}
