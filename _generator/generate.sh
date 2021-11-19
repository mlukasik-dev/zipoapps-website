#!/bin/sh

set -e

if [ "${PWD##*/}" != "_generator" ]; then
    echo "Please cd into _generator"
    exit 1
fi

echo "Generate terms and privacy for a new app"
echo "----------------------------------------"

if [ -z "${slug+_}" ]; then
    echo "What is the slug the app? (https://zipoapps.com/{SLUG})"
    read slug
fi
if [ -z "${fullname+_}" ]; then
    echo "What is the full name of the app? (for exampe 'Video Crop')"
    read fullname
fi
if [ -z "${tagline+_}" ]; then
    echo "Provide a tag line for the app? (for example 'Android Video Editor Watermark Free')"
    read tagline
fi
if [ -z "${summary+_}" ]; then
    echo "Provide a single sentence summary of the app?"
    read summary
fi
if [ -z "${email+_}" ]; then
    echo "What is the support email?"
    read email
fi
if [ -z "${iconurl+_}" ]; then
    echo "What is the URL to download the app icon?"
    read iconurl
fi
if [ -z "${package+_}" ]; then
    echo "What is the GP package of the app?"
    read package
fi

# If not in a silent mode.
if [ "$1" != "-s" ]; then
    echo
    echo "About to generate the app site, privacy and terms:"
    for i in {slug,fullname,tagline,summary,email,iconurl,package}; do echo "$i = ${!i}"; done
    echo
    echo "Hit any key to continue or break to quit"
    read
fi

curl -o ../images/$slug-icon.png -k $iconurl
if [ $? -ne 0 ]; then
    echo "error downloading icon"
    exit 8
fi
convert ../images/$slug-icon.png -resize 96x96  ../images/$slug-icon.png
if [ $? -ne 0 ]; then
    echo "error resizing icon"
    exit 8
fi

sed -e "s/\${SLUG}/$slug/g" \
    -e "s/\${FULLNAME}/$fullname/g" \
    -e "s/\${PACKAGE_NAME}/$package/g" \
    -e "s/\${TAGLINE}/$tagline/g" \
    -e "s/\${SUMMARY}/$summary/g" \
    _APP.md > ../$slug.md
if [ $? -ne 0 ]; then
    echo "error generating app site"
    exit 8
fi

sed -e "s/\${SLUG}/$slug/g" \
    -e "s/\${FULLNAME}/$fullname/g" \
    -e "s/\${SUPPORT_EMAIL}/$email/g" \
    _APP_privacy.md > ../${slug}_privacy.md
if [ $? -ne 0 ]; then
    echo "error generating app privacy policy"
    exit 8
fi

sed -e "s/\${SLUG}/$slug/g" \
    -e "s/\${FULLNAME}/$fullname/g" \
    -e "s/\${SUPPORT_EMAIL}/$email/g" \
    _APP_terms.md > ../${slug}_terms.md
if [ $? -ne 0 ]; then
    echo "error generating app terms"
    exit 8
fi

sed -e "s/\${SLUG}/$slug/g" \
    -e "s/\${FULLNAME}/$fullname/g" \
    -e "s/\${SUPPORT_EMAIL}/$email/g" \
    _APP_dns.md > ../${slug}_dns.md
if [ $? -ne 0 ]; then
    echo "error generating app do not sale"
    exit 8
fi

sed -e "s/\${SLUG}/$slug/g" \
    -e "s/\${FULLNAME}/$fullname/g" \
    -e "s/\${SUPPORT_EMAIL}/$email/g" \
    _APP_ccpa.md > ../${slug}_ccpa.md
if [ $? -ne 0 ]; then
    echo "error generating app CCPA"
    exit 8
fi
