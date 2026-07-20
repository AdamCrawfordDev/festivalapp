export default function PageTitle({
                                      title,
                                  }: {
    title: string;
}) {
    return<h1 className="p-5 [font-family:var(--font-heading)] text-5xl">
        {title}
    </h1>;
}