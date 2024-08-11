export interface Href {
    pathname: string | null;
    query: {} | null;
}

export interface LabeledHref {
    label: string;
    href: Href;
}