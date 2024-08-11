import React from 'react';

import humanizeString from 'humanize-string';

export const RainbowBadge = ({ text }: { text: string }) => {
    const pill = <span className="inline-flex items-center text-xs font-medium px-1">{humanizeString(text)}</span>;

    const colorClasses = [
        "bg-gray-100 text-gray-700",
        "bg-red-100 text-red-700",
        "bg-orange-100 text-orange-700",
        "bg-amber-100 text-amber-700",
        "bg-yellow-100 text-yellow-700",
        "bg-lime-100 text-lime-700",
        "bg-green-100 text-green-700",
        "bg-emerald-100 text-emerald-700",
        "bg-teal-100 text-teal-700",
        "bg-cyan-100 text-cyan-700",
        "bg-sky-100 text-sky-700",
        "bg-blue-100 text-blue-700",
        "bg-indigo-100 text-indigo-700",
        "bg-violet-100 text-violet-700",
        "bg-purple-100 text-purple-700",
        "bg-fuchsia-100 text-fuchsia-700",
        "bg-pink-100 text-pink-700",
        "bg-rose-100 text-rose-700"
    ];

    const charCode = text.length > 0 ? text.charCodeAt(0) : 0;
    const colorClass = colorClasses[charCode % colorClasses.length];

    return <span className={`rounded-full px-1.5 py-0.5 ${colorClass}`}>{pill}</span>;
};