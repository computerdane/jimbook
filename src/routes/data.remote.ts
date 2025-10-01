import { prerender } from "$app/server";

export const getPing = prerender(() => {
  return { message: "pong" };
});
