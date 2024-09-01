import React from "react";

import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { SidebarContainer } from "@/components/sidebar_container";

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
        <SidebarContainer>
          {children}
        </SidebarContainer>
      </body>
    </html>
  );
}
