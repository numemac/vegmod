"use client";

import React from "react";
import { useSearchParams, ReadonlyURLSearchParams } from "next/navigation";

import { InspectShow, InspectIndex } from "@/types/inspect";
import { InspectIndexPage } from "@/components/inspect";
import { InspectShowPage } from "@/components/inspect/show";

const nullIfEmpty = (str : string | null) => {
    if (str === null) {
        return null;
    }
    return str === '' ? null : str;
}

export default function Page() {

    const searchParams : ReadonlyURLSearchParams = useSearchParams();

    // /inspect?model=subreddits&id=2&association=comments
    // all params are strings but can be null
    const model = searchParams.get('model') || 'reddit/subreddits';
    const id = model ? searchParams.get('id') : null;
    const association = id ? nullIfEmpty(searchParams.get('association')) : null;
    const page = searchParams.get('page') || '1';

    if (Array.isArray(model)) {
        throw new Error("Array model is not supported");
    }

    if (Array.isArray(id)) {
        throw new Error("Array id is not supported");
    }

    if (id && isNaN(parseInt(id))) {
        throw new Error("id should be a number");
    }

    if (association && Array.isArray(association)) {
        throw new Error("Array association is not supported");
    }

    const [_data, setData] : [InspectShow | InspectIndex | null, any] = React.useState(null);
    const [error, setError] : [any, any] = React.useState(null);

    const apiEndpoint = () => {
        const params = new URLSearchParams();
        params.append('model', model || '');
        params.append('id', id || '');
        params.append('association', association || '');
        params.append('page', page || '');
        return `${'/inspect.json'}?${params.toString()}`;
    }

    React.useEffect(() => {
        fetch(apiEndpoint())
        .then((res) => res.json())
        .then((data : InspectShow | InspectIndex) => {
            setData(data);
        })
        .catch((err) => {
            setError(err);
        });
    }, [searchParams]);

    if (!_data || !_data['type']) {
        return <p>Loading...</p>;
    }

    if (error) {
        return <p>Error: {error.message}</p>;
    }

    const inspectData : InspectShow | InspectIndex = _data;

    if (inspectData['type'] === 'InspectIndex') {
        const inspectIndex : InspectIndex = inspectData;
        return <InspectIndexPage inspect={inspectIndex} />
    } else if (inspectData['type'] === 'InspectShow') {
        const inspectShow : InspectShow = inspectData;
        return <InspectShowPage inspect={inspectShow} />
    } else {
        throw new Error(`Unknown type ${inspectData['type']}`);
    }
}