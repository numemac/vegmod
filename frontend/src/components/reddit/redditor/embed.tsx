import Redditor from "@/models/wrappers/reddit/redditor";
import Link from "next/link";

export const Embed = ({ model, children } : { model: Redditor | null, children: any }) => {
    // deleted user
    if (model === null) {
        return <>{children}</>
    }

    return (   
        <div className="w-fit">
            <Link href={`/u/${model.name}`}>
                {children}
            </Link>
        </div>
    )
}