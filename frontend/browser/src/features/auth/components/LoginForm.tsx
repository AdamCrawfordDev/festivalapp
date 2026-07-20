import { zodResolver } from "@hookform/resolvers/zod";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import axios from "axios";
import { useForm } from "react-hook-form";
import { useNavigate, Link } from "react-router-dom";
import { z } from "zod";

import { loginUser } from "../../../api/auth";
import Button from "../../../components/ui/Button";
import Form from "../../../components/ui/Form";
import TextInput from "../../../components/ui/TextInput";
import { currentUserQueryKey } from "../hooks/useCurrentUser";

const loginSchema = z.object({
    username: z
        .string()
        .min(1, "Username is required."),

    password: z
        .string()
        .min(1, "Password is required."),
});

type LoginFormData = z.infer<typeof loginSchema>;

function getLoginError(error: unknown): string {
    if (axios.isAxiosError(error)) {
        const message = error.response?.data?.error;

        if (typeof message === "string") {
            return message;
        }
    }

    return "Unable to log in. Please try again.";
}

export default function LoginForm() {
    const navigate = useNavigate();
    const queryClient = useQueryClient();

    const {
        register,
        handleSubmit,
        formState: { errors },
    } = useForm<LoginFormData>({
        resolver: zodResolver(loginSchema),
    });

    const loginMutation = useMutation({
        mutationFn: loginUser,

        onSuccess: (response) => {
            queryClient.setQueryData(
                currentUserQueryKey,
                response.user,
            );

            if (response.user.account_type === "organiser") {
                navigate("/organiser/dashboard");
            } else {
                navigate("/dashboard");
            }
        },
    });

    function onSubmit(data: LoginFormData) {
        loginMutation.mutate(data);
    }

    return (
        <Form
            title="Welcome back"
            description="Log in to continue planning your next festival."
            onSubmit={handleSubmit(onSubmit)}
            footer={
                <p className="text-center text-sm text-[var(--color-text-muted)]">
                    Don&apos;t have an account?{" "}
                    <Link
                        to="/attendee/register"
                        className="font-semibold text-[var(--color-primary)] hover:underline"
                    >
                        Create one
                    </Link>
                </p>
            }
        >
            <TextInput
                label="Username"
                placeholder="Enter your username"
                autoComplete="username"
                error={errors.username?.message}
                {...register("username")}
            />

            <TextInput
                label="Password"
                type="password"
                placeholder="Enter your password"
                autoComplete="current-password"
                error={errors.password?.message}
                {...register("password")}
            />

            {loginMutation.isError && (
                <p className="text-sm text-[var(--color-error)]">
                    {getLoginError(loginMutation.error)}
                </p>
            )}

            <Button
                type="submit"
                variant="primary"
                className="w-full"
                disabled={loginMutation.isPending}
            >
                {loginMutation.isPending
                    ? "Logging in..."
                    : "Log in"}
            </Button>
        </Form>
    );
}