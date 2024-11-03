export class AbstractModel {
    model: any;
    type: string;
    key: string;

    schema: { [key: string]: { [key: string]: string }} | undefined = undefined;

    attributes: { [key: string]: any } = {};
    associations: { [key: string]: any } = {};

    pendingRequests: { [key: string]: { [key: string]: boolean } | any } = {
        schema: false,
        attributes: false,
        associations: {}
    };

    // afterFetch callback, set by constructor
    stateChanged: Function = () => {};

    constructor(type: string, key: string, stateChanged: Function = () => {}) {
        this.type = type;
        this.key = key;
        this.stateChanged = stateChanged;
        this.afterConstruct();
    }

    afterConstruct() {
        // implement in subclass
    }

    get(key: string, reset: boolean = false, offset: null | number = null, limit: null | number = null) {
        return this.model.get(key, false, offset, limit);
    }

    reload(key: string, offset: null | number = null, limit: null | number = null) {
        return this.model.reload(key, offset, limit);
    }

    onStateChanged(func: Function) {
        this.stateChanged = func;
    }
}