import React from 'react';
import Link from 'next/link';
import { HomeIcon } from '@heroicons/react/20/solid';
import { Inspect } from '@/types/inspect';

export const RestBreadcrumb = ({ inspect } : { inspect: Inspect }) => {
    const { model, id, data } = inspect;

    const truncate = (str: string, n: number) => {
        if (!str) return '';
        return (str.length > n) ? str.substring(0, n - 1) + '...' : str;
    }

    const breadcrumbHome = (
        <li>
            <div>
                <Link href="/inspect" className="text-gray-400 hover:text-gray-500">
                    <HomeIcon className="h-5 w-5 flex-shrink-0" />
                    <span className="sr-only">Home</span>
                </Link>
            </div>
        </li>
    );

    const slash = (
        <svg
            fill="currentColor"
            viewBox="0 0 20 20"
            aria-hidden="true"
            className="h-5 w-5 flex-shrink-0 text-gray-300"
        >
            <path d="M5.555 17.776l8-16 .894.448-8 16-.894-.448z" />
        </svg>        
    )

    const breadcrumbModel = (
        <li>
            <div className="flex items-center">
                {slash}
                <Link href={{ query: { model: model, id: null, association: null }}} className="ml-4 text-sm font-medium text-gray-500 hover:text-gray-700">
                    {model.charAt(0).toUpperCase() + model.slice(1)}
                </Link>
            </div>
        </li>
     )

    const breadcrumbRecord = data ? (
        <li>
            <div className="flex items-center">
                {slash}
                <Link href={{ query: { model: model, id: id, association: null }}} className="ml-4 text-sm font-medium text-gray-500 hover:text-gray-700">
                    {truncate(data.label, 20)}
                </Link>
            </div>
        </li>
     ) : null;
    
    return (
        <nav aria-label="Breadcrumb" className="flex py-4">
            <ol role="list" className="flex items-center space-x-4">
                {breadcrumbHome}
                {breadcrumbModel}
                {breadcrumbRecord}
            </ol>
        </nav>
    )
}