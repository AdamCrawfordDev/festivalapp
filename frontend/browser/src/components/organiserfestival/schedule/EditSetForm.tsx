import { zodResolver } from "@hookform/resolvers/zod";
import {
    useMutation,
    useQueryClient,
} from "@tanstack/react-query";
import axios from "axios";
import {
    Controller,
    useForm,
} from "react-hook-form";
import { z } from "zod";

import {
    createArtist,
    updateSet,
} from "../../../api/festivals";
import { useArtists } from "../../../features/festivals/hooks/useArtists";
import { useStages } from "../../../features/festivals/hooks/useStages";
import type {
    Artist,
    FestivalSet,
} from "../../../types/festival";
import Button from "../../ui/Button";
import Form from "../../ui/Form";
import SelectField from "../../ui/SelectField";
import TextInput from "../../ui/TextInput";

const editSetSchema = z
    .object({
        artist_name: z
            .string()
            .trim()
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
            new Date(data.end_time) >
            new Date(data.start_time),
        {
            message: "End time must be after start time.",
            path: ["end_time"],
        },
    );

type EditSetFormData = z.infer<
    typeof editSetSchema
>;

type EditSetFormProps = {
    set: FestivalSet;
    onClose: () => void;
};

function toDateTimeLocal(dateString: string) {
    const date = new Date(dateString);
    const timezoneOffset = date.getTimezoneOffset();

    return new Date(
        date.getTime() - timezoneOffset * 60_000,
    )
        .toISOString()
        .slice(0, 16);
}

function findArtistByName(
    artists: Artist[],
    artistName: string,
) {
    const normalizedName = artistName
        .trim()
        .toLowerCase();

    return artists.find(
        (artist) =>
            artist.name.trim().toLowerCase() ===
            normalizedName,
    );
}

function getEditSetError(error: unknown) {
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

    return "Unable to update this set.";
}

export default function EditSetForm({
                                        set,
                                        onClose,
                                    }: EditSetFormProps) {
    const festivalId = set.festival;
    const queryClient = useQueryClient();

    const stagesQuery = useStages(festivalId);
    const artistsQuery = useArtists(festivalId);

    const {
        register,
        control,
        handleSubmit,
        formState: { errors },
    } = useForm<EditSetFormData>({
        resolver: zodResolver(editSetSchema),

        defaultValues: {
            artist_name: set.artist_name,
            stage: String(set.stage),
            start_time: toDateTimeLocal(
                set.start_time,
            ),
            end_time: toDateTimeLocal(
                set.end_time,
            ),
        },
    });

    const updateMutation = useMutation({
        mutationFn: async (
            data: EditSetFormData,
        ) => {
            const artistName =
                data.artist_name.trim();

            const existingArtist =
                findArtistByName(
                    artistsQuery.data ?? [],
                    artistName,
                );

            const artist =
                existingArtist ??
                (await createArtist(
                    festivalId,
                    {
                        name: artistName,
                    },
                ));

            return updateSet(set.id, {
                artist: artist.id,
                stage: Number(data.stage),
                start_time: new Date(
                    data.start_time,
                ).toISOString(),
                end_time: new Date(
                    data.end_time,
                ).toISOString(),
            });
        },

        onSuccess: async () => {
            await Promise.all([
                queryClient.invalidateQueries({
                    queryKey: [
                        "sets",
                        festivalId,
                    ],
                }),

                queryClient.invalidateQueries({
                    queryKey: [
                        "artists",
                        festivalId,
                    ],
                }),
            ]);

            onClose();
        },
    });

    const hasStages =
        stagesQuery.isSuccess &&
        stagesQuery.data.length > 0;

    const cannotSubmit =
        updateMutation.isPending ||
        stagesQuery.isPending ||
        stagesQuery.isError ||
        !hasStages;

    const stagePlaceholder =
        stagesQuery.isPending
            ? "Loading stages..."
            : stagesQuery.isError
                ? "Unable to load stages"
                : "Select a stage";

    const stageOptions =
        stagesQuery.data?.map((stage) => ({
            value: String(stage.id),
            label: stage.name,
        })) ?? [];

    function onSubmit(data: EditSetFormData) {
        updateMutation.mutate(data);
    }

    return (
        <Form
            title="Edit set"
            description={`Update ${set.artist_name}'s timetable entry.`}
            onSubmit={handleSubmit(onSubmit)}
            footer={
                <div className="flex justify-end gap-3">
                    <Button
                        type="button"
                        variant="secondary"
                        onClick={onClose}
                        disabled={
                            updateMutation.isPending
                        }
                    >
                        Cancel
                    </Button>

                    <Button
                        type="submit"
                        disabled={cannotSubmit}
                    >
                        {updateMutation.isPending
                            ? "Saving..."
                            : "Save changes"}
                    </Button>
                </div>
            }
        >
            <div>
                <TextInput
                    label="Artist"
                    placeholder="Enter an artist name"
                    error={
                        errors.artist_name?.message
                    }
                    {...register("artist_name")}
                />

                <p
                    className="
                        mt-1
                        text-sm
                        text-[var(--color-text-muted)]
                    "
                >
                    Enter an existing artist name or
                    create a new one.
                </p>

                {artistsQuery.isError && (
                    <p
                        className="
                            mt-1
                            text-sm
                            text-[var(--color-warning)]
                        "
                    >
                        Existing artists could not be
                        loaded, but you can still enter an
                        artist name.
                    </p>
                )}
            </div>

            <Controller
                name="stage"
                control={control}
                render={({ field }) => (
                    <SelectField
                        label="Stage"
                        value={field.value}
                        onChange={field.onChange}
                        disabled={!hasStages}
                        placeholder={stagePlaceholder}
                        error={errors.stage?.message}
                        options={stageOptions}
                    />
                )}
            />

            {stagesQuery.isError && (
                <p className="text-sm text-[var(--color-error)]">
                    The stages could not be loaded.
                </p>
            )}

            {stagesQuery.isSuccess &&
                stagesQuery.data.length === 0 && (
                    <p className="text-sm text-[var(--color-warning)]">
                        Add a stage before editing this set.
                    </p>
                )}

            <div className="grid gap-5 sm:grid-cols-2">
                <TextInput
                    label="Start time"
                    type="datetime-local"
                    error={
                        errors.start_time?.message
                    }
                    {...register("start_time")}
                />

                <TextInput
                    label="End time"
                    type="datetime-local"
                    error={
                        errors.end_time?.message
                    }
                    {...register("end_time")}
                />
            </div>

            {updateMutation.isError && (
                <p className="text-sm text-[var(--color-error)]">
                    {getEditSetError(
                        updateMutation.error,
                    )}
                </p>
            )}
        </Form>
    );
}