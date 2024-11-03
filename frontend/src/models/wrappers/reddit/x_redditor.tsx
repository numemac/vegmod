import { Wrapper } from "@/models/wrapper";

export default class XRedditor extends Wrapper {

    get score() : number {
        return this.get("score");
    }

    get adversarial_score() : number {
        return this.get("adversarial_score");
    }

    get non_adversarial_score() : number {
        return this.get("non_adversarial_score");
    }

}