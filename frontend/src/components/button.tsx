const BaseButton = ({ className, onClick, disabled, children } : { className: string, onClick?: Function, disabled?: boolean, children: string }) => {
    return (
        <button 
            className={className}
            onClick={
                () => {
                    if (onClick) {
                        onClick();
                    }
                }
            }
            disabled={disabled}
        >
            {children}
        </button>
    )
}

export const RedButton = ({ onClick, disabled, children } : { onClick?: Function, disabled?: boolean, children: string }) => {
    return (
        <BaseButton 
            className="bg-red-600 dark:hover:bg-red-600 hover:bg-red-700 dark:bg-red-700 text-white text-sm font-bold py-2 px-4 rounded"
            onClick={onClick}
            disabled={disabled}
        >
            {children}
        </BaseButton>
    )
}

export const GreenButton = ({ onClick, disabled, children } : { onClick?: Function, disabled?: boolean, children: string }) => {
    return (
        <BaseButton
            className="bg-green-600 dark:hover:bg-green-600 hover:bg-green-700 dark:bg-green-700 text-white text-sm font-bold py-2 px-4 rounded"
            onClick={onClick}
            disabled={disabled}
        >
            {children}
        </BaseButton>
    )
}

export const BlueButton = ({ onClick, disabled, children } : { onClick?: Function, disabled?: boolean, children: string }) => {
    return (
        <BaseButton
            className="bg-blue-600 dark:hover:bg-blue-600 hover:bg-blue-700 dark:bg-blue-700 text-white text-sm font-bold py-2 px-4 rounded"
            onClick={onClick}
            disabled={disabled}
        >
            {children}
        </BaseButton>
    )
}