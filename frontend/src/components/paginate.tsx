import React, { use } from 'react';

import { Pagination } from '@/types/pagination';
import { LabeledHref } from '@/types/href';
import Link from 'next/link';
import { usePathname, useSearchParams } from 'next/navigation'
import { Url } from 'next/dist/shared/lib/router/router';

export const Paginate = ({ pagination, children} : { pagination: Pagination | null, children: React.ReactNode }) => {
    if (!pagination) {
        return children;
    }

    const pathname = usePathname();
    const searchParams = useSearchParams();
    const currentPage : number = Number(pagination.current_page || 1);

    const renderPageButton = (label : string, page: number | null, isCurrent: boolean) => {
        if (page === null) {
            return (
                <span className={`relative inline-flex items-center px-4 py-2 text-sm font-semibold ${isCurrent ? 'text-white bg-indigo-600' : 'text-gray-900 ring-1 ring-inset ring-gray-300'} focus:z-20 focus:outline-offset-0`}>
                    {label}
                </span>
            );
        }

        // Construct the query string
        const queryString = new URLSearchParams(searchParams);
        queryString.set('page', page.toString());

        // Add the current browser's query string to the URL
        searchParams.forEach((value, key) => {
            if (key === 'page') {
                return;
            }
            queryString.set(key, value);
        });

        const href : Url = { pathname: pathname, query: queryString.toString() };
        return (
            <Link
                href={href}
                className={`relative inline-flex items-center px-4 py-2 text-sm font-semibold ${isCurrent ? 'text-white bg-indigo-600' : 'text-gray-900 ring-1 ring-inset ring-gray-300 hover:bg-gray-50'} focus:z-20 focus:outline-offset-0`}
            >
                {label}
            </Link>
        );
    }

    const pageButtons = (total_pages: number) => {
        let list : React.ReactNode[] = [];
        
        if (currentPage > 1) {
            list.push(
                renderPageButton(
                    '1',
                    1,
                    false
                )
            );
        }

        if (currentPage > 2) {
            list.push(
                renderPageButton(
                    '...',
                    null,
                    false
                )
            );
        }

        if (currentPage > 2) {
            list.push(
                renderPageButton(
                    (currentPage - 1).toString(),
                    currentPage - 1,
                    false
                )
            );
        }

        list.push(
            renderPageButton(
                currentPage.toString(),
                null,
                true
            )
        );

        if (currentPage < total_pages - 1) {
            list.push(
                renderPageButton(
                    (currentPage + 1).toString(),
                    currentPage + 1,
                    false
                )
            );
        }

        if (currentPage < total_pages - 2) {
            list.push(
                renderPageButton(
                    '...',
                    null,
                    false
                )
            );
        }

        if (currentPage < total_pages) {
            list.push(
                renderPageButton(
                    total_pages.toString(),
                    total_pages,
                    false
                )
            );
        }

        return list;
    }

    const startIndex = (pagination.current_page - 1) * pagination.per_page;
    const endIndex = Math.min(pagination.current_page * pagination.per_page, pagination.total_entries);

    const paginationBar = (
        <div className="flex items-center justify-between border-t border-gray-200 bg-white px-4 py-3 sm:px-6 h-16">
            <div className="flex flex-1 items-center justify-between">
                <div className="hidden sm:flex">
                    <p className="text-sm text-gray-700">
                        Showing <span className="font-medium">{startIndex}</span> to <span className="font-medium">{endIndex}</span> of{' '}
                        <span className="font-medium">{pagination.total_entries}</span> results
                    </p>
                </div>
                <div className="flex-1 flex justify-center sm:justify-end">
                    <nav aria-label="Pagination" className="isolate inline-flex -space-x-px rounded-md shadow-sm">
                        {pageButtons(pagination.total_pages)}
                    </nav>
                </div>
            </div>
        </div>
    )

    return (
        <>
            <div>
                {children}
            </div>
            {pagination.total_pages === 1 ? null : paginationBar}
        </>
    )
}