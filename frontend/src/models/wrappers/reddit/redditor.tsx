import { Wrapper } from "../../wrapper";
import SubredditRedditor from "@/models/wrappers/reddit/subreddit_redditor";
import XRedditor from "@/models/wrappers/reddit/x_redditor";

export default class Redditor extends Wrapper {
    get commentKarma() : number {
        return this.get("comment_karma");
    }

    get createdUtc() : number {
        return this.get("created_utc");
    }

    get externalId() : string {
        return this.get("external_id");
    }

    get hasVerifiedEmail() : boolean {
        return this.get("has_verified_email");
    }

    get imageUrl() : string {
        return this.get("image_url");
    }

    get isEmployee() : boolean {
        return this.get("is_employee");
    }

    get isGold() : boolean {
        return this.get("is_gold");
    }

    get name() : string {
        return this.get("name");
    }

    get subredditRedditors() : SubredditRedditor[] {
        return this.get("subreddit_redditors");
    }

    get x() : XRedditor {
        return this.get("x");
    }
}