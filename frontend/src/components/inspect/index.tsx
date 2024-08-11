import React from 'react';
import { InspectIndex, InspectRecord, InspectHref } from '@/types/inspect';
import { StackedList } from '@/components/stacked_list';
import { Paginate } from '@/components/paginate';
import { InspectLayout } from './layout';
import humanizeString from 'humanize-string';

export const InspectIndexPage = ({ inspect } : { inspect: InspectIndex }) => {
    const entries : InspectRecord[] = inspect.entries as InspectRecord[];

    if (!entries || !Array.isArray(entries)) {
        return <>Loading...</>
    }

    const items : { id: number, title: string, titleHref: InspectHref, subtitle: string, subtitleHref: InspectHref | null, imageUrl : string | null }[] = entries.map((childRecord: InspectRecord) => {
        return {
            id: childRecord.id,
            title: childRecord.label,
            titleHref: childRecord.href,
            subtitle: childRecord.detail_label,
            subtitleHref: childRecord.detail_href,
            imageUrl: childRecord.image_url
        }
    });

    const hierarchy = [
        {
            label: humanizeString(inspect.model.split('/')[1]),
            href: {
                pathname: '/inspect',
                query: {
                    model: inspect.model,
                    id: null,
                    association: null
                }
            }
        }
    ];

    return (
        <InspectLayout hierarchy={hierarchy} apiEndpoint={inspect.apiEndpoint} pagination={inspect.pagination}>
            <StackedList items={items} />
        </InspectLayout>
    );
};