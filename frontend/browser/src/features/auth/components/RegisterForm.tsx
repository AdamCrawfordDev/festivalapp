import { zodResolver } from "@hookform/resolvers/zod";
import { useMutation } from "@tanstack/react-query";
import axios from "axios";
import { useForm } from "react-hook-form";
import { Link, useNavigate } from "react-router-dom";
import { z } from "zod";

import { registerUser } from "../../../api/auth";
import Button from "../../../components/ui/Button";
import Form from "../../../components/ui/Form";
import TextInput from "../../../components/ui/TextInput";
import type {AccountType} from "../../../types/auth.tsx";

const registerSchema = z
    .object({
        username: z
            .string()
            .min(3, "Username must be at least 3 characters.")
            .max(150, "Username is too long."),

        email: z
            .email("Please enter a valid email address."),

        password: z
            .string()
            .min(8, "Password must be at least 8 characters."),

        confirmPassword: z.string(),
    })
    .refine(
        (data) => data.password === data.confirmPassword,
        {
            message: "Passwords do not match.",
            path: ["confirmPassword"],
        },
    );

type RegisterFormData = z.infer<typeof registerSchema>;

type RegisterFormProps = {
    accountType: AccountType;
};

function getRegistrationError(error: unknown): string {
    if (axios.isAxiosError(error)) {
        const data = error.response?.data;

        if (data && typeof data === "object") {
            const firstValue = Object.values(data)[0];

            if (Array.isArray(firstValue)) {
                return String(firstValue[0]);
            }

            if (typeof firstValue === "string") {
                return firstValue;
            }
        }
    }

    return "Unable to create your account. Please try again.";
}

export default function RegisterForm({
                                         accountType,
                                     }: RegisterFormProps) {
    const navigate = useNavigate();

    const {
        register,
        handleSubmit,
        formState: { errors },
    } = useForm<RegisterFormData>({
        resolver: zodResolver(registerSchema),
    });

    const registerMutation = useMutation({
        mutationFn: registerUser,

        onSuccess: () => {
            navigate("/login");
        },
    });

    function onSubmit(data: RegisterFormData) {
        registerMutation.mutate({
            username: data.username,
            email: data.email,
            password: data.password,
            account_type: accountType,
        });
    }

    const isOrganiser = accountType === "organiser";

    return (
        <Form
            title={
                isOrganiser
                    ? "Create an organiser account"
                    : "Create your account"
            }
            description={
                isOrganiser
                    ? "Create and manage festivals, schedules and attendees."
                    : "Build your timetable and plan festivals with friends."
            }
            onSubmit={handleSubmit(onSubmit)}
            footer={
                <p className="text-center text-sm text-[var(--color-text-muted)]">
                    Already have an account?{" "}
                    <Link
                        to="/login"
                        className="font-semibold text-[var(--color-primary)] hover:underline"
                    >
                        Log in
                    </Link>
                </p>
            }
        >
            <TextInput
                label="Username"
                placeholder="Choose a username"
                autoComplete="username"
                error={errors.username?.message}
                {...register("username")}
            />

            <TextInput
                label="Email"
                type="email"
                placeholder="you@example.com"
                autoComplete="email"
                error={errors.email?.message}
                {...register("email")}
            />

            <TextInput
                label="Password"
                type="password"
                placeholder="Create a password"
                autoComplete="new-password"
                error={errors.password?.message}
                {...register("password")}
            />

            <TextInput
                label="Confirm password"
                type="password"
                placeholder="Enter the password again"
                autoComplete="new-password"
                error={errors.confirmPassword?.message}
                {...register("confirmPassword")}
            />

            {registerMutation.isError && (
                <p className="text-sm text-[var(--color-error)]">
                    {getRegistrationError(registerMutation.error)}
                </p>
            )}

            <Button
                type="submit"
                variant="primary"
                className="w-full"
                disabled={registerMutation.isPending}
            >
                {registerMutation.isPending
                    ? "Creating account..."
                    : "Create account"}
            </Button>
        </Form>
    );
}