import React from 'react';
import Link from 'next/link';
import { LinkIcon } from '@heroicons/react/20/solid';
import humanizeString from 'humanize-string';

import { InspectHref } from '@/types/inspect';

export const LinkCard = ({ title, subtitle, href } : { title: string, subtitle: string, href: InspectHref | string }) => {
    return (
        <div
            key={title}
            className="relative flex items-center space-x-2 rounded-lg border border-gray-300 bg-white px-2 py-2 shadow-sm focus-within:ring-2 focus-within:ring-indigo-500 focus-within:ring-offset-2 hover:border-gray-400"
        >
            <div className="flex-shrink-0">
                <LinkIcon className="h-6 w-6 text-gray-400" aria-hidden="true" />
            </div>
            <div className="min-w-0 flex-1">
                <Link href={href} className="focus:outline-none">
                    <span aria-hidden="true" className="absolute inset-0" />
                    <p className="text-sm font-medium text-gray-900">{humanizeString(title)}</p>
                    <p className="truncate text-sm text-gray-500">{subtitle}</p>
                </Link>
            </div>
        </div>
    );
}