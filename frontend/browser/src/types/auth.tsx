export type AccountType = "user" | "organiser";

export type User = {
    id: number;
    username: string;
    email: string;
    account_type: AccountType;
    bio?: string;
    display_name?: string;
    profile_picture?: string;
};

export type RegisterRequest = {
    username: string;
    email: string;
    password: string;
    account_type: AccountType;
};

export type LoginRequest = {
    username: string;
    password: string;
};

export type LoginResponse = {
    message: string;
    user: User;
};

export type LogoutResponse = {
    message: string;
};