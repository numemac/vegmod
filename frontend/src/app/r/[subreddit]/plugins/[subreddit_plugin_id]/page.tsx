"use client";

import { useParams } from "next/navigation";
import { EditSubredditPlugin as Component } from "@/components/reddit/subreddit/plugins/edit";
import { Show } from "@/show";

export default function Page() {
    const params = useParams();
    const id = params.subreddit_plugin_id;
    return <Show id={id} type={"Reddit::SubredditPlugin"} as={Component} />;
}