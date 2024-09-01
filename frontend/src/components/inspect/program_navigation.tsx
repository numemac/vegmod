import React from 'react'
import { NavigationTab, NavigationSelect } from '@/types/navigation'
import Link from 'next/link'

export const ProgramNavigation = ({ select, tabs }: { select: NavigationSelect | null, tabs: NavigationTab[] }) => {

    function classNames(...classes : any) {
        return classes.filter(Boolean).join(' ')
    }

    const selectBox = () => {
        if (select === null || select === undefined) {
            return null
        }

        return (
            <div className="hidden lg:block">
                <label htmlFor="tabs" className="sr-only">{select.label}</label>
                <select
                    id="tabs"
                    name="tabs"
                    className="block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-md"
                    onChange={(e) => {
                        const href = e.target.value
                        window.location.href = href
                    }}
                >
                    <option key={select.label} value="#">
                        {select.label}
                    </option>
                    {select.options.map((option : any) => (
                        <option key={option.label} selected={option.current} value={option.href}>
                            {option.label}
                        </option>
                    ))}
                </select>
            </div>
        )
    }
        

    const mobileNavigation = () => {
        return tabs.map((tab : any) => (
            <li key={tab.label} className="lg:hidden">
                <Link
                    href={tab.href}
                    className={classNames(
                        tab.current
                        ? 'bg-gray-800 text-white'
                        : 'text-gray-400 hover:bg-gray-800 hover:text-white',
                        'group flex gap-x-3 rounded-md p-2 text-sm font-semibold leading-6',
                    )}
                >
                    <span className="truncate">{tab.label}</span>
                    {tab.count !== null ? ( <span>{tab.count}</span> ) : null}
                </Link>
            </li>
        ))
    }

    const desktopNavigation = () => {
        const selectListItem : any = (
            <li className="hidden lg:block">
                {selectBox()}
            </li>
        )

        const tabListItems : any[] = tabs.map((tab : any) => (
            <li key={tab.label} className="hidden lg:block">
                <Link
                    href={tab.href}
                    className={classNames(
                    tab.current
                    ? 'bg-gray-800 text-white hover:text-gray-200'
                    : 'text-gray-400 hover:bg-gray-800 hover:text-white',
                    'group flex gap-x-3 rounded-md p-2 text-sm font-semibold leading-6',
                )}
                >
                    <span className="flex flex-1 justify-between">
                        <span className="truncate flex">
                            {tab.label}
                        </span>
                        {tab.count !== null ? (
                            <span
                                className={classNames(
                                tab.current ? 'text-indigo-300' : 'text-gray-300',
                                'flex-shrink-0 items-end'
                                )}
                            >
                                {tab.count}
                            </span>
                        ) : null}
                    </span>
                </Link>
            </li>
        ))

        const listItems : any[] = [selectListItem, tabListItems].flat()

        return listItems
    }

    return (
        <>
            {mobileNavigation()}
            {desktopNavigation()}
        </>
    )
}