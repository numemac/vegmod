import { AbstractModel } from './abstract_model';

export class Wrapper {
    _: AbstractModel;
    constructor(abstract : AbstractModel) {
        this._ = abstract;
    }

    get(key: string, offset: null | number = null, limit: null | number = null) {
        return this._.get(key, false, offset, limit);
    }

    reload(key: string, offset: null | number = null, limit: null | number = null) {
        return this._.reload(key, offset, limit);
    }

    onStateChanged(func: Function) {
        this._.onStateChanged(func);
    }

    get id() {
        return this._.get('id');
    }
}

export function getWrapper(type: string) {
    // dynamically import the class
    // example
    // type: 'Reddit::Subreddit' is found as './wrappers/reddit/subreddit'

    // Reddit::Redditor -> reddit/redditor
    // Reddit::SubredditRedditor -> reddit/subreddit_redditor
    // const path = type.split('::').map((s) => s.toLowerCase()).join('/');
    // when setting the path be mindful to convert PascalCase to snake_case

    // handle cases like XRedditor where the two capital letters are not separated by a lowercase letter
    // XRedditor -> x_redditor
    const snake_cased = type.replace(/([A-Z])([A-Z])/g, '$1_$2').replace(/([a-z])([A-Z])/g, '$1_$2').toLowerCase();
    const path = snake_cased.split('::').join('/');
    const klass = require(`./wrappers/${path}`).default;
    return klass;
}