export const Title = ({ children }: { children: string }) => {
    return (
        <h1 className="my-2 text-lg font-semibold text-gray-900 dark:text-gray-100">
            {children}
        </h1>
    )
}

export const Subtitle = ({ children }: { children: string }) => {
    return (
        <h2 className="my-1 text-base font-bold text-gray-900 dark:text-gray-100">
            {children}
        </h2>
    )
}


export const Paragraph = ({ children }: { children: string }) => {
    return (
        <p className="my-0.5 text-sm text-gray-900 dark:text-gray-100">
            {children}
        </p>
    )
}

export const Medium = ({ children }: { children: string }) => {
    return (
        <p className="my-0.5 text-sm font-medium text-gray-900 dark:text-gray-100">
            {children}
        </p>
    )
}

export const Detail = ({ children }: { children: string }) => {
    return (
        <p className="my-0.5 text-sm text-gray-600 dark:text-gray-400">
            {children}
        </p>
    )
}