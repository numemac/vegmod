import React from 'react';

import { InspectHref, InspectRecord, InspectSingle } from '@/types/inspect';
import { StackedList } from './stacked_list';

export const RestAssociation = ({ inspect }: { inspect: InspectSingle }) => {
    const { has_many } = inspect.data;

    if (!inspect.association) {
        return null;
    }

    if (!has_many || !has_many[inspect.association]) {
        return <span>Loading...</span>
    }

    // ensure that records is not an empty object
    if (Object.keys(has_many[inspect.association].records).length === 0) {
        return null;
    }

    const records : InspectRecord[] = has_many[inspect.association].records as InspectRecord[];

    const items : { id: number, title: string, titleHref: InspectHref, subtitle: string, subtitleHref: InspectHref }[] = records.map((childRecord: InspectRecord) => {
        return {
            id: childRecord.id,
            title: childRecord.label,
            titleHref: childRecord.href,
            subtitle: inspect.data.label,
            subtitleHref: inspect.data.href,
        }
    });

    return <StackedList items={items} />;
};