import { InspectMetric } from "../../types/inspect";
import { Metric } from "@/components/inspect/metric";
import Link from "next/link";

import { Dropdown } from "flowbite-react";

export const MetricBrowser = ({ model, id, metrics }: { model: string, id: number, metrics : InspectMetric[] }) => {

    const selectedMetric = (metrics: InspectMetric[]) => {
        if (metrics.length === 0) {
            return null;
        }

        const firstWithDataPoints = metrics.find(metric => metric.data_points.length > 0);
        if (firstWithDataPoints) {
            return firstWithDataPoints;
        }

        return metrics[0];
    }

    const selected = selectedMetric(metrics);
    if (!selected) {
        return <>No metrics available</>
    }

    const buildHref = (query : {}) => {
        return "/inspect?" + new URLSearchParams(query).toString();
    }

    // unique measure values from all metrics
    const measureOptions = metrics.map(metric => metric.measure).filter((value, index, self) => self.indexOf(value) === index);

    // unique unit values from all metrics
    const unitOptions = metrics.map(metric => metric.unit).filter((value, index, self) => self.indexOf(value) === index);

    // unique interval values from all metrics
    const intervalOptions = metrics.map(metric => metric.interval.toString()).filter((value, index, self) => self.indexOf(value) === index);

    const renderOptions = (options: string[], label: string, queryKey: string, humanizeFunction = humanizeString) => {
        let baseQuery = {
            model: model,
            id: id,
            association: null,
            measure: selected.measure,
            unit: selected.unit,
            interval: selected.interval.toString()
        }
        return (
            <Dropdown label={humanizeFunction(label)}>
                { options.filter(option => option !== label).map(option => {
                    return (
                        /* ignore type warning */
                        <Dropdown.Item key={option} as={Link} href={buildHref({ ...baseQuery, [queryKey]: option })}>
                            { humanizeFunction(option) }
                        </Dropdown.Item>
                    );
                }) }
            </Dropdown>
        );
    }

    const linkHref = (measure: string, unit: string, interval: string) => {
        return {
            query: {
                model: model,
                id: id,
                association: "",
                measure: measure,
                unit: unit,
                interval: interval,
            }
        }
    }

    const humanizeValue = (value: number) => {
        // if value is .00, return it as integer
        if (value % 1 === 0) {
            return parseInt(value.toString());
        }

        return value.toFixed(2);
    }

    const humanizeString = (str: string) => {
        return str.replace(/_/g, " ");
    }

    const intervalToPeriod = (interval: number | string) => {
        interval = parseInt(interval.toString());

        if (interval === 31556952) {
            return "year";
        }

        if (interval === 2629746) {
            return "month";
        }

        if (interval === 604800) {
            return "week";
        }

        if (interval === 86400) {
            return "day";
        }

        if (interval === 3600) {
            return "hour";
        }

        if (interval === 60) {
            return "minute";
        }
    }

    const humanizeInterval = (interval: number | string, pluralize = true) => {
        return intervalToPeriod(interval) + (pluralize ? "s" : "");
    }

    const displayValue = () => {
        if (selected.data_points.length === 0) {
            return "N/A";
        }

        return humanizeValue(selected.data_points[selected.data_points.length - 1].value);
    }

    return (
        <div className="max-w-sm w-full bg-white rounded-lg shadow">
            <div className="flex justify-between p-3">
                <div>
                <h5 className="leading-none text-3xl font-bold text-gray-900 dark:text-white pb-2">{displayValue()}</h5>
                <p className="text-base font-normal text-gray-500 dark:text-gray-400">{selected.measure} {humanizeString(selected.unit)} in the prior {humanizeInterval(selected.interval, false)}</p>
                </div>
            </div>
            <Metric metric={selected} />
            <div className="flex items-center gap-4 border-gray-200 border-t p-3">
                { renderOptions(measureOptions, selected.measure, 'measure') }
                { renderOptions(unitOptions, selected.unit, 'unit') }
                { renderOptions(intervalOptions, selected.interval.toString(), 'interval', humanizeInterval) }
            </div>
        </div>
    );
}