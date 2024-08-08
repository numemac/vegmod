import React from 'react';
import { InspectHref, InspectSingle } from '@/types/inspect';
import { Title } from '@/components/title';
import { RestTabs } from './rest_tabs';
import { RestAssociation } from './rest_association';
import humanizeString from 'humanize-string';
import { RainbowBadge } from './rainbow_badge';
import { Stat } from './stat';
import { LinkCard } from './link_card';
import { DescriptionList } from './description_list';

export const InspectRecordPage = ({ inspect } : { inspect: InspectSingle }) => {
    const { attributes, belongs_to, has_one } = inspect.data;

    if (!inspect.data || !attributes || !belongs_to || !has_one) {
        return <>Loading</>
    }


    const isBadge = (key: string, value: any) => {
        if (typeof value === 'boolean' && value) {
            return <RainbowBadge text={humanizeString(key)} />;
        }
    };

    const renderBadges = (badges: string[]) => {
        return (
            <div className="flex gap-2">
                { badges.map(badge => { return <RainbowBadge text={humanizeString(badge)} /> })}
            </div>
        );
    }

    const isStat = (key: string, value: any) => {
        if (typeof value === 'number' && !key.endsWith('_id') && key != 'id') {
            return <Stat text={humanizeString(key)} value={value} />;
        }
    }

    const renderStats = (stats: { [key: string]: number }) => {
        return (
            <dl className="mx-auto grid grid-cols-1 gap-px sm:grid-cols-2 lg:grid-cols-4">
                {Object.entries(stats).map(([key, value]) => <Stat text={key} value={value} />)}
            </dl>
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

    const combinedEntries = Object.entries(belongs_to).concat(Object.entries(has_one));

    return (<>
        <Title text={inspect.data.label}>
            {renderBadges(Object.keys(attributes).filter((key: string) => isBadge(key, attributes[key])))}
        </Title>

        {renderStats(Object.keys(attributes).reduce((acc: { [key: string]: number }, key: string) => {
            const stat = isStat(key, attributes[key]);
            if (stat) {
                acc[humanizeString(key)] = attributes[key];
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
        }
        , {}))}

        <RestTabs inspect={inspect} />
        {
            inspect.association === null ? (
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
            ) : (
                <RestAssociation inspect={inspect} />
            )
        }
    </>);    

};