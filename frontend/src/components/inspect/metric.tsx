
import { InspectMetric } from "@/types/inspect";
import { ApexOptions } from "apexcharts";
import React, { Component } from "react";
import Chart from "react-apexcharts";

export const Metric = ({ metric }: { metric : InspectMetric }) => {

    const humanizeXAxis = (interval: number, intervalStart: string) => {
        const date = new Date(intervalStart);

        if (interval % 31556952 === 0) {
            return date.getUTCFullYear();
        }

        if (interval % 2629746 === 0) {
            return date.toLocaleString('default', { month: 'short' });
        }

        if (interval % 86400 === 0) {
            return `${date.getUTCDate()} ${date.toLocaleString('default', { month: 'short' })}`;
        }

        // now fix 17:0 UTC -> 17:00 UTC
        const hourMinute = `${date.getUTCHours() < 10 ? '0' + date.getUTCHours() : date.getUTCHours()}:${date.getUTCMinutes() < 10 ? '0' + date.getUTCMinutes() : date.getUTCMinutes()} UTC`;

        if (interval % 3600 === 0) {
            return hourMinute;
        }

        // 14 Mar, 14:00 UTC
        return `${date.getUTCDate()} ${date.toLocaleString('default', { month: 'short' })}, ${hourMinute}`;
    }

    const options : ApexOptions = {
        chart: {
            type: "bar",
            height: "320px",
            fontFamily: "Inter, sans-serif",
            toolbar: {
                show: false,
            },
        },
        plotOptions: {
            bar: {
                horizontal: false,
                columnWidth: "70%",
                borderRadiusApplication: "end",
                borderRadius: 8,
            },
        },
        tooltip: {
            shared: true,
            intersect: false,
            style: {
                fontFamily: "Inter, sans-serif",
            },
        },
        states: {
            hover: {
                filter: {
                    type: "darken",
                    value: 1,
                },
            },
        },
        stroke: {
            show: true,
            width: 0,
            colors: ["transparent"],
        },
        grid: {
            show: false,
            strokeDashArray: 4,
            padding: {
                left: 2,
                right: 2,
                top: -14
            },
        },
        dataLabels: {
            enabled: false,
        },
        legend: {
            show: false,
        },
        xaxis: {
            floating: false,
            labels: {
                show: true,
                style: {
                    fontFamily: "Inter, sans-serif",
                    cssClass: 'text-xs font-normal fill-gray-500 dark:fill-gray-400'
                }
            },
            axisBorder: {
                show: false,
            },
            axisTicks: {
                show: false,
            },
            categories: metric.data_points.map(data_point => humanizeXAxis(metric.interval, data_point.interval_start))
        },
        yaxis: {
            show: false,
        },
        fill: {
            opacity: 1,
        },
    }
    
    const series = [
        {
            name: metric.unit,
            data: metric.data_points.map(data_point => data_point.value)
        }
    ]


    return (
        <Chart
            options={options}
            series={series}
            type="bar"
            width="384"
        />
    );
}
