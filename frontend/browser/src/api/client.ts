import axios from "axios";

function getCookie(name: string): string | null {
    const cookie = document.cookie
        .split("; ")
        .find((entry) => entry.startsWith(`${name}=`));

    if (!cookie) {
        return null;
    }

    return decodeURIComponent(cookie.split("=")[1]);
}

const apiClient = axios.create({
    baseURL:
        import.meta.env.VITE_API_URL ??
        "http://127.0.0.1:8000/api",
    withCredentials: true,
});

apiClient.interceptors.request.use((config) => {
    const method = config.method?.toLowerCase();

    const requiresCsrf =
        method === "post" ||
        method === "put" ||
        method === "patch" ||
        method === "delete";

    if (requiresCsrf) {
        const csrfToken = getCookie("csrftoken");

        if (csrfToken) {
            config.headers["X-CSRFToken"] = csrfToken;
        }
    }

    return config;
});

export default apiClient;