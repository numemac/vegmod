import { Wrapper } from "../../wrapper";

export default class Comment extends Wrapper {
    get body() {
        return this.get("body");
    }

    get comments() {
        return this.get("comments");
    }

    get createdUtc() {
        return this.get("created_utc");
    }

    get permalink() {
        return this.get("permalink");
    }

    get redditor() {
        return this.get("redditor");
    }

    get score() {
        return this.get("score");
    }

    get stickied() {
        return this.get("stickied");
    }

    get distinguished() {
        return this.get("distinguished");
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
}