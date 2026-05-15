import React from "react";

export const THEME_COLOR = "#7077a1";
export const UNCHAINED_COLOR = "#662222";
export const DIFF_REMOVED = "#662222";
export const DIFF_ADDED = "#352f44";
export const CODE_GUTTER_COLOR = "gray";

export function color(unchained: boolean) {
  if (unchained) return UNCHAINED_COLOR;
  return THEME_COLOR;
}

export const UnchainedContext = React.createContext<boolean>(false);

export function useUnchained() {
  return React.useContext(UnchainedContext);
}

export function useColor() {
  const unchained = useUnchained();
  return color(unchained);
}
