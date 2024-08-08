import { InspectHref } from '@/types/inspect';
import Link from 'next/link';
import React from 'react';

export const StackedList = ({ items } : { items: { id: number, title: string, titleHref: InspectHref, subtitle: string, subtitleHref: InspectHref }[] }) => {

    const truncate = (str: string, n: number) => {
        if (!str) {
            return '';
        }

        return str.length > n ? str.substring(0, n - 1) + '...' : str;
    }

    return (
        <ul role="list" className="divide-y divide-gray-100">
            {items.map((item) => (
                <li
                    key={item.id}
                    className="flex flex-wrap items-center justify-between gap-x-6 gap-y-4 py-5 sm:flex-nowrap"
                >
                    <div>
                        <Link href={item.titleHref}  className="text-sm font-semibold leading-6 text-gray-900 hover:underline">
                                {truncate(item.title, 100)}                            
                        </Link>
                        <div className="mt-1 flex items-center gap-x-2 text-xs leading-5 text-gray-500">
                            <p>
                                <Link href={item.subtitleHref} className="hover:underline">
                                    {truncate(item.subtitle, 30)}
                                </Link>
                            </p>
                        </div>
                    </div>
                </li>
            ))}
        </ul>
    );
}