'use client'

import { useEffect, useState } from 'react'
import { Dialog, DialogBackdrop, DialogPanel, TransitionChild } from '@headlessui/react'
import {
    Bars3Icon,
    EyeIcon,
    XMarkIcon,
} from '@heroicons/react/24/outline'

import { ProgramNavigation } from '@/components/inspect/program_navigation'
import { Navigation } from '@/types/navigation'

const navigation : {
        name: string;
        href: string;
        icon: any;
        current: boolean;
    }[] = [
    { 
        name: 'Inspect', 
        href: '/inspect', 
        icon: EyeIcon, 
        current: true 
    },
]

function classNames(...classes : any) {
    return classes.filter(Boolean).join(' ')
}

export const Sidebar = ({ programNavigation, children } : { programNavigation : Navigation, children: any }) => {
    const [sidebarOpen, setSidebarOpen] = useState(false)

    return (
        <>
            <div>
                <Dialog open={sidebarOpen} onClose={setSidebarOpen} className="relative z-50 lg:hidden">
                    <DialogBackdrop
                        transition
                        className="fixed inset-0 bg-gray-900/80 transition-opacity duration-300 ease-linear data-[closed]:opacity-0"
                    />

                    <div className="fixed inset-0 flex">
                        <DialogPanel
                            transition
                            className="relative mr-16 flex w-full max-w-xs flex-1 transform transition duration-300 ease-in-out data-[closed]:-translate-x-full"
                        >
                            <TransitionChild>
                                <div className="absolute left-full top-0 flex w-16 justify-center pt-5 duration-300 ease-in-out data-[closed]:opacity-0">
                                    <button type="button" onClick={() => setSidebarOpen(false)} className="-m-2.5 p-2.5">
                                        <span className="sr-only">Close sidebar</span>
                                        <XMarkIcon aria-hidden="true" className="h-6 w-6 text-white" />
                                    </button>
                                </div>
                            </TransitionChild>
                            {/* Sidebar component, swap this element with another sidebar if you like */}
                            <div className="flex grow flex-col gap-y-5 overflow-y-auto bg-gray-900 px-6 pb-2 ring-1 ring-white/10">
                                <nav className="flex flex-1 flex-col">
                                    <ul role="list" className="flex flex-1 flex-col gap-y-7">
                                        <li>
                                            <ul role="list" className="-mx-2 space-y-1">
                                                {navigation.map((item) => (
                                                    <li key={item.name}>
                                                        <a
                                                            href={item.href}
                                                            className={classNames(
                                                                item.current
                                                                    ? 'bg-gray-800 text-white'
                                                                    : 'text-gray-400 hover:bg-gray-800 hover:text-white',
                                                                'group flex gap-x-3 rounded-md p-2 text-sm font-semibold leading-6',
                                                            )}
                                                        >
                                                            <item.icon aria-hidden="true" className="h-6 w-6 shrink-0" />
                                                            {item.name}
                                                        </a>
                                                    </li>
                                                ))}
                                            </ul>
                                        </li>
                                        { programNavigation != null && (<li>
                                            <div className="text-xs font-semibold leading-6 text-gray-400 truncate">{programNavigation.title}</div>
                                            <ul role="list" className="-mx-2 mt-2 space-y-1">
                                                <ProgramNavigation tabs={programNavigation.tabs} />
                                            </ul>
                                        </li>)}
                                    </ul>
                                </nav>
                            </div>
                        </DialogPanel>
                    </div>
                </Dialog>

                {/* Static sidebar for desktop */}
                <div className="hidden lg:fixed lg:inset-y-0 lg:z-50 lg:flex lg:w-56 lg:flex-col">
                    {/* Sidebar component, swap this element with another sidebar if you like */}
                    <div className="flex grow flex-col gap-y-5 overflow-y-auto bg-gray-900 px-6">
                        <nav className="flex flex-1 flex-col">
                            <ul role="list" className="mt-16 flex flex-1 flex-col gap-y-7">
                                <li>
                                    <ul role="list" className="-mx-2 space-y-1">
                                        {navigation.map((item) => (
                                            <li key={item.name}>
                                                <a
                                                    href={item.href}
                                                    className={classNames(
                                                        item.current
                                                            ? 'bg-gray-800 text-white'
                                                            : 'text-gray-400 hover:bg-gray-800 hover:text-white',
                                                        'group flex gap-x-3 rounded-md p-2 text-sm font-semibold leading-6',
                                                    )}
                                                >
                                                    <item.icon aria-hidden="true" className="h-6 w-6 shrink-0" />
                                                    {item.name}
                                                </a>
                                            </li>
                                        ))}
                                    </ul>
                                </li>
                                {programNavigation != null && (<li>
                                    <div className="text-xs font-semibold leading-6 text-gray-400 truncate">{programNavigation.title}</div>
                                    <ul role="list" className="-mx-2 mt-2 space-y-1">
                                        <ProgramNavigation select={programNavigation.select} tabs={programNavigation.tabs} />
                                    </ul>
                                </li>)}
                            </ul>
                        </nav>
                    </div>
                </div>

                <div className="sticky top-0 z-40 flex items-center gap-x-6 bg-gray-900 px-4 py-4 shadow-sm sm:px-6 lg:hidden">
                    <button type="button" onClick={() => setSidebarOpen(true)} className="-m-2.5 p-2.5 text-gray-400 lg:hidden">
                        <span className="sr-only">Open sidebar</span>
                        <Bars3Icon aria-hidden="true" className="h-6 w-6" />
                    </button>
                    <div className="flex-1 text-sm font-semibold leading-6 text-white truncate">
                        { programNavigation.title ? programNavigation.title : "Loading" }
                    </div>
                </div>

                { programNavigation.title != null && (
                    <div className="hidden lg:block bg-gray-900 px-6 py-2 text-center">
                        <h1 className="ml-56 text-lg font-semibold text-white truncate">
                            {programNavigation.title}
                        </h1>
                    </div>                        
                )}

                <main className="py-10 lg:pl-56">
                    <div className="px-4 sm:px-6 lg:px-8">{ children }</div>
                </main>
            </div>
        </>
    )
}