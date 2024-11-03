import { Wrapper } from "../wrapper";

export default class Plugin extends Wrapper {

    get klass() : string {
        return this.get("klass");
    }

    get title() : string {
        return this.get("title");
    }

    get description() : string {
        return this.get("description");
    }

    get author() : string {
        return this.get("author");
    }

    get spec() : any {
        return this.get("spec");
    }

    get loaded() : boolean {
        return this.get("loaded");
    }

}