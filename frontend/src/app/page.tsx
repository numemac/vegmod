"use client";

import { useEffect } from "react";

export default function Page() {
    /* Redirect to /inspect */
    
    useEffect(() => {
        window.location.href = "/inspect";
    }, []);

}