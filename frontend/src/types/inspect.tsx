import { Pagination } from './pagination';

export interface InspectIndex {
    apiEndpoint: string;
    type: string;
    entries: InspectRecord[];
    model: string;
    pagination: Pagination;
    models: string[];
}

export interface InspectShow {
    apiEndpoint: string;
    type: string
    model: string;
    id: number | null;
    association: string | null;
    data: InspectRecord;
    pagination: Pagination;
}
export interface InspectRecord {
    id: number;
    attributes: { [key: string]: any };
    belongs_to: { [key: string]: InspectRecord };
    columns: { [key: string]: string };
    detail_href: InspectHref | null;
    detail_label: string;
    has_many: { [key: string]: InspectHasMany };
    has_one: { [key: string]: InspectRecord };
    metrics: InspectMetric[];
    href: InspectHref;
    label: string;
    model: string;
    image_url: string | null;
    external_url: string | null;
}

export interface InspectHref {
    pathname: string;
    query: {
        model: string;
        id: number | null;
        association: string | null;
    }
}

export interface InspectHasMany {
    label: string;
    href: InspectHref;
    model: string;
    count: number;
    records: InspectRecord[] | {};
}

export interface InspectMetric {
    measure: string;
    unit: string;
    interval: number;
    data_points: InspectMetricDataPoint[];
}

export interface InspectMetricDataPoint {
    interval_start: string;
    value: number;
}