"use client";

import { AuthForm } from "@/components/auth/form";
import { AuthInput } from "@/components/auth/input";
import { AuthRedirect } from "@/components/auth/redirect";

export default function Page() {
    return (
        <AuthRedirect>
            <AuthForm
                title="Sign up for Vegmod"
                action="/users"
                button="Sign up"
            >

                <AuthInput
                    label="Email address"
                    id="email"
                    name="email"
                    type="email"
                    autoComplete="email"
                />

                <AuthInput
                    label="Password"
                    id="password"
                    name="password"
                    type="password"
                    autoComplete="new-password"
                />

                <AuthInput
                    label="Confirm password"
                    id="password_confirmation"
                    name="password_confirmation"
                    type="password"
                    autoComplete="new-password"
                />

                <div className="border-t border-gray-200 my-3"></div>

                <AuthInput
                    label="Reddit Username"
                    id="username"
                    name="username"
                    type="text"
                    autoComplete="reddit-username"
                />

                <span className="text-xs text-gray-500">
                    We will ask you to send us a message from your Reddit account to verify your identity.
                </span>

            </AuthForm>
        </AuthRedirect>
    );
}