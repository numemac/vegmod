"use client";

import { useParams } from "next/navigation";
import { Show as Component } from "@/components/reddit/subreddit_redditor/show";
import { Show } from "@/show";

export default function Page() {
    const params = useParams();
    // + -> %2B
    const id = encodeURIComponent(`${params.redditor}+${params.subreddit}`);
    return <Show id={id} type={"Reddit::SubredditRedditor"} as={Component} />;
}