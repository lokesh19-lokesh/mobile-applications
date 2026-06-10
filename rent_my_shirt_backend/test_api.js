async function test() {
  console.log('Testing GET /api/v1/shirts...');
  try {
    const res = await fetch('http://localhost:5000/api/v1/shirts');
    const data = await res.json();
    console.log(`Success! Fetched ${data.length} shirts.`);
    console.log(JSON.stringify(data[0], null, 2));
  } catch (err) {
    console.error('Error:', err.message);
  }
}

test();
