export const DescriptionList = ({ items }: { items: { key: string, value: any }[] }) => {

    const truncate = (str: string, n: number) => {
        if (!str) {
            return str;
        }
        return (str.length > n) ? str.substring(0, n - 1) + '...' : str;
    }

    const renderItem = (key: any, value: any) => {
        return (
            <div className="border-t border-gray-100">
                <dl className="divide-y divide-gray-100">
                <div className="px-4 py-2 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-0">
                    <dt className="text-sm font-medium leading-6 text-gray-900">{key}</dt>
                    <dd className="mt-1 flex text-sm leading-6 text-gray-700 sm:col-span-2 sm:mt-0">
                        <span className="flex-grow" title={value && value.length > 500 ? value : ''}>
                            {truncate(value, 500)}
                        </span>
                    </dd>
                </div>
                </dl>
            </div>
        )
    }

    const renderedItems = items.map((item: any) => {
        return renderItem(item.key, item.value)
    })

    return (
        <>
            {renderedItems}
        </>
  )
}