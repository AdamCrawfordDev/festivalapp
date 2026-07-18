import {motion} from "motion/react"

export default function MainText() {
    return (
        <div className="mx-auto flex min-h-[80vh] max-w-9xl items-center px-8">
            <div className="max-w-7xl mx-auto">
                <h1 className="font-heading text-8xl text-[var(--color-accent)]">
                    Festival
                    Planning
                </h1>
                <div className="pl-1.25 flex gap-3">
                    <motion.div
                        initial={{ opacity: 0, y: -50 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{
                            y: { duration: 0.4 },
                            opacity: { duration: 0.8 },
                        }}
                    >
                        <p className="text-5xl font-semibold text-[var(--color-secondary)]">
                            Made
                        </p>
                    </motion.div>

                    <motion.div
                        initial={{ opacity: 0, y: -50 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{
                            y: { duration: 0.6 },
                            opacity: { duration: 1},
                        }}
                    >
                        <p className="text-5xl font-semibold text-[var(--color-secondary)]">
                            Easy
                        </p>
                    </motion.div>

                </div>
                <p className="pl-2 pt-2.5 text-xl font-[var(--font-secondary)]]">
                    So partiers and organisers can focus on what matters.
                </p>



            </div>
        </div>
    );
}