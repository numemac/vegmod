import React from "react";

import Link from "next/link";

import { 
    NewspaperIcon,
    ArrowTrendingUpIcon,
    SparklesIcon,
    AdjustmentsHorizontalIcon,
    MagnifyingGlassIcon,
    UserCircleIcon
} from "@heroicons/react/24/outline";

import Session from "@/types/session";

import { useParams, usePathname } from "next/navigation"
import Subreddit from "@/models/wrappers/reddit/subreddit";

export const RedditLayout = ({ session, darkMode, children } : { session : Session | null, darkMode : boolean | null, children : any }) => {

    // if session is not null but session.user is null, redirect to sign-in
    if (session && !session.user) {
        window.location.href = "/auth/sign-in";
    }

    const params = useParams();

    const sortedSubreddits = session?.user ? (
        session.user.subreddits.sort(
        // sort by subscribers descending
        (a, b) => b.subscribers - a.subscribers
        )
    ) : [];

    const selectedSubreddit = params?.subreddit;

    const pathname = usePathname();

    const navigationTabs = () => {
        return (
            <div className="flex flex-col gap-4">
            {navigationTab(<NewspaperIcon className="w-full" title="Feed"/>, `/r/${selectedSubreddit}`, hrefIsCurrentPath)}

            {navigationTab(<ArrowTrendingUpIcon className="w-full" title="Analytics"/>, `/r/${selectedSubreddit}/analytics`, hrefIsCurrentPath)}

            {navigationTab(<SparklesIcon className="w-full" title="Plugins"/>, `/r/${selectedSubreddit}/plugins`, hrefIsCurrentPath)}

            {navigationTab(<AdjustmentsHorizontalIcon className="w-full" title="Settings"/>, `/r/${selectedSubreddit}/settings`, hrefIsCurrentPath)}

            {navigationTab(<MagnifyingGlassIcon className="w-full" title="Logs"/>, `/r/${selectedSubreddit}/logs`, hrefIsCurrentPath)}
        </div>
        )
    }

    const navigationTab = (icon : any, href : string, selected: Function) => {
        return (
            <Link href={href} key={`navigation-tab-${href}`}>
                <div className={`flex items-center p-1 rounded-md ${
                    selected(href) ? "bg-blue-600 dark:bg-blue-700 text-white" : "hover:bg-gray-100 dark:hover:bg-gray-900 text-gray-600"   
                }`}>
                    {icon}
                </div>
            </Link>
        )
    }

    const subredditTab = (subreddit : Subreddit) => {
        const selected = subreddit.displayName === selectedSubreddit;
        return (
            <Link href={`/r/${subreddit.displayName}`} key={`subreddit-tab-${subreddit.displayName}`}>
                <div className={`flex items-center w-8 h-8 rounded-full`}>
                    <img
                        title={`r/${subreddit.displayName}`}
                        src={subreddit.imageUrl} 
                        className={`${ selected ? 'w-8 h-8' : 'w-6 h-6 hover:w-8 hover:h-8 opacity-50' } rounded-full mx-auto`} 
                    />
                </div>
            </Link>
        )
    }

    const hrefIsCurrentPath = (href : string) => {
        return pathname === href;
    }

    return (
        <div className={ darkMode ? "dark" : "light"}>
            <div className="bg-white dark:bg-gray-900 text-black dark:text-gray-200 w-full min-h-screen h-full flex">
                <div className="max-w-full">
                    <div className="border-r border-gray-100 dark:border-gray-600 px-1 py-6 w-10 h-screen fixed">
                        <div className="flex flex-col gap-2 mt-8">
                            {navigationTab(<UserCircleIcon className="w-full" title="Me"/>, `/user`, hrefIsCurrentPath)}
                        </div>

                        <div className="border-t border-gray-100 dark:border-gray-600 my-4" />

                        <div className="flex flex-col gap-2 mt-8">
                            {
                                sortedSubreddits?.map(
                                    subreddit => subredditTab(subreddit)
                                )
                            }
                        </div>

                        <div className="border-t border-gray-100 dark:border-gray-600 my-4" />

                        { 
                            selectedSubreddit &&
                            sortedSubreddits?.find(subreddit => subreddit.displayName === selectedSubreddit) &&
                            navigationTabs() 
                        }
                    </div>
                    <div className="py-8 pl-12 md:pl-16 pr-2 md:pr-6 max-w-4xl">
                        { 
                            React.Children.map(children, child => {
                                return React.cloneElement(child, { session: session });
                            })
                        }
                    </div>
                </div>
            </div>
        </div>
    )

}