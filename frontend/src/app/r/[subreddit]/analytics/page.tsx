"use client";

import { useParams } from "next/navigation";
import { SubredditAnalytics as Component } from "@/components/reddit/subreddit/analytics";
import { Show } from "@/show";

export default function Page() {
    const params = useParams();
    const id = params.subreddit;
    return <Show id={id} type={"Reddit::Subreddit"} as={Component} />;
}