"use client";

import { AuthForm } from "@/components/auth/form";
import { AuthInput } from "@/components/auth/input";
import { AuthRedirect } from "@/components/auth/redirect";

export default function Page() {
    return (
        <AuthRedirect>
            <AuthForm
                title="Sign in to Vegmod"
                action="/users/sign_in"
                button="Sign in"
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
                    autoComplete="password"
                />

            </AuthForm>
        </AuthRedirect>
    );
}