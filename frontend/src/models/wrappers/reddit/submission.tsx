import { Wrapper } from "../../wrapper";
import Comment from "./comment";
import Redditor from "./redditor";
import Subreddit from "./subreddit";
import VisionLabel from "./vision_label";

export default class Submission extends Wrapper {
    get authorFlairText() : string {
        return this.get("author_flair_text");
    }

    get comments() : Comment[] {
        return this.get("comments");
    }

    get createdUtc() : number {
        return this.get("created_utc");
    }

    get externalId() : string {
        return this.get("external_id");
    }

    get imageUrl() : string | null {
        return this.get("image_url");
    }

    get isSelf() : boolean {
        return this.get("is_self");
    }

    get numComments() : number {
        return this.get("num_comments");
    }

    get permalink() : string {
        return this.get("permalink");
    }

    get timeAgo() : string {
        const elapsed = Math.floor(Date.now() / 1000) - this.createdUtc;
        if (elapsed < 60) {
            return "just now";
        }

        if (elapsed < 3600) {
            return `${Math.floor(elapsed / 60)}min`;
        }

        if (elapsed < 86400) {
            return `${Math.floor(elapsed / 3600)}h`;
        }

        return `${Math.floor(elapsed / 86400)}d`;
    }

    get redditor() : Redditor | null {
        return this.get("redditor");
    }

    get score() : number {
        return this.get("score");
    }

    get selftext() : string {
        return this.get("selftext");
    }

    get subreddit() : Subreddit {
        return this.get("subreddit");
    }

    get title() : string {
        return this.get("title");
    }

    get visionLabels() : VisionLabel[] {
        return this.get("vision_labels");
    }

    get url() : string {
        return this.get("url");
    }
}