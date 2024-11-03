"use client";

import Submission from '@/models/wrappers/reddit/submission';
import Comment from '@/models/wrappers/reddit/comment';
import { Preview } from '@/components/reddit/submission/preview';
import { Node } from '../comment/node';
import SubredditRedditor from '@/models/wrappers/reddit/subreddit_redditor';

export const Show = ({ model } : { model: SubredditRedditor }) => {
    if (!model || !model.redditor || !model.subreddit) {
        return <p>Loading...</p>
    }

    return (
        <div className="flex flex-col gap-2">
            <h1 className="text-2xl font-bold">
                u/{model.redditor.name}'s activity in r/{model.subreddit.displayName}
            </h1>

            <div className="border-t border-b border-gray-200 my-4"></div>

            <h2 className="text-xl font-bold">Submissions</h2>
            { model.submissions && model.submissions.map((submission : Submission) => {
                return <div key={`submission-${submission.get('id')}`}>
                    <Preview model={submission} />
                </div>
            }) }

            <div className="border-t border-b border-gray-200 my-4"></div>

            <h2 className="text-xl font-bold">Comments</h2>
            { model.comments && model.comments.map((comment : Comment) => {
                return <div key={`comment-${comment.get('id')}`}>
                    <Node comment={comment} />
                </div>
            }) }
        </div> 
    )
}