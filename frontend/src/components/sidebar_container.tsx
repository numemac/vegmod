"use client";

import React, { createContext, useState } from 'react';
import { Navigation } from '@/types/navigation';
import { Sidebar } from '@/components/sidebar';

export const ProgramNavigationContext = createContext<any>(null);

export const SidebarContainer = ({ children } : { children: React.ReactNode }) => {
    const [programNavigation, setProgramNavigation] : [Navigation, any] = useState({
        title: 'Loading...',
        tabs: [
        ]
    });

    return (
        <ProgramNavigationContext.Provider value={setProgramNavigation}>
          <Sidebar programNavigation={programNavigation}>
              {children}
          </Sidebar>
        </ProgramNavigationContext.Provider>
    );
}