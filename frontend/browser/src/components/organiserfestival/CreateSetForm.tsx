import { zodResolver } from "@hookform/resolvers/zod";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import axios from "axios";
import { useForm } from "react-hook-form";
import { z } from "zod";

import { createSet } from "../../api/festivals";
import { useStages } from "../../features/festivals/hooks/useStages";
import Button from "../ui/Button";
import Form from "../ui/Form";
import TextInput from "../ui/TextInput";

const createSetSchema = z
    .object({
        artist: z
            .string()
            .min(1, "Artist name is required.")
            .max(200, "Artist name is too long."),

        stage: z
            .string()
            .min(1, "Please select a stage."),

        start_time: z
            .string()
            .min(1, "Start time is required."),

        end_time: z
            .string()
            .min(1, "End time is required."),
    })
    .refine(
        (data) =>
            new Date(data.end_time) > new Date(data.start_time),
        {
            message: "End time must be after the start time.",
            path: ["end_time"],
        },
    );

type CreateSetFormData = z.infer<typeof createSetSchema>;

type CreateSetFormProps = {
    festivalId: number;
    onClose: () => void;
};

function getCreateSetError(error: unknown): string {
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

    return "Unable to create the set. Please try again.";
}

export default function CreateSetForm({
                                          festivalId,
                                          onClose,
                                      }: CreateSetFormProps) {
    const queryClient = useQueryClient();
    const stagesQuery = useStages(festivalId);

    const {
        register,
        handleSubmit,
        formState: { errors },
    } = useForm<CreateSetFormData>({
        resolver: zodResolver(createSetSchema),
    });

    const createSetMutation = useMutation({
        mutationFn: createSet,

        onSuccess: () => {
            queryClient.invalidateQueries({
                queryKey: ["sets", festivalId],
            });

            onClose();
        },
    });

    function onSubmit(data: CreateSetFormData) {
        createSetMutation.mutate({
            artist: data.artist,
            stage: Number(data.stage),
            start_time: new Date(data.start_time).toISOString(),
            end_time: new Date(data.end_time).toISOString(),
        });
    }

    return (
        <Form
            title="Add a set"
            description="Add an artist to the festival timetable."
            onSubmit={handleSubmit(onSubmit)}
            className="max-h-[90vh] overflow-y-auto"
            footer={
                <div className="flex justify-end gap-3">
                    <Button
                        type="button"
                        variant="secondary"
                        onClick={onClose}
                        disabled={createSetMutation.isPending}
                    >
                        Cancel
                    </Button>

                    <Button
                        type="submit"
                        disabled={
                            createSetMutation.isPending ||
                            stagesQuery.isPending
                        }
                    >
                        {createSetMutation.isPending
                            ? "Creating..."
                            : "Create set"}
                    </Button>
                </div>
            }
        >
            <TextInput
                label="Artist"
                placeholder="Enter the artist name"
                error={errors.artist?.message}
                {...register("artist")}
            />

            <div>
                <label
                    htmlFor="stage"
                    className="mb-2 block text-sm font-medium"
                >
                    Stage
                </label>

                <select
                    id="stage"
                    className="
                        w-full
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
                    defaultValue=""
                    {...register("stage")}
                >
                    <option value="" disabled>
                        {stagesQuery.isPending
                            ? "Loading stages..."
                            : "Select a stage"}
                    </option>

                    {stagesQuery.data?.map((stage) => (
                        <option
                            key={stage.id}
                            value={stage.id}
                        >
                            {stage.name}
                        </option>
                    ))}
                </select>

                {errors.stage?.message && (
                    <p className="mt-1 text-sm text-[var(--color-error)]">
                        {errors.stage.message}
                    </p>
                )}

                {stagesQuery.isSuccess &&
                    stagesQuery.data.length === 0 && (
                        <p className="mt-2 text-sm text-[var(--color-warning)]">
                            Add a stage before creating a set.
                        </p>
                    )}
            </div>

            <div className="grid gap-5 sm:grid-cols-2">
                <TextInput
                    label="Start time"
                    type="datetime-local"
                    error={errors.start_time?.message}
                    {...register("start_time")}
                />

                <TextInput
                    label="End time"
                    type="datetime-local"
                    error={errors.end_time?.message}
                    {...register("end_time")}
                />
            </div>

            {createSetMutation.isError && (
                <p className="text-sm text-[var(--color-error)]">
                    {getCreateSetError(
                        createSetMutation.error,
                    )}
                </p>
            )}
        </Form>
    );
}