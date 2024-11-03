"use client";

import Subreddit from '@/models/wrappers/reddit/subreddit';
import { Heading } from './heading';
import { Feed } from './feed';

export const Show = ({ model } : { model: Subreddit }) => {
    return (
        <>
            <Feed model={model} />
        </>
    );
}