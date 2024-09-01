import React from 'react';
import { InspectHref, InspectShow } from '@/types/inspect';
import { RestAssociation } from '@/components/rest_association';
import humanizeString from 'humanize-string';
import { RainbowBadge } from '@/components/rainbow_badge';
import { Stat } from '@/components/stat';
import { LinkCard } from '@/components/link_card';
import { DescriptionList } from '@/components/description_list';
import { InspectLayout } from './layout';
import Link from 'next/link';
import { MetricBrowser } from '@/components/inspect/metric_browser';

export const InspectShowPage = ({ inspect } : { inspect: InspectShow }) => {
    const { attributes, belongs_to, has_one } = inspect.data;

    if (!inspect.data || !attributes || !belongs_to || !has_one) {
        return <>Loading</>
    }


    const isBadge = (key: string, value: any) => {
        return typeof value === 'boolean' && value === true;
    };

    const renderBadges = (badges: string[]) => {
        if (badges.length === 0) {
            return null;
        }

        return (
            <div className="flex gap-2 py-4">
                { badges.map(badge => { return <RainbowBadge text={humanizeString(badge)} /> })}
            </div>
        );
    }

    const isStat = (key: string, value: any) => {
        return typeof value === 'number' && !key.endsWith('_id') && key != 'id';
    }

    const renderStats = (stats: { [key: string]: number }) => {
        if (Object.keys(stats).length === 0) {
            return null;
        }

        return (
            <div className="flex gap-2 py-4">
                {Object.entries(stats).map(([key, value]) => <Stat text={key} value={value} />)}
            </div>
        )
    }

    const renderLinkCards = (linkCards: { [key: string]: { title: string, subtitle: string, href: InspectHref } }) => {
        return (
            <div className="grid grid-cols-1 gap-4 xs:grid-cols-1 sm:grid-cols-2 lg:grid-cols-3">
                {Object.entries(linkCards).map(([key, value]) => {
                    return (
                        <LinkCard
                            title={value.title}
                            subtitle={value.subtitle}
                            href={value.href}
                        />
                    );
                }
                )}
            </div>
        )
    };

    const renderImageUrl = (url: string | null) => {
        if (!url) {
            return <></>;
        }
        return (
            <Link
                href={url}
                className="cursor-pointer max-w-48"
            >
                <img 
                    src={url} 
                    alt="image" 
                    className="h-auto"
                />
            </Link>
        );
    }

    const renderExternalUrl = (url: string | null) => {
        if (!url) {
            return null;
        }

        return (
            <LinkCard
                title="View on Reddit"
                subtitle={url}
                href={url}
            />
        );
    }

    const combinedEntries = Object.entries(belongs_to).concat(Object.entries(has_one));

    const hierarchy = [
        {
            label: humanizeString(inspect.model.split('/')[1]),
            href: {
                pathname: '/inspect',
                query: {
                    model: inspect.model,
                    id: null,
                    association: null
                }
            }
        },
        {
            label: inspect.data.label,
            href: {
                pathname: '/inspect',
                query: {
                    model: inspect.model,
                    id: inspect.id,
                    association: null
                }
            }
        }
    ]

    return (
        <InspectLayout hierarchy={hierarchy} apiEndpoint={inspect.apiEndpoint} pagination={inspect.pagination}>
            {
                inspect.association === null ? (
                    <>
                        {renderBadges(Object.keys(attributes).filter((key: string) => isBadge(key, attributes[key])))}
                        {renderStats(Object.keys(attributes).reduce((acc: { [key: string]: number }, key: string) => {
                            const stat = isStat(key, attributes[key]);
                            if (stat) {
                                acc[key] = attributes[key];
                            }
                            return acc;
                        }, {}))}

                        {renderLinkCards(combinedEntries.reduce((acc: { [key: string]: { title: string, subtitle: string, href: InspectHref } }, [key, value]) => {
                            acc[key] = {
                                title: key,
                                subtitle: value.label,
                                href: value.href
                            };
                            return acc;
                        }, {}))}

                        <div className="flex flex-col gap-4">
                            {renderImageUrl(inspect.data.image_url)}
                            {renderExternalUrl(inspect.data.external_url)}

                            { inspect.id && <MetricBrowser model={inspect.model} id={inspect.id} metrics={inspect.data.metrics} /> }

                            <DescriptionList items={Object.entries(attributes).filter(([key, value]) => {
                                // filter out boolean
                                if (typeof value === 'boolean') {
                                    return false;
                                }

                                // filter out numbers
                                if (typeof value === 'number') {
                                    return false;
                                }

                                return true;
                            }).map(([key, value]) => {
                                return {
                                    key: humanizeString(key),
                                    value: value
                                }
                            }
                            )} />
                        </div>
                    </>
                ) : (
                    <>
                        <RestAssociation inspect={inspect} />
                    </>
                )
            }
        </InspectLayout>
    );  
};