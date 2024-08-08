import React from 'react';

import { Inspect } from '@/types/inspect';
import { InspectIndex } from './inspect_index';

export const InspectModelPage = ({ inspect } : { inspect: Inspect }) => {
    return <InspectIndex inspect={inspect} />
};