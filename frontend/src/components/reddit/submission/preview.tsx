import Submission from "@/models/wrappers/reddit/submission";
import Link from "next/link";
import { LinkIcon } from "@heroicons/react/24/outline";
import { Embed } from "../redditor/embed";
import { Subtitle } from "@/components/font";

export const Preview = ({ model } : { model: Submission }) => {

    const content = () => {
        if (model.isSelf) {
            return (
                <p className="text-xs text-gray-500 line-clamp-4">
                    {model.selftext}
                </p>
            )
        } else if (model.imageUrl) {
            return (
                <div className="bg-gray-200 dark:bg-gray-800 flex justify-center">
                    <img loading="lazy" src={model.imageUrl} className="max-w-xs max-h-96 object-cover" />
                </div>
            )
        } else if (model.url) {
            return (
                <div className="text-xs text-blue-500 hover:text-blue-700 underline my-1 truncate">
                    <Link href={model.url}>
                        {model.url}
                    </Link>
                </div>
            )
        }

        return <></>;
    }

    return (
        <div>
            <div className="flex gap-2 items-center w-full">
                <div>
                    {model.redditor ? (
                        <img loading="lazy" src={model.redditor.imageUrl} className="h-5 w-5 rounded-full" />
                    ) : (
                        <></>
                    )}
                </div>
                <Embed model={model.redditor}>
                    <p className="text-xs text-gray-500">
                        {model.redditor ? model.redditor.name : "[deleted]"}
                    </p>
                </Embed>
                <p className="text-xs text-gray-500">
                    {model.authorFlairText}
                </p>
                {model.redditor && (
                    <span className="text-xs text-green-500" title="Non adversarial score">
                        {model.redditor.x.non_adversarial_score}
                    </span>
                )}
                {model.redditor && (
                    <span className="text-xs text-red-400" title="Adversarial score">
                        {model.redditor.x.adversarial_score}
                    </span>
                )}
                <p className="text-xs text-gray-500">
                    {model.timeAgo}
                </p>
            </div>

            <Link href={model.permalink}>
                <Subtitle>
                    {model.title}
                </Subtitle>
                {content()}
            </Link>
            <div className="flex gap-2 mt-1">
                <div className="border-gray-100 dark:border-gray-600 border-2 rounded-md p-1">
                    <p className="text-sm text-gray-500">
                        {model.score} points
                    </p>
                </div>
                <div className="border-gray-100 dark:border-gray-600 border-2 rounded-md p-1">
                    <p className="text-sm text-gray-500">
                        {model.numComments} comments
                    </p>
                </div>
                <div className="border-gray-100 dark:border-gray-600 border-2 rounded-md p-1">
                    <Link href={`https://reddit.com${model.permalink}`}>
                        <LinkIcon className="h-4 w-4 text-gray-500" />
                    </Link>
                </div>
            </div>
        </div>
    )
}