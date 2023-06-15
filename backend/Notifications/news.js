const http = require('http');

const sendNotificationForNews = (news) => {
    const notification = {
      title: 'New News',
      body: `Check our latest news`,
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

    app.post('/news', (req, res) => {

        // ...
        // ...
      
    
        sendNotificationForNews(newNews);
      
        res.status(200).json({ message: 'News article added successfully' });
      });