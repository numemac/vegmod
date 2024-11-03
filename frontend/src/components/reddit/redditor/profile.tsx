import Redditor from "@/models/wrappers/reddit/redditor";
import SubredditRedditor from "@/models/wrappers/reddit/subreddit_redditor";
import Link from "next/link";

export const Profile = ({ model } : { model: Redditor }) => {

    const activity = () => {
        if (model.subredditRedditors === null) {
            return <p>Loading...</p>
        }

        return (
            <table className="table-auto w-full text-left">
                <thead>
                    <tr className="bg-gray-100 dark:bg-gray-600">
                        <th className="px-2">Subreddit</th>
                        <th className="px-2">Karma</th>
                        <th className="px-2">30 days</th>
                    </tr>
                </thead>
                <tbody>
                    { model.subredditRedditors.sort((a, b) => b.score - a.score).map((subredditRedditor : SubredditRedditor) => {
                        return (
                            <tr key={subredditRedditor.id} className="hover:bg-blue-100 dark:hover:bg-blue-600">
                                <td className="px-2">
                                    <Link href={`/u/${model.name}/r/${subredditRedditor.subreddit.displayName}`}>
                                        {subredditRedditor.subreddit.displayName}
                                    </Link>
                                </td>
                                <td className="px-2">
                                    {subredditRedditor.score}
                                </td>
                                <td className="px-2">
                                    {subredditRedditor.score30d}
                                </td>
                            </tr>
                        )
                    })}
                </tbody>
            </table>
        )
    }

    return (
        <div>
            <div className="flex gap-2 items-center">
                <img src={model.imageUrl} className="h-10 w-10 rounded-full" />
                <h1 className="text-2xl font-semibold">{model.name}</h1>
            </div>
            <h2 className="text-lg font-semibold">Activity by subreddit</h2>
            {activity()}
        </div>
    )
}