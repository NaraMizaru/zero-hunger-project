<?php

namespace Database\Seeders;

use App\Models\User;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        User::create([
            'name' => 'admin',
            'username' => 'admin',
            'role' => 'admin',
            'phone_number' => '089519094253',
            'password' => bcrypt('admin123'),
        ]);

        User::create([
            'name' => 'guru',
            'username' => 'guru',
            'role' => 'guru',
            'phone_number' => '089519094253',
            'password' => bcrypt('guru123'),
        ]);

        User::create([
            'name' => 'siswa',
            'username' => 'siswa',
            'role' => 'siswa',
            'phone_number' => '089519094253',
            'password' => bcrypt('siswa123'),
        ]);
    }
}
