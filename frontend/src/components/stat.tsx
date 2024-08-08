import React from 'react';

import humanizeString from 'humanize-string';

export const Stat = ({ text, value }: { text: string, value: number }) => {

    const formatValue = (value: number) => {
        if (!value) {
            return '0';
        }

        // add commas to separate thousands
        return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    return (
        <div
            key={text}
            className="flex-col text-center py-8"
        >
            <div className="text-sm">
                <span>{text}</span>
            </div>
            <div className="text-xl font-semibold">
                <span>{formatValue(value)}</span>
            </div>
        </div>
    );
}