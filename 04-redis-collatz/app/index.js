const { createClient } = require('redis');

const N = Number(process.env.N);

function steps(n) {
  let count = 0;
  while (n != 1) {
    if (n % 2 == 0) {
      n = n / 2;
    } else {
      n = 3 * n + 1;
    }
    count++;
  }
  return count;
}

async function stepsRedis(client, n) {
  let path = [];
  let count = 0;
  while (n != 1) {
    let saved = await client.get(String(n));
    if (saved != null) {
      count = Number(saved);
      break;
    }
    path.push(n);
    if (n % 2 == 0) {
      n = n / 2;
    } else {
      n = 3 * n + 1;
    }
  }
  for (let i = path.length - 1; i >= 0; i--) {
    count++;
    await client.set(String(path[i]), String(count));
  }
  return count;
}

async function main() {
  console.log('N = ' + N);

  let start = Date.now();
  let best = 1;
  let max = 0;
  for (let i = 1; i <= N; i++) {
    let s = steps(i);
    if (s > max) {
      max = s;
      best = i;
    }
  }
  console.log('Без Redis: ' + (Date.now() - start) + ' мс');
  console.log('Самая длинная петля: ' + best + ', шагов: ' + max);

  const client = createClient({ url: 'redis://redis:6379' });
  await client.connect();
  await client.flushAll();

  start = Date.now();
  for (let i = 1; i <= N; i++) {
    await stepsRedis(client, i);
  }
  console.log('С Redis, пустая база: ' + (Date.now() - start) + ' мс');

  start = Date.now();
  for (let i = 1; i <= N; i++) {
    await stepsRedis(client, i);
  }
  console.log('С Redis, база заполнена: ' + (Date.now() - start) + ' мс');

  console.log('Чисел в Redis: ' + (await client.dbSize()));
  await client.quit();
}

main();
