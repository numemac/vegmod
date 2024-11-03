import React from 'react';

import { useState } from 'react';
import { Base } from '@/models/base';
import { RedditLayout } from '@/components/reddit/layout';

import Session from './types/session';
import Plugin from './models/wrappers/plugin';
import User from '@/models/wrappers/user';

export const Show = ({ id, type, as } : { id?: string | string[], type?: string, as: Function }) => {
    if (id && Array.isArray(id)) { return "Invalid id provided"; }

    const [session, setSession] : [Session | null, Function] = useState(null);
    const [ fetching, setFetching ] = useState(false);
    const [model, setModel] : [Base, Function] = useState(
        id && type ? (
            new Base(type, id, (mutation : typeof type) => {
                setModel(mutation);
            }).wrap()
        ) : null
    );

    const hydrateUser = (data : any) => {
        const base = new Base('User', data.user.id, (mutation : any) => {
            return null; // mutations ignored for now
        });

        base.schema = data.schemas['User'];
        base.attributes = data.user.attributes;
        base.attributes['id'] = data.user.id;
        base.loadAssociations(data.user.associations, data.schemas); 

        return new User(base);
    };

    const hydrateSession = (data : any) => {
        const schemas = data.schemas;

        const plugins = data.plugins.map((plugin : any) => {
            const base = new Base('Plugin', plugin.attributes.title, (mutation : any) => {
                return null; // mutations ignored for now
            });

            base.schema = schemas['Plugin'];
            base.attributes = plugin.attributes;
            base.loadAssociations(plugin.associations, schemas);

            return new Plugin(base);
        });

        const user = data.user === null ? null : hydrateUser(data);

        return {
            user: user,
            plugins: plugins
        }
    }

    const fetchSession = async () => {
        if (fetching) { return null; }

        // set fetching to true to prevent multiple fetches
        setFetching(true);

        const response = await fetch('/session.json');
        const data = await response.json();

        // set fetching to false to allow future fetches
        setFetching(false);
        return data;
    }
    
    if (!session) {
        fetchSession().then(data => {
            if (!data) { return; }
            setSession(hydrateSession(data));
        });
    }

    const darkMode = () => {
        if (!session) { return false; }
        if (!session['user']) { return false; }
        return session['user']['darkMode'];
    }

    // as is a component that takes a model as a prop
    return (
        <RedditLayout session={session} darkMode={darkMode()}>
            { as({ session, model }) }
        </RedditLayout>
    );
}