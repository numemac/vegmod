"use client";

import { Detail, Subtitle } from '@/components/font';
import MetricSubject from '@/models/wrappers/metrics/metric_subject';

import { ApexOptions } from "apexcharts";
import React from "react";
import ApexChart from "react-apexcharts";

export const Chart = ({ model, timeSelector } : { model: MetricSubject, timeSelector: JSX.Element }) => {

    // if (!model.dataPoints) {
    //     return <p>Loading...</p>
    // }

    const series = model.dataPoints ? [
        {
            name: model.metric.unit,
            data: model.dataPoints.map(dataPoint => {
                return {
                    x: dataPoint.intervalStart,
                    y: dataPoint.value
                }
            })
        }
    ] : [];

    const timeRange = () => {
        if (!model.dataPoints || model.dataPoints.length === 0) {
            return "From";
        }

        const times = [
            model.dataPoints[0].intervalStart,
            model.dataPoints[model.dataPoints.length - 1].intervalStart
        ].map((pole) => new Date(pole).getTime()).sort((a, b) => a - b);

        return "From " + new Date(times[0]).toLocaleDateString('default', { timeZone: 'UTC' }) + " to " + new Date(times[1]).toLocaleDateString('default', { timeZone: 'UTC' });
    }

    const options : ApexOptions = {
        chart: {
            toolbar: {
                show: true,
                tools: {
                    zoomin: true,
                    zoomout: true,
                    pan: true,
                },
            },
        },
        xaxis: {
            type: 'datetime',
        },
        stroke: {
            width: 3,
        },
    };

    const subtitle = model.metric.measure.charAt(0).toUpperCase() + model.metric.measure.slice(1) + " " + model.metric.unit;

    return (
        <div>
            <Subtitle>
                {subtitle}
            </Subtitle>
            {timeSelector}
            <Detail>{timeRange()}</Detail>
            <ApexChart
                options={options}
                series={series}
                type="line"
                width="340"
                height="170"
            />
        </div>
    );
}