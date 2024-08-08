import React from 'react';
import Link from 'next/link';
import { DescriptionList } from '@/components/description_list';
import { InspectSingle, InspectRecord } from '@/types/inspect';

export const InspectOverview = ({ inspect } : { inspect: InspectSingle }) => {
    const inspectRecord : InspectRecord = inspect.data;
    const onPage = inspect.model == inspectRecord.model && inspect.id == inspectRecord.id && !inspect.association;

    const formatValue = (str: any, n: number) => {
        if (str === null || str === undefined) {
            return 'None';
        }
        if (typeof str === 'number') {
            return str;
        }
        if (str === true) {
            return 'True';
        }
        if (str == false) {
            return 'False';
        }
        return (str.length > n) ? str.substring(0, n - 1) + '...' : str;
    }

    const wrapValue = (attribute: string, value: any) => {
        if (value === null || value === undefined) {
            return value;
        }

        if (attribute == 'permalink') {
            return <Link href={`https://www.reddit.com${value}`}>{value}</Link>;
        } else if (attribute == 'url') {
            return <Link href={`${value}` || "#"}>{value}</Link>;
        } else if (attribute.endsWith('_utc')) {
            return new Date(value * 1000).toLocaleString();
        }
        return value;
    }

    const href = {
        query: { 
            model: inspectRecord.model, 
            id: inspectRecord.id, 
            association: null 
        }
    };

    const attributeItems = () => {
        if (!inspectRecord.attributes) {
            return [];
        }

        return Object.keys(inspectRecord.attributes).map(key => {
            const value = inspectRecord.attributes[key];
            return {
                key: key,
                value: wrapValue(key, formatValue(value, 300)),
                action: <></>
            }
        }
        ).map((item: any) => {
            return !onPage && item.key == 'id' ? {
                key: item.key,
                value: item.value,
                action: <Link href={href}>View</Link>
            } : item;
        });
    }

    const allItems = [
        attributeItems(),
    ].flat().filter(
        (item: any) => item != null
    )

    const prettyItems = allItems.filter(
        (item: any) => {
            if (item.key.endsWith('_id')) {
                // don't show foreign keys if
                // there is a link included in the list
                // e.g. if redditor is included, don't show redditor_id
                return !allItems.some(
                    (other: any) => other.key == item.key.replace('_id', '')
                )
            }

            return true;
        }
    ).sort(
        // id should be the first item then alphabetical order
        (a: any, b: any) => a.key == 'id' ? -1 : a.key.localeCompare(b.key)
    )

    return (
        <>
            <DescriptionList
                items={prettyItems}
            />
        </>
    );
};