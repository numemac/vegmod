import { Wrapper } from "../wrapper";
import Subreddit from "./reddit/subreddit";
import Redditor from "./reddit/redditor";

export default class User extends Wrapper {

    get id() : number {
        return this.get("id");
    }

    get email() : string {
        return this.get("email");
    }

    get name() : string {
        return this.get("name");
    }

    get darkMode() : boolean {
        return this.get("dark_mode");
    }

    get redditors() : Redditor[] {
        return this.get("redditors");
    }

    get subreddits() : Subreddit[] {
        return this.get("subreddits");
    }

}