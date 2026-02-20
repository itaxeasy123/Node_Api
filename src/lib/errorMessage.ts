import { ZodError } from "zod";
import { ErrorMessageOptions, generateErrorMessage } from "zod-error";

const options: ErrorMessageOptions = {
  delimiter: {
    component: " - ",
  },
  code: {
    enabled: false,
  },
  path: {
    type: "zodPathArray",
    enabled: true,
    transform: ({ label, value }) => `${label}${value}`,
  },
  transform: ({ errorMessage, index }) =>
    `🔑 Error #${index + 1}: ${errorMessage}`,
};

export const formatErrorMessage = (error: ZodError) => {
  const message = generateErrorMessage(error.issues, options);
  return message;
};
