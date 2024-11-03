import { Wrapper } from "../../wrapper";
import MetricSubject from "../metrics/metric_subject";
import Submission from "./submission";
import SubredditPlugin from "./subreddit_plugin";

export default class Subreddit extends Wrapper {
    get displayName() : string {
        return this.get("display_name");
    }

    get imageUrl() : string {
        return this.get("image_url");
    }

    get metricSubjects() : MetricSubject[] {
        return this.get("metric_subjects");
    }

    get publicDescription() : string {
        return this.get("public_description");
    }

    get subscribers() : number {
        return this.get("subscribers");
    }

    get submissions() : Submission[] {
        return this.get("submissions");
    }

    get subredditPlugins() : SubredditPlugin[] {
        return this.get("subreddit_plugins");
    }

    get title() : string {
        return this.get("title");
    }
}