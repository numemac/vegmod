"use client";

import { AuthRedirect } from '@/components/auth/redirect';
import Image from 'next/image';
import Link from 'next/link';

import { useState } from 'react';

export default function LandingPage() {

    const applicationFormUrl : string = "https://www.reddit.com/message/compose?to=r%2Fvegancirclejerk&subject=Vegmod%20Application&message=I%20am%20a%20moderator%20of%20r/[subreddit_here]%20and%20would%20like%20to%20use%20Vegmod.%20Please%20send%20me%20instructions%20on%20how%20to%20configure%20Vegmod%20for%20my%20subreddit.%20Thank%20you!%20%3A%29"

    const features = [
        {
            title: "Analytics",
            description: "Vegmod provides charts to help you understand your community and its growth.",
            image: "/next/images/analytics.png"
        },
        {
            title: "Bots",
            description: "Answer common questions and provide resources to your community.",
            image: "https://via.placeholder.com/150"
        },
        {
            title: "Configurations",
            description: "Vegmod can manage rules, flairs, automod, wiki, and more.",
            image: "https://via.placeholder.com/150"
        },
        {
            title: "Removals",
            description: "Vegmod can identify and remove harmful content from your subreddit.",
            image: "https://via.placeholder.com/150"
        }
    ]

    const [selectedFeature, setSelectedFeature] = useState(features[0])

    // four horizontal tabs, selected feature is displayed below. first thing is description, below it is image
    // image is a placeholder for now
    const FeatureTabs = () => {
        return (
            <div className="flex flex-col gap-8">
                <div className="flex gap-4 md:gap-8 justify-center">
                    {features.map((feature, index) => (
                        <button 
                            key={index}
                            onClick={() => setSelectedFeature(feature)}
                            className={`py-2 px-2 md:px-4 rounded-xl font-bold ${feature.title === selectedFeature.title ? 'bg-white text-blue-600' : 'bg-none text-blue-100'}`}
                        >
                            {feature.title}
                        </button>
                    ))}
                </div>
                <div className="flex flex-col gap-8 min-h-96">
                    <div>
                        <p>{selectedFeature.description}</p>
                    </div>
                    <div className="p-4 bg-white rounded-lg mx-auto">
                        <img src={selectedFeature.image} className="w-96 object-cover" />
                    </div>
                </div>
            </div>
        )
    }

    return (
        <AuthRedirect>
            <div className="flex flex-col my-16 gap-16">
                <div className="p-8 text-center text-black">
                    <div>
                        <h1 className="text-2xl md:text-4xl font-bold">
                            Mute the carnists, amplify our movement.
                        </h1>
                        <p className="text-md md:text-lg">
                            Vegmod is a free and open-source AI suite for moderating vegan subreddits.
                        </p>
                    </div>
                    <div className="flex justify-center gap-4 mt-8">
                        <Link 
                            href={applicationFormUrl}
                            className="bg-gray-800 hover:bg-black text-white hover:text-white font-bold py-2 px-4 rounded-full"
                        >
                            Apply
                        </Link>
                        <Link
                            href="/auth/sign-in"
                            className="bg-white text-black border-green-700 hover:border-green-900 border-2 font-bold py-2 px-4 rounded-full"
                        >
                            Sign In
                        </Link>
                    </div>
                </div>
                <div className="p-8 text-center text-white bg-gradient-to-br from-blue-500 to-green-500 flex flex-col gap-8">
                    <div>
                        <h2 className="text-xl md:text-2xl font-bold">
                            Everything to manage your community.
                        </h2>
                        <p className="text-md md:text-lg">
                            Focus on strategy while Vegmod handles the details.
                        </p>
                    </div>
                    <div>
                        {
                            features.length > 0 && <FeatureTabs />
                        }
                    </div>
                </div>
                <div className="p-8 text-center text-black flex flex-col gap-8">
                    <div>
                        <h2 className="text-xl md:text-2xl font-bold">
                            Immediately benefit from scale.
                        </h2>
                        <p className="text-md md:text-lg">
                            Vegmod shares insights, standardizes processes, and facilitates collaboration.
                        </p>
                    </div>
                </div>
            </div>
        </AuthRedirect>
    )
}