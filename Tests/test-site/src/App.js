import React from 'react';
import logo from './logo.svg';
import './App.css';
import DropDown from './Components/dropdown'
import Contributions from './Components/Contributions'


function App() {
  return (
    <div className="App">
      <header className="App-header">
      <h1>MVP Test Site</h1>
      <span>This is a replica site that is used for Integration Testing</span>
      </header>
      <Contributions />
    </div>
  );
}

export default App;
