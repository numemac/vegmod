import React from 'react';

import humanizeString from 'humanize-string';
import { RainbowBadge } from './rainbow_badge';

export const Stat = ({ text, value }: { text: string, value: number }) => {

    const formatValue = (text: string, value: number) => {
        if (!value) {
            return '0';
        }

        if (text.endsWith('_utc')) {
            return new Date(value * 1000).toLocaleString();
        }

        // add commas to separate thousands
        return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    return <RainbowBadge text={`${humanizeString(text)}: ${formatValue(text, value)}`} />;
}