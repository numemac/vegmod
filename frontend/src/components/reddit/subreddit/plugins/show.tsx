"use client";

import Link from 'next/link';

import Plugin from '@/models/wrappers/plugin';
import Subreddit from '@/models/wrappers/reddit/subreddit';
import Session from '@/types/session';
import { PencilSquareIcon, PlusCircleIcon } from '@heroicons/react/24/outline';
import fetch from '@/lib/fetch';
import SubredditPlugin from '@/models/wrappers/reddit/subreddit_plugin';
import { Detail, Paragraph, Title, Subtitle } from '@/components/font';
import { Indent, Separator } from '@/components/form';

export const Plugins = ({ session, model } : { session: Session, model: Subreddit }) => {

    if (!model || !session) {
        return <></>;
    }

    if (!model.subredditPlugins) {
        return <></>;
    }

    const installPlugin = (subreddit : Subreddit, plugin : Plugin) => {
        // POST /subreddit_plugins
        // subreddit_id: subreddit.id
        // plugin_id: plugin.id
        fetch('/subreddit_plugins', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                subreddit_id: subreddit.id,
                plugin_id: plugin.id
            })
        }).then(() => {
            subreddit.reload('subreddit_plugins');
        });
    }

    const uninstallPlugin = (subredditPlugin: SubredditPlugin) => {
        fetch(`/subreddit_plugins/${subredditPlugin.id}`, {
            method: 'DELETE'
        }).then(() => {
            model.reload('subreddit_plugins');
        });
    }
    
    const pluginListItem = (plugin : Plugin, button : any) => {
        return (
            <tr key={plugin.id} className="flex items-center gap-4 border-b border-gray-200 dark:border-gray-800 m-1">
                <td className="flex flex-col w-full">
                    <Paragraph>{plugin.title}</Paragraph>
                    <Detail>{plugin.description}</Detail>
                </td>
                <td className="w-fit-content">
                    {button}
                </td>
            </tr>
        )
    }

    const installedPlugins = (
        <div className="mt-4">
            <Subtitle>Installed</Subtitle>
            { 
                model.subredditPlugins.length === 0 && (
                    <Detail>No plugins installed</Detail>
                )
            }
            <Indent>
                <table className="w-full">
                    {
                        model.subredditPlugins.sort((a, b) => a.plugin.title.localeCompare(b.plugin.title)).map(
                            sp => pluginListItem(sp.plugin, (
                                // <MinusCircleIcon className="h-8 w-8 text-red-500 cursor-pointer" title="Uninstall" onClick={
                                //     () => uninstallPlugin(sp)
                                // } />
                                <Link href={`/r/${model.displayName}/plugins/${sp.id}`}>
                                    <PencilSquareIcon className="h-8 w-8 text-blue-600 dark:hover:text-blue-600 hover:text-blue-700 dark:text-blue-700 cursor-pointer" title="Edit" />
                                </Link>
                            ))
                        )
                    }
                </table>
            </Indent>
        </div>
    )

    const availablePlugins = (
        <div className="mt-4">
            <Subtitle>Available</Subtitle>
            <Indent>
                <table className="w-full">
                    {
                        session.plugins.filter(
                            p => !model.subredditPlugins.find(sp => sp.plugin.id === p.id)
                        ).sort(
                            (a, b) => a.title.localeCompare(b.title)
                        ).map(plugin => {
                            return pluginListItem(plugin, (
                                <PlusCircleIcon className="h-8 w-8 text-green-600 dark:hover:text-green-600 hover:text-green-700 dark:text-green-700 cursor-pointer" title="Install" onClick={
                                    () => installPlugin(model, plugin)
                                } />
                            ))
                        })
                    }
                </table>
            </Indent>
        </div>
    )


    return <div>
        <Title>
            {'Plugins for r/' + model.displayName}
        </Title>
        <Separator />
        {installedPlugins}
        {availablePlugins}
    </div>
}