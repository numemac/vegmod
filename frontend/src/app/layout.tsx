import React from "react";

import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import customFetch from '../lib/fetch';

global.fetch = customFetch as typeof fetch;

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Vegmod | Reddit Moderator Panel",
  description: "Created by u/Numerous-Macaroon224",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className={inter.className}>
        {children}
      </body>
    </html>
  );
}
