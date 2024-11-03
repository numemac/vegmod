import { useEffect } from 'react';

// If the user is logged in, redirect to /user
// Use this component in the home, login, and register pages
export const AuthRedirect = ({ children } : { children: any }) => {

    useEffect(() => {
        // load session.json
        fetch("/session.json")
            .then(response => response.json())
            .then(data => {
                console.log(data);
                if (data.user) {
                    // Redirect to /user
                    window.location.href = "/user";
                }
            })
    });

    return children;
}