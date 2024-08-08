import React from 'react';
import { Inspect } from '@/types/inspect';
import Link from 'next/link';

export const InspectIndex = ({ inspect } : { inspect: Inspect }) => {
    const list = Array.isArray(inspect.data) ? inspect.data : [];

    return (
        <ul>
            {list.map((r: any) => {
                return <li key={r.id}>
                    <Link href={{
                        query: {
                            model: r.model,
                            id: r.id,
                            association: null 
                        }
                    }}>
                        {r.label}
                    </Link>
                </li>;
            })}
        </ul>
    );
};