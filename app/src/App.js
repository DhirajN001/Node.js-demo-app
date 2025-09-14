import React, { useState } from "react";

export default function App() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loggedIn, setLoggedIn] = useState(false);

  const handleLogin = (e) => {
    e.preventDefault();
    if (email === "hire-me@anshumat.org" && password === "HireMe@2025!") {
      setLoggedIn(true);
    } else {
      alert("Invalid credentials. Try again!");
    }
  };

  if (loggedIn) {
    return (
      <div style={{ fontFamily: "Arial", padding: 24 }}>
        <h1>Welcome, Demo User 🎉</h1>
        <p>You are logged in successfully.</p>
      </div>
    );
  }

  return (
    <div style={{ fontFamily: "Arial", padding: 24 }}>
      <h1>AWS DevOps Engineer – Demo</h1>
      <form onSubmit={handleLogin}>
        <div>
          <label>Email: </label>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
        </div>
        <div>
          <label>Password: </label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
        </div>
        <button type="submit">Login</button>
      </form>
      <p>Demo Account → Email: <b>hire-me@anshumat.org</b> | Password: <b>HireMe@2025!</b></p>
    </div>
  );
}
