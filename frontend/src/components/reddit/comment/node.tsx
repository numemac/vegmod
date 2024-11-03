import Comment from "@/models/wrappers/reddit/comment";
import { Embed as EmbedRedditor} from "@/components/reddit/redditor/embed";
import Markdown from "react-markdown";
import { LinkIcon } from "@heroicons/react/24/outline";
import Link from "next/link";

export const Node = ({ comment } : { comment: Comment }) => {
    if (!comment.redditor) {
        return null;
    }

    return (
        <div key={`comment-${comment.get('id')}`} className="ml-4">
            {/* <div>{comment.redditor.get('name')}</div>
            <div>{comment.body}</div>
            <div>{comment.score}</div>
            <div>{comment.createdUtc}</div> */}

            <EmbedRedditor model={comment.redditor}>
                <div className="flex gap-2 items-center">
                        <div>
                            <img src={comment.redditor.imageUrl} className="h-6 w-6 rounded-full" />
                        </div>
                        <div className="flex flex-col">
                            <div className="flex gap-2 items-center">
                                <span className="text-xs text-gray-500">
                                    {comment.redditor.name}
                                </span>
                                {
                                    comment.distinguished && (
                                        <span className="text-xs font-bold text-green-500">
                                            MOD
                                        </span>
                                    )
                                }
                                <span className="text-xs text-green-500" title="Non adversarial score">
                                    {comment.redditor.x.non_adversarial_score}
                                </span>
                                <span className="text-xs text-red-400" title="Adversarial score">
                                    {comment.redditor.x.adversarial_score}
                                </span>
                                <span className="text-xs text-gray-500">
                                    {comment.timeAgo}
                                </span>
                            </div>
                        </div>
                    
                </div>
            </EmbedRedditor>

            <div className="markdown">
                <Markdown>
                    {comment.body}
                </Markdown>
            </div>

            <div className="flex gap-2 w-full justify-end">
                <span className="text-xs text-gray-500">
                    <Link href={`https://reddit.com${comment.permalink}`}>
                        <LinkIcon className="h-4 w-4" />
                    </Link>
                </span>
                <span className="text-xs text-gray-500">
                    {comment.score}
                </span>
            </div>
        </div>
    );
}