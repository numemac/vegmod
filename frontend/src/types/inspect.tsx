import { Pagination } from './pagination';

export interface InspectIndex {
    apiEndpoint: string;
    type: string;
    entries: InspectRecord[];
    model: string;
    pagination: Pagination;
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
    href: InspectHref;
    label: string;
    model: string;
    image_url: string | null;
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