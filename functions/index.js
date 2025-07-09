const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendReminder = functions.firestore
    .document("events/{eventId}")
    .onCreate(async (snap, context) => {
      const data = snap.data();

      if (!data.deviceToken) {
        console.log("No device Token found for the event!");
        return null;
      }

      const message = {
        notification: {
          title: `Reminder: ${data.title}`,
          body: `Don't forget your event.`,
        },
        token: data.deviceToken,
      };

      try {
        const response = await admin.messaging().send(message);
        console.log("Notification sent successfully:", response);
        return response;
      } catch (error) {
        console.error("Error sending notification:", error);
        return null;
      }
    });
