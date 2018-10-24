
/**
 * Trim classnames of any element which has more than one class name set to className prop
 * @param {Array<string>} classNames
 * @return {string}
 */
export const trimClassNames = (classNames: Array<string> = []): string => {
  return classNames.filter((c: string) => c !== "" && c !== " ").join(" ");
};
