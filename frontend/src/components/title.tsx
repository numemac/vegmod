import React from 'react';

export const Title = ({ text, children }: { text: string, children: React.ReactNode }) => { 
    return (
        <header className="flex w-full">
            <h1 className="text-lg font-bold leading-tight tracking-tight text-gray-900 max-w-lg">
                {text}
            </h1>
            <span className="items-right ml-auto">
                {children}
            </span>
        </header>
    )
}