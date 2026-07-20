import type { FormEvent } from "react";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import axios from "axios";

import { createFestival } from "../../api/festivals";
import Button from "../ui/Button";
import Form from "../ui/Form";
import TextInput from "../ui/TextInput";

type CreateFestivalFormProps = {
    onClose: () => void;
};

function getCreateFestivalError(error: unknown): string {
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

    return "Unable to create the festival. Please try again.";
}

export default function CreateFestivalForm({
                                               onClose,
                                           }: CreateFestivalFormProps) {
    const queryClient = useQueryClient();

    const createFestivalMutation = useMutation({
        mutationFn: createFestival,

        onSuccess: () => {
            queryClient.invalidateQueries({
                queryKey: ["festivals"],
            });

            onClose();
        },
    });

    function handleSubmit(event: FormEvent<HTMLFormElement>) {
        event.preventDefault();

        const formData = new FormData(event.currentTarget);

        createFestivalMutation.mutate(formData);
    }

    return (
        <Form
            title="Add a festival"
            description="Enter the basic information for your festival."
            onSubmit={handleSubmit}
            className="max-h-[90vh] overflow-y-auto"
            footer={
                <div className="flex justify-end gap-3">
                    <Button
                        type="button"
                        variant="secondary"
                        onClick={onClose}
                        disabled={createFestivalMutation.isPending}
                    >
                        Cancel
                    </Button>

                    <Button
                        type="submit"
                        disabled={createFestivalMutation.isPending}
                    >
                        {createFestivalMutation.isPending
                            ? "Creating..."
                            : "Create festival"}
                    </Button>
                </div>
            }
        >
            <TextInput
                label="Festival name"
                name="name"
                placeholder="Festival name"
                required
            />

            <div>
                <label
                    htmlFor="description"
                    className="mb-2 block text-sm font-medium"
                >
                    Description
                </label>

                <textarea
                    id="description"
                    name="description"
                    rows={4}
                    placeholder="Describe the festival"
                    className="
                        w-full
                        resize-none
                        rounded-xl
                        border
                        border-[var(--color-border)]
                        bg-[var(--color-background)]
                        px-4
                        py-3
                        outline-none
                        transition
                        focus:border-[var(--color-primary)]
                    "
                />
            </div>

            <div className="grid gap-5 sm:grid-cols-2">
                <TextInput
                    label="Start date"
                    name="start_date"
                    type="date"
                    required
                />

                <TextInput
                    label="End date"
                    name="end_date"
                    type="date"
                    required
                />
            </div>

            <div>
                <label
                    htmlFor="image"
                    className="mb-2 block text-sm font-medium"
                >
                    Festival image
                </label>

                <input
                    id="image"
                    name="image"
                    type="file"
                    accept="image/*"
                    className="
                        block
                        w-full
                        rounded-xl
                        border
                        border-[var(--color-border)]
                        bg-[var(--color-background)]
                        p-3
                        text-sm
                    "
                />
            </div>

            {createFestivalMutation.isError && (
                <p className="text-sm text-[var(--color-error)]">
                    {getCreateFestivalError(
                        createFestivalMutation.error,
                    )}
                </p>
            )}
        </Form>
    );
}