import { InspectHref } from '@/types/inspect';
import Link from 'next/link';
import React from 'react';

export const StackedList = ({ items } : { items: { id: number, title: string, titleHref: InspectHref, subtitle: string, subtitleHref: InspectHref | null, imageUrl: string | null }[] }) => {

    const truncate = (str: string, n: number) => {
        if (!str) {
            return '';
        }

        return str.length > n ? str.substring(0, n - 1) + '...' : str;
    }

    const image = (item: { id: number, title: string, titleHref: InspectHref, subtitle: string, subtitleHref: InspectHref | null, imageUrl: string | null }) => {
        if (item.imageUrl) {
            return <Link href={item.imageUrl}>
                <img alt="" src={item.imageUrl} className="h-12 w-12 flex-none rounded-full bg-gray-50" />
            </Link>;
        }

        const placeholderText = item.title && item.title.length > 0 ? item.title.charAt(0).toUpperCase() : '?';

        // return a red circle with the first letter of the title capitalized
        return <div className="h-12 w-12 flex-none rounded-full bg-gray-500 text-white text-xl font-bold flex items-center justify-center">
            {placeholderText}
        </div>;
    }

    return (
        <ul role="list" className="divide-y divide-gray-100">
            {items.map((item) => (
                <li
                    key={item.id}
                    className="flex flex-wrap items-center justify-between gap-x-6 gap-y-4 py-5 sm:flex-nowrap"
                >
                    <div className="flex min-w-0 gap-x-4">
                        {image(item)}
                        
                        <div className="min-w-0 flex-auto">
                            <Link href={item.titleHref}  className="text-sm font-semibold leading-6 text-gray-900 hover:underline">
                                    {truncate(item.title, 100)}                            
                            </Link>
                            <div className="mt-1 flex items-center gap-x-2 text-xs leading-5 text-gray-500">
                                <p>
                                    {
                                        item.subtitleHref === null ? (
                                            <span>{truncate(item.subtitle, 50)}</span>
                                        ) : (
                                            <Link href={item.subtitleHref} className="hover:underline">
                                                <span>{truncate(item.subtitle, 50)}</span>
                                            </Link>
                                        )
                                    }
                                </p>
                            </div>
                        </div>
                    </div>
                </li>
            ))}
        </ul>
    );
}