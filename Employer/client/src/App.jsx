import { EthProvider } from "./contexts/EthContext";
import Home from "./pages/home";

function App() {
  return (
    <EthProvider>
      <div id="App">
        
        <Home/>
      </div>
    </EthProvider>
  );
}

export default App;
