import { Tabs } from '@/components/tabs';
import humanizeString from 'humanize-string';

import { InspectShow } from '@/types/inspect';

import Link from 'next/link';

export const RestTabs = ({ inspect } : { inspect: InspectShow }) => {  
    
    if (inspect.id === null) {
        return null;
    }

    const overviewTab = {
        name: 'Overview',
        href: { query: { model: inspect.model, id: inspect.id, association: null }},
        count: null,
        current: inspect.association === null
    };

    const associationTabKeys = Object.keys(inspect.data.has_many || {});
    
    const tabs = [
        overviewTab,
        associationTabKeys.map(key => {
            const value = inspect.data.has_many[key];
            return {
                name: humanizeString(key),
                href: { query: { model: inspect.model, id: inspect.id, association: key }},
                count: value.count,
                current: inspect.association === key
            }
        }),
    ].flat().sort(
        // Overview tab should always be first, then sort alphabetically
        (a, b) => a.name === 'Overview' ? -1 : a.name.localeCompare(b.name)
    );

    return (
        <Tabs tabs={tabs} />
    );
}