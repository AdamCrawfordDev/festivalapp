import RegisterForm from "../features/auth/components/RegisterForm";

export default function RegisterPage() {
    return (
        <section className="flex min-h-[70vh] w-full items-center justify-center px-6 py-12">
            <RegisterForm accountType="user" />
        </section>
    );
}