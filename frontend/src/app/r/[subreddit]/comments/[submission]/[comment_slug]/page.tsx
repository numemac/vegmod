"use client";

import { useParams } from "next/navigation";
import { Show as Component } from "@/components/reddit/submission/show";
import { Show } from "@/show";

export default function Page() {
    const params = useParams();
    const id = params.submission;
    return <Show id={id} type={"Reddit::Submission"} as={Component} />;
}