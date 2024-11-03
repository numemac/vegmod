import { Wrapper } from "../../wrapper";

export default class MetricSubjectDataPoint extends Wrapper {

    get intervalStart() : string {
        return this.get("interval_start");
    }

    get value() : number {
        return this.get("value");
    }

}