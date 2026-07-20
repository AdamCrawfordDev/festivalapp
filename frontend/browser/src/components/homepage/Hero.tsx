import MainText from "./MainText";
import SubText from "./SubText";
import DescriptionText from "./DescriptionText";
import GetStarted from "./GetStarted";

export default function Hero() {
    return (
        <section className="min-h-[85vh] flex items-center">
            <div className="mx-auto grid w-full max-w-7xl grid-cols-2 gap-16 px-8">

                <div className="flex flex-col justify-center">
                    <MainText />
                    <div className="mt-6 h-1 w-24 rounded-full bg-[var(--color-secondary)]"></div>
                    <SubText />
                    <DescriptionText />
                    <GetStarted />
                </div>

                <div>
                    {/* Phone mockup goes here later */}
                </div>

            </div>
        </section>
    );
}