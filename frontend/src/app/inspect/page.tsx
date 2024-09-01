"use client";

import React, { Context } from "react";
import { useContext } from "react";
import { useSearchParams, ReadonlyURLSearchParams } from "next/navigation";

import { ProgramNavigationContext } from "@/components/sidebar_container";

import { InspectShow, InspectIndex } from "@/types/inspect";
import { InspectIndexPage } from "@/components/inspect/index";
import { InspectShowPage } from "@/components/inspect/show";

import humanizeString from "humanize-string";

const nullIfEmpty = (str : string | null) => {
    if (str === null) {
        return null;
    }
    return str === '' ? null : str;
}

export default function Page() {

    const searchParams : ReadonlyURLSearchParams = useSearchParams();
    const setProgramNavigation : any = useContext(ProgramNavigationContext);

    // /inspect?model=subreddits&id=2&association=comments
    // all params are strings but can be null
    const model = searchParams.get('model') || 'reddit/subreddits';
    const id = model ? searchParams.get('id') : null;
    const association = id ? nullIfEmpty(searchParams.get('association')) : null;
    const page = searchParams.get('page') || '1';
    const measure = searchParams.get('measure') || '';
    const unit = searchParams.get('unit') || '';
    const interval = searchParams.get('interval') || '';

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
        params.append('measure', measure || '');
        params.append('unit', unit || '');
        params.append('interval', interval || '');
        return `${'/inspect.json'}?${params.toString()}`;
    }

    const buildTabs = (data : any) => {
        if (data['type'] === 'InspectIndex') {
            const inspectIndex : InspectIndex = data;
            return [
                {
                    label: 'Index',
                    href: { query: { model: inspectIndex.model, id: null, association: null }},
                    count: null,
                    current: true
                }
            ];
        } else if (data['type'] === 'InspectShow') {
            const inspectShow : InspectShow = data;
            const overviewTab = {
                label: 'Overview',
                href: { query: { model: inspectShow.model, id: inspectShow.id, association: null }},
                count: null,
                current: inspectShow.association === null
            };
            const associationTabKeys = Object.keys(inspectShow.data.has_many || {});
            return [
                overviewTab,
                associationTabKeys.map(key => {
                    const value = inspectShow.data.has_many[key];
                    return {
                        label: humanizeString(key),
                        href: { query: { model: inspectShow.model, id: inspectShow.id, association: key }},
                        count: value.count,
                        current: inspectShow.association === key
                    }
                }),
            ].flat().sort(
                // Overview tab should always be first, then sort alphabetically
                (a, b) => a.label === 'Overview' ? -1 : a.label.localeCompare(b.label)
            );
        } else {
            throw new Error(`Unknown type ${data['type']}`);
        }
    }

    // data.models
    // each item is like reddit/comments
    // for the label, split on / and take the last element
    // for the href, set model to the item, id to null, and association to null
    const buildSelect = (data : any) => {
        return data.models.map((model : string) => {
            return {
                label: humanizeString(model.split('/')[1]),
                href: `/inspect?model=${model}`,
                current: model === data.model && !data.id && !data.association
            }
        });
    }

    const buildTitle = (data : any) => {
        if (data['type'] === 'InspectIndex') {
            const inspectIndex : InspectIndex = data;
            return humanizeString(inspectIndex.model.split('/')[1]);
        } else if (data['type'] === 'InspectShow') {
            const inspectShow : InspectShow = data;
            return inspectShow.data.label;
        } else {
            throw new Error(`Unknown type ${data['type']}`);
        }
    }

    React.useEffect(() => {
        fetch(apiEndpoint())
        .then((res) => res.json())
        .then((data : InspectShow | InspectIndex) => {
            setData(data);
            setProgramNavigation({
                title: buildTitle(data),
                tabs: buildTabs(data),
                select: {
                    label: 'Return to Index',
                    options: buildSelect(data)
                }
            });
        })
        .catch((err) => {
            setError(err);
        });
    }, [searchParams]);

    if (!_data || !_data['type']) {
        return <p>Loading...</p>;
    }

    if (error) {
        return <p>Error: {error.message} | {setProgramNavigation.toString()}</p>;
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