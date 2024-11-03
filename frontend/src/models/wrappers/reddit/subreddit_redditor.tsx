import { Wrapper } from "../../wrapper";
import Comment from "../reddit/comment";
import Submission from "../reddit/submission";
import Redditor from "./redditor";
import Subreddit from "./subreddit";

export default class SubredditRedditor extends Wrapper {

    get comments() : Comment[] {
        return this.get("comments");
    }

    get lastContributedAt() : Date {
        return this.get("last_contributed_at");
    }

    get redditor() : Redditor {
        return this.get("redditor");
    }

    get score() : number {
        return this.get("score");
    }

    get score30d() : number {
        return this.get("score_30d");
    }

    get submissions() : Submission[] {
        return this.get("submissions");
    }

    get subreddit() : Subreddit {
        return this.get("subreddit");
    }

}