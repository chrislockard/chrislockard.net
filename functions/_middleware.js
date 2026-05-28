// functions/_middleware.js
export const onRequest = [
  async ({ request, next }) => {
    const url = new URL(request.url);
    if (url.hostname === "chrislockard-net.pages.dev") {
      url.hostname = "www.chrislockard.net";
      return Response.redirect(url.toString(), 301);
    }
    return next();
  },
];
