import { AbstractModel } from './abstract_model';
import { getWrapper } from './wrapper';

export class Base extends AbstractModel {

    afterConstruct() {
        // this.fetch({ attributes: true });
    }

    notifyStateChange() {
        const clone = Object.assign(
            Object.create(Object.getPrototypeOf(this)), 
            this
        ).wrap()

        // update associated objects with the new stateChanged function
        Object.keys(this.associations).forEach((key: string) => {
            if (this.associations[key] === null) {
                return;
            } else if (Array.isArray(this.associations[key])) {
                this.associations[key].forEach((assoc: any) => {
                    assoc.stateChanged = (mutated: any) => {
                        clone.associations[key] = clone.associations[key].map((a: any) => {
                            return a.id === mutated.id ? mutated : a;
                        });
                        clone.notifyStateChange();
                    }
                });
            } else {
                this.associations[key].stateChanged = (mutated: any) => {
                    clone.associations[key] = mutated;
                    clone.notifyStateChange();
                }
            }
        });

        setTimeout(() => this.stateChanged(clone), 1);
    }

    // useDebouncedCallback for notifyStateChange from within a class

    async fetch(fetching = {} as { [key: string]: boolean | string[] }, offset: null | number = null, limit: null | number = null) {
        let { attributes = false, associations = [] } = fetching;
    
        attributes = this.pendingRequests.attributes ? false : attributes;
        if (attributes) {
            this.pendingRequests.attributes = true;
        }

        if (!Array.isArray(associations)) { associations = []; }
        associations.forEach((key: string) => {
            if (typeof associations === 'boolean') { associations = []; }
            if (this.pendingRequests.associations[key]) {
                associations = associations.filter((k: string) => k !== key);
            } else {
                this.pendingRequests.associations[key] = true;
            }
        });

        if (!attributes && !associations.length) {
            // nothing to fetch
            return; 
        } else {
            // new pending requests
            this.notifyStateChange();
        }

        const associationsString = () => {
            if (typeof associations === 'boolean') { associations = []; }
            if (associations.length == 0) { return ''; }

            // .replace remove trailing ampersand
            return associations.map((key: string) => {
                return `associations[]=${key}`;
            }).join('&').replace(
                /&$/, ''
            )
        }

        const offsetString = offset ? `&offset=${offset}` : '';
        const limitString = limit ? `&limit=${limit}` : '';

        const url : string = `https://vegmod.com/fetch.json?type=${this.type}&id=${this.key}&attributes=${attributes}&${associationsString()}${offsetString}${limitString}`;
        fetch(url).
        then((res) => res.json()).
        then((data : any) => {
            console.log('fetched', data);
            this.schema = data.schemas[this.type];

            if (attributes) {
                if (data.attributes) {
                    this.attributes = data.attributes;
                    this.attributes['id'] = this.key;
                    this.pendingRequests.attributes = false;
                } else {
                    console.error('Failed to fetch attributes');
                }
            }
            
            if (typeof associations === 'boolean') { associations = []; }
            if (data.associations) {
                this.loadAssociations(data.associations, data.schemas);
                Object.keys(data.associations).forEach((key: string) => {
                    this.pendingRequests.associations[key] = false;
                });
            }

            return this.notifyStateChange();
        }).catch((error) => {
            console.error(error);
        }).finally(() => {
            // this.notifyStateChange();
            return;
        });
    }

    reload(key: string, offset: null | number = null, limit: null | number = null) {
        return this.get(key, true, offset, limit);
    }

    get(key: string, reload: boolean = false, offset: null | number = null, limit: null | number = null) {
        if (key === 'key') {
            return this.key;
        }

        if (this.schema === undefined) {
            setTimeout(() => this.fetch({ attributes: true }), 1);
            console.log('fetch get, schema is undefined');
            return null;
        }

        if (this.pendingRequests.schema) {
            console.log('abort get, pending request: schema');
            return null;
        }

        if (this.schema.attributes[key]) {
            if (this.attributes.hasOwnProperty(key) && !reload) {
                return this.attributes[key];
            } else {
                // console.log('fetch get, key not in attributes', key);
                setTimeout(() => this.fetch({ attributes: true }), 1);
                return null;
            }
        }

        if (this.schema.associations[key]) {
            if (this.associations.hasOwnProperty(key) && !reload) {
                return this.associations[key];
            } else {
                setTimeout(() => this.fetch({ associations: [key] }, offset, limit), 1);
                // console.log('fetch get, key not in associations', key);
                return null;
            }
        }

        console.error(`Key ${key} not found in schema`, this.schema.associations, this.schema.attributes);
        return null;
    }

    loadAssociation(associated: any, schemas: any, stateChanged: Function) {
        if (!associated) {
            return null;
        }
        
        const obj = new Base(associated['_type'], associated['id'], stateChanged);
        obj.schema = schemas[associated['_type']];
        
        if (associated['attributes']) {
            obj.attributes = associated['attributes'];
        }

        if (associated['associations']) {
            obj.loadAssociations(associated['associations'], schemas);
        }

        return obj.wrap();
    }

    loadAssociations(associations: any, schemas: any) {
        Object.keys(associations).forEach((key: string) => {
            if (this.schema === undefined) {
                console.error('Schema is not defined, cannot load association for', key);
                return;
            }

            if (this.schema.associations[key] === "has_many") {
                this.associations[key] = associations[key].map((associated: any) => {
                    return this.loadAssociation(associated, schemas, (mutated : Base) => {
                        this.associations[key] = this.associations[key].map((assoc: any) => {
                            return assoc.id === mutated.get('id') ? mutated : assoc;
                        });
                        this.notifyStateChange();
                    });
                });
            } else {
                this.associations[key] = this.loadAssociation(associations[key], schemas, (mutated : Base) => {
                    this.associations[key] = mutated;
                    this.notifyStateChange();
                });
            }
        });
    }

    wrap() {
        const wrapperKlass = getWrapper(this.type);
        return new wrapperKlass(this);
    }
}