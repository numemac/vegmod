import { Wrapper } from "../../wrapper";

export default class Metric extends Wrapper {

    get measure() : string {
        return this.get("measure");
    }

    get unit() : string {
        return this.get("unit");
    }

    get interval() : number {
        return this.get("interval");
    }
}