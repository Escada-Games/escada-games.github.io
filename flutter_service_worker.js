'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/assets/fonts/Montserrat-Bold.ttf": "ade91f473255991f410f61857696434b",
"assets/assets/fonts/Montserrat-Regular.ttf": "ee6539921d713482b8ccd4d0d23961bb",
"assets/assets/fonts/Montserrat-Italic.ttf": "a7063e0c0f0cb546ad45e9e24b27bd3b",
"assets/NOTICES": "c0a9738c69b2d68a374b6d0200ea62b0",
"assets/FontManifest.json": "0f7f78d16f3d8f0084a68ca1bdc003c9",
"assets/AssetManifest.json": "359c9f0256ed004148c76c33d8bf832d",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/fonts/MaterialIcons-Regular.otf": "1288c9e28052e028aba623321f7826ac",
"index.html": "a99a144e8a7dbb98645a8bad795b1046",
"/": "a99a144e8a7dbb98645a8bad795b1046",
"main.dart.js": "ee684a7789f724fc56ce4adec35336b2",
"icons/ms-icon-144x144.png": "cdd020420fb97619955bf95f6ed849aa",
"icons/apple-icon-60x60.png": "bcaf2ab78258cb28efc4c1931165c1da",
"icons/apple-icon-144x144.png": "cdd020420fb97619955bf95f6ed849aa",
"icons/apple-icon-76x76.png": "a23a4df7b8ca29163e93e770cef6ce19",
"icons/android-icon-192x192.png": "aa6b2b35c695ed7abd0302c1a71a4f91",
"icons/manifest.json": "b58fcfa7628c9205cb11a1b2c3e8f99a",
"icons/favicon.ico": "94cfe836c3c9f15a46d34a4553f9fc6a",
"icons/escada.png": "8ac7f17ee56253d43900f2f9467b5860",
"icons/favicon-16x16.png": "a4c93f78f650f83f0f720e18925224b5",
"icons/ms-icon-150x150.png": "d9e5779389adeb1fccbee67a5ec5dc3c",
"icons/apple-icon-180x180.png": "483c61f4ddca7d15b483f32b68e6a752",
"icons/android-icon-48x48.png": "67db4aac7e489f81cc69758be0858406",
"icons/apple-icon-precomposed.png": "256bb80220a49205893f8c49956a2ee5",
"icons/ms-icon-310x310.png": "5c26695d9bb3780aebe9372b121e115a",
"icons/android-icon-36x36.png": "b22136bb88d9517d9d59b26490886d06",
"icons/favicon-32x32.png": "498ba620bdbd11fbf31a5042fe1368bd",
"icons/apple-icon-57x57.png": "b0dbf7a3bfb418c312b5a75fc605e68d",
"icons/maskable_icon.png": "1ba2acc8e64733ae2c207ae063902cd3",
"icons/ms-icon-70x70.png": "bc83edc61b87aee1d9f95f52562af76b",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/apple-icon.png": "256bb80220a49205893f8c49956a2ee5",
"icons/apple-icon-72x72.png": "2381e95531a3ac75578418efedf4640d",
"icons/apple-icon-120x120.png": "b7fa78a99b39ae001157dd59cd5d593b",
"icons/android-icon-96x96.png": "f40753a2ec8564a28bb2076556069451",
"icons/browserconfig.xml": "653d077300a12f09a69caeea7a8947f8",
"icons/apple-icon-152x152.png": "28c51a427fcba41207e3cdd8d8cf9cb3",
"icons/android-icon-144x144.png": "cdd020420fb97619955bf95f6ed849aa",
"icons/android-icon-72x72.png": "2381e95531a3ac75578418efedf4640d",
"icons/favicon-96x96.png": "f40753a2ec8564a28bb2076556069451",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/apple-icon-114x114.png": "47643c94002949d0c6ba13d6efe23af0",
"manifest.json": "d2cd62a396d40200a7653ed8b7f9ad84",
"version.json": "0d7dbecac89c6900756ce4e26c083636",
"favicon.png": "a4c93f78f650f83f0f720e18925224b5"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value + '?revision=' + RESOURCES[value], {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
