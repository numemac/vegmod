export interface Inspect {
    model: string;
    id: number | null;
    association: string | null;
    data: InspectRecord | InspectRecord[];
}

export interface InspectSingle {
    model: string;
    id: number;
    association: string | null;
    data: InspectRecord;
}

export interface InspectIndex {
    model: string;
    id: null;
    association: string | null;
    data: InspectRecord[];
}

export interface InspectRecord {
    id: number;
    attributes: { [key: string]: any };
    belongs_to: { [key: string]: InspectRecord };
    columns: { [key: string]: string };
    has_many: { [key: string]: InspectHasMany };
    has_one: { [key: string]: InspectRecord };
    href: InspectHref;
    label: string;
    model: string;
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