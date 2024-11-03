"use client";

import Link from 'next/link';

import Plugin from '@/models/wrappers/plugin';
import Subreddit from '@/models/wrappers/reddit/subreddit';
import Session from '@/types/session';
import { Heading } from '@/components/reddit/subreddit/heading';
import fetch from '@/lib/fetch';
import SubredditPlugin from '@/models/wrappers/reddit/subreddit_plugin';
import { List } from 'postcss/lib/list';

export const EditSubredditPlugin = ({ session, model } : { session: Session, model: SubredditPlugin }) => {

    if (!model || !session) {
        return <></>;
    }

    if (!model.subreddit) {
        return <></>;
    }

    const renderMultilineStringField = (name : string, fieldSpec : FieldSpec, value: string) => {
        return (
            <textarea
                id={`${name}-input`}
                name={name}
                rows={5}
                defaultValue={fieldSpec.default}
                className="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
            />
        )
    }

    const renderSingleLineStringField = (name : string, fieldSpec : FieldSpec, value: string) => {
        return (
            <input
                id={`${name}-input`}
                name={name}
                type="text"
                defaultValue={fieldSpec.default}
                autoComplete="off"
                className="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
            />
        )
    }

    const fieldComponent = (name : string, fieldSpec : FieldSpec, children : any) => {
        return (
            <div className="sm:col-span-4">
                <label htmlFor={name} className="block text-sm font-medium leading-6 text-gray-900">
                    { fieldSpec.label }
                </label>
                <p className="mt-1 text-sm text-gray-500">
                    { fieldSpec.description }
                </p>
                <div className="mt-2">
                    { children }
                </div>
            </div>
        );
    }


    const renderField = (name : string, fieldSpec : FieldSpec, value: number | string | boolean) => {

        if (fieldSpec.type === 'string') {
            if (fieldSpec.multiline) {
                return fieldComponent(
                    name,
                    fieldSpec, 
                    renderMultilineStringField(name, fieldSpec, value as string)
                );
            } else {
                return fieldComponent(
                    name,
                    fieldSpec, 
                    renderSingleLineStringField(name, fieldSpec, value as string)
                );
            }
        }
    }

    const renderFields = (spec : Spec, config : SubredditPluginConfig) => {
        const fields = [];
        for (const [name, fieldSpec] of Object.entries(spec).sort((a, b) => a[1]._order - b[1]._order)) {
            const value = config[name] || fieldSpec.default;
            fields.push(renderField(name, fieldSpec, value));
        }
        return (
            <div className="border-b border-gray-900/10 pb-8">
                <div className="mt-8 grid grid-cols-1 gap-x-6 gap-y-8 sm:grid-cols-6">
                    { fields }
                </div>
            </div>
        );
    }

    const cancelButton = () => {
        return <div className="sm:col-span-4 mt-12">
            <Link href={`/r/${model.subreddit.displayName}/plugins`}>
                <div className="inline-flex items-center px-4 py-2 border border-transparent text-sm leading-5 font-medium rounded-md shadow-sm text-white bg-gray-600 hover:bg-gray-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500">
                    Cancel
                </div>
            </Link>
        </div>
    }

    const updateButton = () => {
        return <div className="sm:col-span-4 mt-12">
            <button
                type="submit"
                className="inline-flex items-center px-4 py-2 border border-transparent text-sm leading-5 font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            >
                Update
            </button>
        </div>
    }

    const uninstallButton = () => {
        return <div className="sm:col-span-4 mt-12">
            <button
                type="submit"
                className="inline-flex items-center px-4 py-2 border border-transparent text-sm leading-5 font-medium rounded-md shadow-sm text-white bg-red-600 hover:bg-red-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
            >
                Uninstall
            </button>
        </div>
    }

    return <div>
        <h2 className="text-base font-semibold leading-7">{model.plugin.title}</h2>
        <p className="mt-1 text-sm leading-6 text-gray-500">
            Configuring plugin for {model.subreddit.displayName}
        </p>
        { renderFields(model.plugin.spec, model.config) }
        <div className="flex flex-row gap-4">
            { cancelButton() }
            { updateButton() }
            { uninstallButton() }
        </div>
    </div>
}

interface Spec {
    [name: string]: FieldSpec,
}

interface FieldSpec {
    label: string,
    type: string,
    default: any,
    description: string,
    validations: any,
    multiline: boolean,
    _order: number,
}

interface SubredditPluginConfig {
    [name: string]: number | string | boolean,
}