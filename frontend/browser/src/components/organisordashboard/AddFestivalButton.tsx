import { useState } from "react";

import Button from "../ui/Button";
import CreateFestivalForm from "./CreateFestivalForm";

export default function AddFestivalButton() {
    const [isFormOpen, setIsFormOpen] = useState(false);

    function closeForm() {
        setIsFormOpen(false);
    }

    return (
        <>
            <Button onClick={() => setIsFormOpen(true)}>
                Add Festival
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
                    aria-label="Create festival"
                    onClick={closeForm}
                >
                    <div
                        className="w-full max-w-lg"
                        onClick={(event) => event.stopPropagation()}
                    >
                        <CreateFestivalForm onClose={closeForm} />
                    </div>
                </div>
            )}
        </>
    );
}