<?php
header('Content-Type: text/html; charset=utf-8');
echo "<h1>Проверка подключения к БД</h1>";
echo "<p>PHP " . PHP_VERSION . "</p>";

function check(string $name, callable $fn): void
{
    try {
        $result = $fn();
        echo "<p style='color:green'>&#10004; $name: " . htmlspecialchars($result) . "</p>";
    } catch (Throwable $e) {
        echo "<p style='color:red'>&#10008; $name: " . htmlspecialchars($e->getMessage()) . "</p>";
    }
}

check('MariaDB (mysqli)', function () {
    $c1 = new mysqli('db-mysql', 'root', 'secret');
    return 'версия ' . $c1->server_info;
});

check('PostgreSQL (PDO)', function () {
    $pdo = new PDO('pgsql:host=db-pgsql;dbname=postgres', 'postgres', 'secret',
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
    return $pdo->query('SELECT version()')->fetchColumn();
});

check('Redis', function () {
    $redis = new Redis();
    $redis->connect('db-redis', 6379);
    return 'счётчик посещений = ' . $redis->incr('visits');
});
