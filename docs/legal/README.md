# Legal docs — how to use them

Two ready-to-host pages:
- `privacy-policy.html` — **required** by Google Play, the App Store, and AdMob before you ship ads.
- `health-disclaimer.html` — liability protection for a fitness app (also shown in-app on first run).

> These are solid starting templates, **not legal advice**. Update the names/email/dates and have
> someone review them before publishing — especially the privacy policy once your exact ad/analytics
> setup is final.

## Host them for free (pick one)
- **GitHub Pages:** put the HTML in a repo, enable Pages → you get a public URL like
  `https://<you>.github.io/stretchhome/privacy-policy.html`.
- **Google Sites / Netlify Drop / Cloudflare Pages:** drag-and-drop hosting, also free.

Then paste the privacy-policy URL into:
1. The app's Settings → Privacy policy (wire with `url_launcher`).
2. Google Play Console → App content → Privacy policy.
3. App Store Connect → App Privacy → Privacy Policy URL.

## Store privacy form — quick answers (verify against your final build)
When filling **Google Play Data safety** / **Apple App Privacy**, the typical truthful answers are:
- **Personal info (name, email):** None collected.
- **Device or other IDs (advertising ID):** Collected — by AdMob, for **Advertising/Marketing**. Shared with Google. Not used to track you across other companies' apps unless you enable that.
- **App activity / analytics:** Collected if Firebase Analytics is on — for **Analytics**, anonymous/aggregate.
- **Location:** Approximate only, derived by the ad network from IP (not precise device location).
- **Data encrypted in transit:** Yes (Google SDKs use HTTPS).
- **Users can request deletion:** On-device data is removed on uninstall; no server account exists.

If you decide **not** to add Firebase Analytics, remove the analytics lines above and the Analytics
section from `privacy-policy.html`.
