import { zodResolver } from "@hookform/resolvers/zod";
import {
    useMutation,
    useQueryClient,
} from "@tanstack/react-query";
import axios from "axios";
import { useForm } from "react-hook-form";
import { z } from "zod";

import { createStage } from "../../api/festivals";
import Button from "../ui/Button";
import Form from "../ui/Form";
import TextInput from "../ui/TextInput";

const createStageSchema = z.object({
    name: z
        .string()
        .trim()
        .min(1, "Stage name is required.")
        .max(200, "Stage name is too long."),
});

type CreateStageFormData = z.infer<
    typeof createStageSchema
>;

type CreateStageFormProps = {
    festivalId: number;
    onClose: () => void;
};

function getCreateStageError(error: unknown): string {
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

    return "Unable to create the stage. Please try again.";
}

export default function CreateStageForm({
                                            festivalId,
                                            onClose,
                                        }: CreateStageFormProps) {
    const queryClient = useQueryClient();

    const {
        register,
        handleSubmit,
        formState: { errors },
    } = useForm<CreateStageFormData>({
        resolver: zodResolver(createStageSchema),
        defaultValues: {
            name: "",
        },
    });

    const createStageMutation = useMutation({
        mutationFn: (data: CreateStageFormData) =>
            createStage(festivalId, data),

        onSuccess: () => {
            queryClient.invalidateQueries({
                queryKey: ["stages", festivalId],
            });

            onClose();
        },
    });

    function onSubmit(data: CreateStageFormData) {
        createStageMutation.mutate({
            name: data.name.trim(),
        });
    }

    return (
        <Form
            title="Add a stage"
            description="Create a stage for this festival."
            onSubmit={handleSubmit(onSubmit)}
            footer={
                <div className="flex justify-end gap-3">
                    <Button
                        type="button"
                        variant="secondary"
                        onClick={onClose}
                        disabled={
                            createStageMutation.isPending
                        }
                    >
                        Cancel
                    </Button>

                    <Button
                        type="submit"
                        disabled={
                            createStageMutation.isPending
                        }
                    >
                        {createStageMutation.isPending
                            ? "Creating..."
                            : "Create stage"}
                    </Button>
                </div>
            }
        >
            <TextInput
                label="Stage name"
                placeholder="For example, Main Stage"
                error={errors.name?.message}
                {...register("name")}
            />

            {createStageMutation.isError && (
                <p className="text-sm text-[var(--color-error)]">
                    {getCreateStageError(
                        createStageMutation.error,
                    )}
                </p>
            )}
        </Form>
    );
}