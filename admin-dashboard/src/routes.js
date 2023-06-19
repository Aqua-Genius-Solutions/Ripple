/*!

=========================================================
* Argon Dashboard React - v1.2.3
=========================================================

* Product Page: https://www.creative-tim.com/product/argon-dashboard-react
* Copyright 2023 Creative Tim (https://www.creative-tim.com)
* Licensed under MIT (https://github.com/creativetimofficial/argon-dashboard-react/blob/master/LICENSE.md)

* Coded by Creative Tim

=========================================================

* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

*/
import axios from "axios";

import Index from "views/Index.js";
import Profile from "views/examples/Profile.js";
import Maps from "views/examples/Maps.js";
import Register from "views/examples/Register.js";
import Login from "views/examples/Login.js";
import Tables from "views/examples/Tables.js";
import Icons from "views/examples/Icons.js";

const usersRequest = await axios.get(`${process.env.REACT_APP_API_URL}/users`);
const users = usersRequest.data;

const eventsRequest = await axios.get(
  `${process.env.REACT_APP_API_URL}/events`
);
const events = eventsRequest.data;

const newsArticlesRequest = await axios.get(
  `${process.env.REACT_APP_API_URL}/news`
);
const newsArticles = newsArticlesRequest.data;

const rewardsRequest = await axios.get(
  `${process.env.REACT_APP_API_URL}/rewards`
);
const rewards = rewardsRequest.data;

const billsRequest = await axios.get(`${process.env.REACT_APP_API_URL}/bills`);
const bills = billsRequest.data;
const paidBills = billsRequest.data.filter((bill) => bill.paid);

var routes = [
  {
    path: "/index",
    name: "Dashboard",
    icon: "ni ni-tv-2 text-primary",
    component: (
      <Index
        users={users}
        events={events}
        newsArticles={newsArticles}
        bills={bills}
        paidBills={paidBills}
        rewards={rewards}
      />
    ),
    layout: "/admin",
  },
  {
    path: "/icons",
    name: "Icons",
    icon: "ni ni-planet text-blue",
    component: <Icons />,
    layout: "/admin",
  },
  {
    path: "/maps",
    name: "Maps",
    icon: "ni ni-pin-3 text-orange",
    component: <Maps />,
    layout: "/admin",
  },
  {
    path: "/user-profile",
    name: "User Profile",
    icon: "ni ni-single-02 text-yellow",
    component: <Profile />,
    layout: "/admin",
  },
  {
    path: "/tables",
    name: "Tables",
    icon: "ni ni-bullet-list-67 text-red",
    component: <Tables events={events} />,
    layout: "/admin",
  },
  {
    path: "/login",
    name: "Login",
    icon: "ni ni-key-25 text-info",
    component: <Login />,
    layout: "/auth",
  },
  {
    path: "/register",
    name: "Register",
    icon: "ni ni-circle-08 text-pink",
    component: <Register />,
    layout: "/auth",
  },
];
export default routes;
