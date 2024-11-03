import React from 'react';
import { useState } from 'react';

import { Field, Label, Switch } from '@headlessui/react';

import Session from '@/types/session';
import fetch from '@/lib/fetch';
import { Title, Subtitle, Detail, Medium } from '@/components/font';
import { Indent, TextBox , Separator } from '../form';
import { BlueButton } from '../button';

export const UserIndex = ({ session } : { session : Session }) => {

    const [darkMode, setDarkMode] = useState(false);

    if (!session) {
        return null;
    }

    const model = session.user;

    if (!model || !model.redditors || !model.subreddits) {
        return null;
    }

    if (model.darkMode != darkMode) {
        setDarkMode(model.darkMode);
    }

    const signOutButton = () => {
        return (
            <BlueButton
                onClick={
                    async () => {
                        const response = await fetch('/users/sign_out', {
                            method: 'DELETE',
                            headers: {
                                'Content-Type': 'application/json',
                            },
                        });

                        if (response.ok) {
                            // redirect to home
                            window.location.href = '/';
                        }
                    }
                }
            >
                Sign Out
            </BlueButton>
        )
    }

    const updateDarkMode = async () => {
        // PATCH /users
        // dark_mode: !darkMode
        fetch(`/users/${model.id}.json`, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                dark_mode: !darkMode
            })
        }).then(() => {
            window.location.reload();
        });
    }

    const darkModeToggle = () => {
        return (
            <Field className="flex items-center my-2">
                <Switch
                checked={darkMode}
                onChange={updateDarkMode}
                className="group relative inline-flex h-6 w-11 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent bg-gray-200 transition-colors duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-indigo-600 focus:ring-offset-2 data-[checked]:bg-indigo-600"
                >
                <span
                    aria-hidden="true"
                    className="pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out group-data-[checked]:translate-x-5"
                />
                </Switch>
                <Label as="span" className="ml-3 text-sm">
                <span className="font-medium">Dark Mode</span>
                </Label>
            </Field>
        )
    }

    return (
        <div>
            <Title>Account</Title>

            <Separator />

            <Indent>
                <Subtitle>Authentication</Subtitle>
                <Detail>
                    Control how you access Vegmod.
                </Detail>

                <Indent>
                    <TextBox label="Email Address" id="email" value={model.email} disabled />

                    <Medium>Session</Medium>
                    <Indent>
                        <div className="my-2">
                            {signOutButton()}
                        </div>
                    </Indent>
                </Indent>
            </Indent>

            <Separator />

            <Indent>
                <Subtitle>Appearance</Subtitle>
                <Detail>
                    These settings will sync across all your devices.
                </Detail>
                <Indent>
                    {darkModeToggle()}
                </Indent>
            </Indent>
        </div>
    )
}