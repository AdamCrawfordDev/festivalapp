import {
  BrowserRouter,
  Navigate,
  Route,
  Routes,
} from "react-router-dom";

function HomePage() {
  return <h1 className="text-3xl font-bold">Festival App</h1>;
}

function LoginPage() {
  return <h1>Login</h1>;
}

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<HomePage />} />
        <Route path="/login" element={<LoginPage />} />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;