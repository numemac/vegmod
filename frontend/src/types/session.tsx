import Plugin from "@/models/wrappers/plugin";
import User from "@/models/wrappers/user";

export default interface Session {
    user: User | null;
    plugins: Plugin[];
}