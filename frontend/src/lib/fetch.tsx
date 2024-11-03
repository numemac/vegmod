export default async(input: string | URL | globalThis.Request, init?: RequestInit): Promise<Response> => {
    console.log("Accessing custom fetch");
    const csrfToken = document.cookie.split('; ').find(row => row.startsWith('CSRF-TOKEN='))?.split('=')[1];

    const headers = {
        ...init?.headers,
        'X-CSRF-Token': csrfToken || '',
    };

    const options: RequestInit = {
        ...init,
        headers,
        credentials: 'include', // Include credentials (cookies, etc.) in the request
    };

    console.log("Using custom fetch");

    return fetch(input, options);
};