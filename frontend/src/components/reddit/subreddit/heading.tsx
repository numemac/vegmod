"use client";

import { Title, Detail, Paragraph } from '@/components/font';
import { Separator } from '@/components/form';

import Subreddit from '@/models/wrappers/reddit/subreddit';

export const Heading = ({ model, showDescription } : { model: Subreddit, showDescription?: boolean }) => {
    const subscribersDelimited = model.subscribers ? (
        model.subscribers.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
    ) : "0";

    return (
        <div>
            <div className="flex flex-col gap-2">
                <div className="flex gap-2 text-gray-800 dark:text-gray-200 items-center">
                    <img src={model.imageUrl} className="h-12 w-12 rounded-full" />
                    <div className="flex flex-col">
                        <Title>
                            {'r/' + model.displayName}
                        </Title>
                        <Detail>
                            { subscribersDelimited + ' subscribers'}
                        </Detail>
                    </div>
                </div>
                {
                    showDescription && (
                        <Paragraph>
                            {model.publicDescription}
                        </Paragraph>
                    )
                }
            </div>
            <Separator />
        </div>
    )
}