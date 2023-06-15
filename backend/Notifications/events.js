const http = require('http');

const sendEventNotification = (event) => {
  const notification = {
    title: 'New Event',
    body: `Check our new event '${event.title}' !`,
  };

  const fcmPayload = {
    notification: notification,
    topic: 'all_users',
  };

  const fcmOptions = {
    hostname: 'fcm.googleapis.com',
    path: '/fcm/send',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer AAAAqB-JCts:APA91bF1jkeU3ZKgmQIpPe0SYAsFAD579RwlmNIPCGcz4V1nUtUyENV4VehsLaBxkuvardp_VI_KLiV1aPmvCoYRxG9xy3pM8lZtJOqu2ToHb3LEa0zZF_sG6xNAb2V6bhqY69ZoaOlN',
    },
  };

  const fcmRequest = http.request(fcmOptions, (res) => {
    console.log(`FCM request status: ${res.statusCode}`);
  });

  fcmRequest.on('error', (error) => {
    console.error('FCM request error:', error);
  });

  fcmRequest.write(JSON.stringify(fcmPayload));
  fcmRequest.end();
};

app.post('/events', (req, res) => {
 
//.... 
//... 
// ..

  sendEventNotification(newEvent);

  res.status(200).json({ message: 'Event added successfully' });
});
