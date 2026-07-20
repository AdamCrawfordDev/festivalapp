import { useState } from "react";

import Button from "../ui/Button";
import CreateSetForm from "./CreateSetForm";

type AddSetButtonProps = {
    festivalId: number;
};

export default function AddSetButton({
                                         festivalId,
                                     }: AddSetButtonProps) {
    const [isFormOpen, setIsFormOpen] = useState(false);

    function closeForm() {
        setIsFormOpen(false);
    }

    return (
        <>
            <Button onClick={() => setIsFormOpen(true)}>
                Add Set
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
                    aria-label="Create set"
                    onClick={closeForm}
                >
                    <div
                        className="w-full max-w-lg"
                        onClick={(event) => event.stopPropagation()}
                    >
                        <CreateSetForm
                            festivalId={festivalId}
                            onClose={closeForm}
                        />
                    </div>
                </div>
            )}
        </>
    );
}