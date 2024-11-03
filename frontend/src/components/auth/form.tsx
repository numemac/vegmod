import Link from "next/link";
import fetch from "@/lib/fetch";

import { useEffect } from "react";

export const AuthForm = ({ title, action, button, children } : { title: string, action: string, button: string, children: any }) => {

    const onSubmit = async (e: React.SyntheticEvent) => {
        try {
            e.preventDefault();
            const form = e.target as HTMLFormElement;
            const formData = new FormData(form);
            const data = {
                user: Object.fromEntries(formData)
            };
            
            const response = await fetch(action, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data),
            });

            if (response.ok) {
                const json = await response.json();
                console.log("ok");
                console.log(json);

                // Redirect to /user
                window.location.href = "/user";
            } else {
                console.error(response.statusText);
            }
        } catch (error) {
            console.error(error);
        }
    }

    return (
        <>
            <div className="flex min-h-full flex-1 flex-col justify-center py-12 sm:px-6 lg:px-8">
            <div className="sm:mx-auto sm:w-full sm:max-w-md">
                <Link
                    href="/"
                >
                    <img
                        alt="Vegmod"
                        src="/next/images/vegmod-trim-512.png"
                        className="mx-auto h-16 w-auto"
                    />
                </Link>
                <h2 className="mt-4 text-center text-2xl font-bold leading-9 tracking-tight text-gray-900">
                    {title}
                </h2>
            </div>

            <div className="mt-10 sm:mx-auto sm:w-full sm:max-w-[480px]">
                <div className="bg-white px-6 py-12 shadow sm:rounded-lg sm:px-12">
                    <form onSubmit={onSubmit} className="space-y-6">
                        {children}

                        <div>
                            <button
                                type="submit"
                                className="flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
                            >
                                {button}
                            </button>
                        </div>
                    </form>
                </div>

                <p className="mt-10 text-center text-sm text-gray-500">
                Require assistance?{' '}
                <a href="https://discord.gg/JPWs5be7" className="font-semibold leading-6 text-indigo-600 hover:text-indigo-500">
                    Join our Discord
                </a>
                </p>
            </div>
            </div>
        </>
    );

}