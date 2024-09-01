import React from 'react';
import { LabeledHref } from '@/types/href';
import { Pagination } from '@/types/pagination';
import { Paginate } from '@/components/paginate';

export const InspectLayout = ({ hierarchy, apiEndpoint, pagination, children } : { hierarchy: LabeledHref[], pagination: Pagination, apiEndpoint: string, children: React.ReactNode }) => {
    return (
        <>
            <Paginate pagination={pagination}>
                {children}
            </Paginate>
        </>

    );
};