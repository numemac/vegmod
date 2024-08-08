"use client";

import React from "react";
import { useSearchParams, ReadonlyURLSearchParams } from "next/navigation";

import { Inspect, InspectRecord } from "@/types/inspect";
import { InspectPage } from "@/components/inspect_page";

import { validateInspectRecord } from "@/validators/inspect";

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
    const model = searchParams.get('model') || 'subreddits';
    const id = model ? searchParams.get('id') : null;
    const association = id ? nullIfEmpty(searchParams.get('association')) : null;

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

    const [_data, setData] : [InspectRecord | InspectRecord[] | null, any] = React.useState(null);
    const [error, setError] : [any, any] = React.useState(null);

    const apiEndpoint = () => {
        if (!id) {
            // index page
            return `/${model}.json`;
        }

        // show page
        let url = `/${model}/${id}.json`;

        if (association) {
            // show list of associated records
            url += `?association=${association}`;
        }

        return url;
    }

    React.useEffect(() => {
        fetch(apiEndpoint())
        .then((res) => res.json())
        .then((data) => {
            setData(data);
        })
        .catch((err) => {
            setError(err);
        });
    }, [searchParams]);

    if (!_data) {
        return <p>Loading...</p>;
    }

    const inspect : Inspect = { 
        model: model, 
        id: id ? parseInt(id) : null,
        association: association,
        data: _data 
    };

    return <>
        <p>{ error }</p>
        <InspectPage inspect={inspect} />
    </>
}