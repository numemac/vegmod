import { Wrapper } from "../../wrapper";
import Plugin from "../plugin";
import Subreddit from "./subreddit";

export default class SubredditPlugin extends Wrapper {

    get plugin() : Plugin {
        return this.get("plugin");
    }

    get enabled() : boolean {
        return this.get("enabled");
    }

    get config() : any {
        return this.get("config");
    }

    get executions() : number {
        return this.get("executions");
    }

    get failures() : number {
        return this.get("failures");
    }

    get lastExecutedAt() : string {
        return this.get("last_executed_at");
    }

    get lastFailedAt() : string {
        return this.get("last_failed_at");
    }

    get subreddit() : Subreddit {
        return this.get("subreddit");
    }

}