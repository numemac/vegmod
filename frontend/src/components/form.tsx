export const Indent = ({ children }: { children: React.ReactNode }) => {
    return (
        <div className="pl-3">
            {children}
        </div>
    )
}

export const Separator = () => {
    return (
        <div className="my-4 border-t border-gray-200 dark:border-gray-800"></div>
    )
}

export const Label = ({ htmlFor, children }: { htmlFor: string, children: string }) => {
    return (
        <label htmlFor={htmlFor} className="block text-sm font-medium">
            {children}
        </label>
    )
}

export const TextBox = ({ label, id, value, placeholder, autocomplete, disabled } : { label: string, id: string, value?: string, placeholder?: string, autocomplete?: string, disabled?: boolean }) => {
    return (
        <div className="my-4">
            <Label htmlFor={id}>
                {label}
            </Label>
            <Indent>
                <div className="mt-2">
                    <input
                        id={id}
                        name={id}
                        type="text"
                        value={value}
                        placeholder={placeholder}
                        autoComplete={autocomplete}
                        className="block w-full rounded-md border-0 py-1.5 bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm/6"
                        disabled={disabled}    
                    />
                </div>
            </Indent>
        </div>
    )
}