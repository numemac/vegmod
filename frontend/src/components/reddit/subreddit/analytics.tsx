"use client";

import Subreddit from '@/models/wrappers/reddit/subreddit';
import { Chart } from '@/components/reddit/analytics/chart';
import { Title } from '@/components/font';
import { useState } from 'react';
import { Separator } from '@/components/form';

export const SubredditAnalytics = ({ model } : { model: Subreddit }) => {

    // measure-unit: interval, e.g. new-comments: 3600, default to daily
    const [view, setView] = useState({} as { [key: string]: number | string });

    if (!model.metricSubjects) {
        return <div className="min-h-[300px]">Loading...</div>
    }

    const viewLabels = {
        // 3600: "Hourly",
        // 86400: "Daily",
        // 604800: "Weekly",
        // 2629746: "Monthly",
        "Hourly": 3600,
        "Daily": 86400,
        "Weekly": 604800,
        "Monthly": 2629746
    } as { [key: string]: number };

    const renderChart = (measure: string, unit: string) => {

        const key = `${measure}-${unit}`;
        if (!view[key]) {
            setView({ ...view, [key]: "Daily" });
        }

        const metric = model.metricSubjects.find(
            metricSubject => metricSubject.metric.measure === measure &&
            metricSubject.metric.unit === unit &&
            metricSubject.metric.interval === viewLabels[view[key]]
        );

        if (!metric) {
            return <p>Loading {measure} {unit}...</p>
        }

        const timeSelector = () => {
            return (
                <div className="flex space-x-2">
                    {
                        Object.entries(viewLabels).map(([label, interval]) => {
                            const selected = view[`${measure}-${unit}`] === label;

                            return (
                                <button key={interval} onClick={() => setView({ ...view, [key]: label })} className={selected ? "border-b-2 border-blue-500" : "border-b-2 border-transparent hover:border-blue-200"}>
                                    {label}
                                </button>
                            )
                        })
                    }
                </div>
            )
        }

        return (
            <div className="min-h-[300px]">
                <Chart model={metric} timeSelector={timeSelector()} />
            </div>
        )
    }

    return (
        <>
            <Title>
                {'Analytics for r/' + model.displayName}
            </Title>

            <Separator />

            {renderChart("new", "comments")}
            {renderChart("new", "submissions")}
            {renderChart("new", "redditors")}
            {renderChart("delta", "score")}
        </>
    );
}