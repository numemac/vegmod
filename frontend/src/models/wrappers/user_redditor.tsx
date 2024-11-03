import { Wrapper } from "../wrapper";
import Redditor from "./reddit/redditor";

export default class UserRedditor extends Wrapper {

    get redditor() : Redditor {
        return this.get("redditor");
    }
    
}