export interface Navigation {
    title: string;
    tabs: NavigationTab[];
    select: NavigationSelect | null;
}

export interface NavigationTab {
    label: string;
    count: number | null;
    href: string;
    current: boolean;
}

export interface NavigationSelect {
    label: string;
    options: NavigationSelectOption[];
}

export interface NavigationSelectOption {
    label: string;
    href: string;
    current: boolean;
}