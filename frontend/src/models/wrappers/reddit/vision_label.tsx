import { Wrapper } from "../../wrapper";

export default class VisionLabel extends Wrapper {
    get label() : string {
         return this.get("label");
    }

    get value() : string {
        return this.get("value");
    }
}