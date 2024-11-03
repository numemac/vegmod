"use client";

import { useParams } from "next/navigation";
import { Profile as Component } from "@/components/reddit/redditor/profile";
import { Show } from "@/show";

export default function Page() {
    const params = useParams();
    const id = params.redditor;
    return <Show id={id} type={"Reddit::Redditor"} as={Component} />;
}