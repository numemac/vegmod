import Submission from "@/models/wrappers/reddit/submission";
import Link from "next/link";
import Markdown from "react-markdown";

import { Embed } from "@/components/reddit/redditor/embed";

import { Tree as CommentTree } from "@/components/reddit/comment/tree";
import { EyeIcon, LinkIcon } from "@heroicons/react/24/outline";

export const Expanded = ({ model } : { model: Submission }) => {

    if (!model.subreddit || !model.comments) {
        return <></>;
    }

    const content = () => {
        if (model.isSelf) {
            return (
                <p className="text-xs">
                    <div className="markdown">
                        <Markdown>
                            {model.selftext}
                        </Markdown>
                    </div>
                </p>
            )
        } else if (model.imageUrl) {
            return (
                <div className="w-full bg-gray-100 dark:bg-gray-900 flex justify-center">
                    <img src={model.imageUrl} className="max-w-lg w-full" />
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
            <div className="flex gap-2 items-center">
                <Link href={`/r/${model.subreddit.displayName}`}>
                    <img src={model.subreddit.imageUrl} className="h-7 w-7 rounded-full" />
                </Link>
                <div className="flex-col gap-2">
                    <Link href={`/r/${model.subreddit.displayName}`}>
                        <div className="flex gap-2 items-center text-gray-500 text-xs">

                                <span className="font-bold ">
                                    r/{model.subreddit.displayName}
                                </span>
                                <span>
                                    {model.timeAgo} ago
                                </span>

                        </div>
                    </Link>
                    <div className="flex gap-2 items-center">
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
                    </div>
                </div>
            </div>

            <h2 className="text-lg font-semibold mb-4">
                {model.title}
            </h2>
            {content()}

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

            {
                model.visionLabels && model.visionLabels.length > 0 && model.visionLabels.map((e) => {
                    return (
                        <div className="bg-yellow-100 p-2 rounded-md mt-2 flex gap-2">
                            <div className="flex">
                                <EyeIcon className="h-4 w-4 text-gray-700" />
                            </div>
                            <p className="text-xs text-gray-700 font-bold">
                                {e.label}
                            </p>
                            <p className="text-xs text-gray-500 line-clamp-4 hover:line-clamp-none">
                                {e.value}
                            </p>
                        </div>
                    )
                })
            }

            <div className="mt-4">
                <CommentTree comments={model.comments} />
            </div>
        </div>
    )
}