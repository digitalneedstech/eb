importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");
firebase.initializeApp({
  apiKey: "AIzaSyBE-fX2xkMpxfrb_JQX1DtdRVlq8qVUvGI",
    authDomain: "expertbunch-c5b78.firebaseapp.com",
    databaseURL: "https://expertbunch-c5b78-default-rtdb.firebaseio.com",
    projectId: "expertbunch-c5b78",
    storageBucket: "expertbunch-c5b78.appspot.com",
    messagingSenderId: "602481051370",
    appId: "1:602481051370:web:aa1cc80978cf66168e7993"
});
const messaging = firebase.messaging();
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});/*
messaging.setBackgroundMessageHandler(function(payload) {
  const promiseChain = clients
    .matchAll({
      type: "window",
      includeUncontrolled: true
    })
    .then(windowClients => {
      for (let i = 0; i < windowClients.length; i++) {
        const windowClient = windowClients[i];
        windowClient.postMessage(payload);
      }
    })
    .then(() => {
      const title = payload.notification.title;
      const options = {
        body: payload.notification.score
      };
      return registration.showNotification(title, options);
    });
  return promiseChain;
});*/
self.addEventListener("notificationclick", function(event) {
  console.log("notification received: ", event);
});