import React from 'react';

import { RestBreadcrumb } from '@/components/rest_breadcrumb';
import { Inspect } from '@/types/inspect';
import { InspectModelPage } from '@/components/inspect_model_page';
import { InspectRecordPage } from '@/components/inspect_record_page';


export const InspectPage = ({ inspect } : { inspect: Inspect }) => {
    return (
        <>
            <RestBreadcrumb inspect={inspect} />
            <main>
                {
                    inspect.id ? <InspectRecordPage inspect={inspect} /> : <InspectModelPage inspect={inspect} />
                }
            </main>
        </>
    );
};