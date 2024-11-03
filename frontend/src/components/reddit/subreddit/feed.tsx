"use client";

import { useState, useEffect } from 'react';

import { Heading } from '@/components/reddit/subreddit/heading';
import { Preview } from '@/components/reddit/submission/preview';

import Submission from '@/models/wrappers/reddit/submission';
import Subreddit from '@/models/wrappers/reddit/subreddit';

export const Feed = ({ model } : { model: Subreddit }) => {

    const [limit, setLimit] = useState(20);
    const [submissions, setSubmissions] : [Submission[], Function] = useState(model.get('submissions', 0, limit));

    useEffect(() => {
        model.onStateChanged(() => {
            setSubmissions(model.get('submissions', 0, limit));
        });
    }, [model]);

    const loadMore = () => {
        model.reload('submissions', 0, limit + 20);
        setLimit(limit + 20);
    }

    const loadMoreButton = () => {
        return <button onClick={loadMore}>Load More</button>
    }

    return (
        <>
            <Heading model={model} showDescription />
            <div className="flex flex-col gap-2">
                { submissions && submissions.map((submission : Submission) => {
                    return <div key={`submission-${submission.get('id')}`}>
                        <Preview model={submission} />
                    </div>
                }) }
                { loadMoreButton() }
            </div> 
        </>
    )
}