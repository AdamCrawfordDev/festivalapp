import { useState } from "react";

import Button from "../ui/Button";
import CreateStageForm from "./CreateStageForm";

type AddStageButtonProps = {
    festivalId: number;
};

export default function AddStageButton({
                                           festivalId,
                                       }: AddStageButtonProps) {
    const [isFormOpen, setIsFormOpen] = useState(false);

    function closeForm() {
        setIsFormOpen(false);
    }

    return (
        <>
            <Button onClick={() => setIsFormOpen(true)}>
                Add Stage
            </Button>

            {isFormOpen && (
                <div
                    className="
                        fixed
                        inset-0
                        z-50
                        flex
                        items-center
                        justify-center
                        bg-black/50
                        p-4
                    "
                    role="dialog"
                    aria-modal="true"
                    aria-label="Create stage"
                    onClick={closeForm}
                >
                    <div
                        className="w-full max-w-lg"
                        onClick={(event) =>
                            event.stopPropagation()
                        }
                    >
                        <CreateStageForm
                            festivalId={festivalId}
                            onClose={closeForm}
                        />
                    </div>
                </div>
            )}
        </>
    );
}