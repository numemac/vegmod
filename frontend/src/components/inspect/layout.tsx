import React from 'react';

import Link from 'next/link';
import { RestBreadcrumb } from '@/components/rest_breadcrumb';

import { LabeledHref } from '@/types/href';
import { Pagination } from '@/types/pagination';
import { Paginate } from '@/components/paginate';

export const InspectLayout = ({ hierarchy, apiEndpoint, pagination, children } : { hierarchy: LabeledHref[], pagination: Pagination, apiEndpoint: string, children: React.ReactNode }) => {
    return (
        <>
            <div className="flex">
                <div className="flex-grow">
                    <RestBreadcrumb hierarchy={hierarchy} />
                </div>
                <Link href={apiEndpoint} className="text-sm flex-none my-auto">
                    <span>API Endpoint</span>
                </Link>
            </div>
            <Paginate pagination={pagination}>
                <main>
                    {children}
                </main>
            </Paginate>
        </>

    );
};