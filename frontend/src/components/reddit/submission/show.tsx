"use client";

import Submission from '@/models/wrappers/reddit/submission';
import { Expanded } from './expanded';

export const Show = ({ model } : { model: Submission }) => {
    return (
        <div>
            <Expanded model={model} />
        </div>
    );
}