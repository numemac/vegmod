import Comment from "@/models/wrappers/reddit/comment";

import { Node as CommentNode } from "@/components/reddit/comment/node";

export const Tree = ({ comments } : { comments: Comment[] }) => {
    return (
        <div>
            { 
                // Sort comments by score, with stickied comments first
                comments.sort((a, b) => {
                    if (a.stickied && !b.stickied) {
                        return -1;
                    }
                    if (!a.stickied && b.stickied) {
                        return 1;
                    }
                    return b.score - a.score;
                }).map(comment => {
                    return <div key={`comment-${comment.id}`}>
                        <CommentNode comment={comment} />
                        <div className="mb-4">
                            <div className="ml-3 border-l-2 border-gray-200">
                                { comment.comments && <Tree comments={comment.comments} /> }
                            </div>
                        </div>
                    </div>
                })
            }       
        </div>
    )
}