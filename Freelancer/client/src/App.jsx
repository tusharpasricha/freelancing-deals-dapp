import { EthProvider } from "./contexts/EthContext";
import Become from "./pages/become";

function App() {
  return (
    <EthProvider>
      <div id="App">
      <Become/>
      </div>
    </EthProvider>
  );
}

export default App;
