import {
    BrowserRouter,
    Route,
    Routes,
} from "react-router-dom";

import AppLayout from "../layouts/AppLayout";
import DashboardPage from "../pages/DashboardPage";
import HomePage from "../pages/HomePage";
import LoginPage from "../pages/LoginPage";
import OrganiserRegisterPage from "../pages/OrganiserRegisterPage";
import RegisterPage from "../pages/RegisterPage";
import ProtectedRoute from "./ProtectedRoute";
import AddFestival from "../pages/AddFestival.tsx";
import OrganiserFestivalPage from "../pages/OrganiserFestivalPage";
import AccountPage from "../pages/AccountPage.tsx";
import FestivalPage from "../pages/FestivalPage.tsx";

export default function AppRouter() {
    return (
        <BrowserRouter>
            <Routes>
                <Route element={<AppLayout />}>
                    <Route path="/" element={<HomePage />} />
                    <Route path="/login" element={<LoginPage />} />

                    <Route
                        path="/attendee/register"
                        element={<RegisterPage />}
                    />

                    <Route
                        path="/organiser/register"
                        element={<OrganiserRegisterPage />}
                    />

                    <Route element={<ProtectedRoute />}>
                        <Route
                            path="/dashboard"
                            element={<DashboardPage />}
                        />
                    </Route>

                    <Route element={<ProtectedRoute />}>
                        <Route
                            path="/account"
                            element={<AccountPage />}
                        />
                    </Route>

                    <Route element={<ProtectedRoute />}>
                        <Route
                            path="/festivals/:festivalId"
                            element={<FestivalPage />}
                        />
                    </Route>

                    <Route
                        element={
                            <ProtectedRoute allowedAccountType="organiser" />
                        }
                    >
                        <Route
                            path="/organiser/dashboard"
                            element={<AddFestival />}
                        />


                        <Route
                            path="/organiser/dashboard"
                            element={<AddFestival />}
                        />

                        <Route
                            path="/organiser/festivals/:festivalId"
                            element={<OrganiserFestivalPage />}
                        />
                    </Route>

                </Route>
            </Routes>
        </BrowserRouter>
    );
}