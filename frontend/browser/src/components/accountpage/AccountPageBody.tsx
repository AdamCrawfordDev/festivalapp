import {
    type ChangeEvent,
    type FormEvent,
    useEffect,
    useRef,
    useState,
} from "react";

import Button from "../../components/ui/Button";
import Form from "../../components/ui/Form";
import TextInput from "../../components/ui/TextInput";
import { useLogout } from "../../features/auth/hooks/useLogout";
import { useAuth } from "../../features/auth/hooks/useCurrentUser";
import { useUpdateCurrentUser } from "../../features/auth/hooks/useUpdateCurrentUser";

export default function AccountPageBody() {
    const { user, isLoading } = useAuth();

    const logoutMutation = useLogout();
    const updateUserMutation =
        useUpdateCurrentUser();

    const fileInputRef =
        useRef<HTMLInputElement>(null);

    const [selectedPicture, setSelectedPicture] =
        useState<File | null>(null);

    const [picturePreview, setPicturePreview] =
        useState<string | null>(null);

    const [displayName, setDisplayName] =
        useState("");

    const [bio, setBio] =
        useState("");

    useEffect(() => {
        if (!user) {
            return;
        }

        setDisplayName(user.display_name ?? "");
        setBio(user.bio ?? "");
    }, [user]);

    useEffect(() => {
        if (!selectedPicture) {
            setPicturePreview(null);
            return;
        }

        const previewUrl =
            URL.createObjectURL(selectedPicture);

        setPicturePreview(previewUrl);

        return () => {
            URL.revokeObjectURL(previewUrl);
        };
    }, [selectedPicture]);

    if (isLoading) {
        return (
            <div className="px-6 py-10 text-center">
                Loading account...
            </div>
        );
    }

    if (!user) {
        return null;
    }

    const displayLabel =
        displayName.trim() ||
        user.username?.trim() ||
        user.email?.trim() ||
        "User";

    const initial = displayLabel
        .charAt(0)
        .toUpperCase();

    const displayedPicture =
        picturePreview ||
        user.profile_picture ||
        null;

    const isBusy =
        updateUserMutation.isPending ||
        logoutMutation.isPending;

    function openPicturePicker() {
        fileInputRef.current?.click();
    }

    function handlePictureChange(
        event: ChangeEvent<HTMLInputElement>,
    ) {
        const file = event.target.files?.[0];

        if (!file) {
            return;
        }

        if (!file.type.startsWith("image/")) {
            event.target.value = "";
            return;
        }

        setSelectedPicture(file);
    }

    function handleSubmit(
        event: FormEvent<HTMLFormElement>,
    ) {
        event.preventDefault();

        const formData = new FormData();

        formData.append(
            "display_name",
            displayName.trim(),
        );

        formData.append(
            "bio",
            bio.trim(),
        );

        if (selectedPicture) {
            formData.append(
                "profile_picture",
                selectedPicture,
            );
        }

        updateUserMutation.mutate(formData, {
            onSuccess: () => {
                setSelectedPicture(null);
                setPicturePreview(null);

                if (fileInputRef.current) {
                    fileInputRef.current.value = "";
                }
            },
        });
    }

    return (
        <div className="flex justify-center px-6 py-10">
            <Form
                title="Your account"
                description="Update your public profile."
                onSubmit={handleSubmit}
                footer={
                    <div className="flex justify-between gap-3">
                        <Button
                            type="button"
                            variant="secondary"
                            onClick={() =>
                                logoutMutation.mutate()
                            }
                            disabled={isBusy}
                        >
                            {logoutMutation.isPending
                                ? "Logging out..."
                                : "Log out"}
                        </Button>

                        <Button
                            type="submit"
                            disabled={isBusy}
                        >
                            {updateUserMutation.isPending
                                ? "Saving..."
                                : "Save changes"}
                        </Button>
                    </div>
                }
            >
                <div className="flex flex-col items-center gap-4">
                    <div
                        className="
                            flex
                            h-28
                            w-28
                            items-center
                            justify-center
                            overflow-hidden
                            rounded-full
                            border
                            border-[var(--color-border)]
                            bg-[var(--color-surface-alt)]
                        "
                    >
                        {displayedPicture ? (
                            <img
                                src={displayedPicture}
                                alt={displayLabel}
                                className="
                                    h-full
                                    w-full
                                    object-cover
                                "
                            />
                        ) : (
                            <span
                                className="
                                    font-heading
                                    text-4xl
                                    font-semibold
                                    text-[var(--color-primary)]
                                "
                            >
                                {initial}
                            </span>
                        )}
                    </div>

                    <input
                        ref={fileInputRef}
                        type="file"
                        accept="image/*"
                        className="hidden"
                        onChange={handlePictureChange}
                    />

                    <Button
                        type="button"
                        variant="secondary"
                        onClick={openPicturePicker}
                        disabled={isBusy}
                    >
                        {selectedPicture
                            ? "Choose another picture"
                            : "Change profile picture"}
                    </Button>

                    {selectedPicture && (
                        <p
                            className="
                                max-w-full
                                truncate
                                text-sm
                                text-[var(--color-text-muted)]
                            "
                        >
                            {selectedPicture.name}
                        </p>
                    )}
                </div>

                <TextInput
                    label="Username"
                    value={user.username ?? ""}
                    readOnly
                />

                <TextInput
                    label="Email"
                    value={user.email ?? ""}
                    readOnly
                />

                <TextInput
                    label="Display name"
                    value={displayName}
                    onChange={(event) =>
                        setDisplayName(
                            event.target.value,
                        )
                    }
                    disabled={isBusy}
                />

                <div>
                    <label
                        htmlFor="bio"
                        className="
                            mb-2
                            block
                            text-sm
                            font-medium
                        "
                    >
                        Bio
                    </label>

                    <textarea
                        id="bio"
                        value={bio}
                        onChange={(event) =>
                            setBio(event.target.value)
                        }
                        rows={5}
                        disabled={isBusy}
                        className="
                            w-full
                            resize-y
                            rounded-xl
                            border
                            border-[var(--color-border)]
                            bg-[var(--color-background)]
                            px-4
                            py-3
                            outline-none
                            transition
                            focus:border-[var(--color-primary)]
                            disabled:cursor-not-allowed
                            disabled:opacity-60
                        "
                    />
                </div>

                <TextInput
                    label="Account type"
                    value={user.account_type ?? ""}
                    readOnly
                />

                {updateUserMutation.isError && (
                    <p className="text-sm text-[var(--color-error)]">
                        Unable to update your profile.
                    </p>
                )}

                {logoutMutation.isError && (
                    <p className="text-sm text-[var(--color-error)]">
                        Unable to log out. Please try again.
                    </p>
                )}
            </Form>
        </div>
    );
}