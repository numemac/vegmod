"use client";

import { useParams } from "next/navigation";
import { Show as Component } from "@/components/reddit/subreddit/show";
import { Show } from "@/show";

export default function Page() {
    const params = useParams();
    const id = params.subreddit;
    return <Show id={id} type={"Reddit::Subreddit"} as={Component} />;
}