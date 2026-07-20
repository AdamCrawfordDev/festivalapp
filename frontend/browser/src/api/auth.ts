import apiClient from "./client";
import type {LoginRequest, LoginResponse, LogoutResponse, RegisterRequest, User} from "../types/auth.tsx";



export async function registerUser(
    registration: RegisterRequest,
): Promise<User> {
    const response = await apiClient.post<User>(
        "/accounts/register/",
        registration,
    );

    return response.data;
}

export async function loginUser(
    credentials: LoginRequest,
): Promise<LoginResponse> {
    const response = await apiClient.post<LoginResponse>(
        "/accounts/login/",
        credentials,
    );

    return response.data;
}

export async function logoutUser(): Promise<LogoutResponse> {
    const response =
        await apiClient.post<LogoutResponse>(
            "/accounts/logout/",
        );

    return response.data;
}

export async function getCurrentUser(): Promise<User> {
    const response = await apiClient.get<User>(
        "/accounts/profile/",
    );

    return response.data;
}

export async function updateCurrentUser(
    formData: FormData,
): Promise<User> {
    const response = await apiClient.patch<User>(
        "/accounts/profile/",
        formData,
    );

    return response.data;
}