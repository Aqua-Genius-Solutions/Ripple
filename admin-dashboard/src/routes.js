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

import Header from "components/Headers/Header.js";
import Index from "views/Index.js";
import Rewards from "views/examples/Rewards.js";
import NewsArticles from "views/examples/NewsArticles";
import Login from "views/examples/Login.js";
import Events from "views/examples/Events";
import Users from "views/examples/Icons.js";
import Requests from "views/examples/Requests.js";

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
      <>
        <Header
          events={events.length}
          newsArticles={newsArticles.length}
          rewards={rewards.length}
          bills={bills.length}
        />
        <Index
          users={users}
          events={events}
          newsArticles={newsArticles}
          bills={bills}
          paidBills={paidBills}
          rewards={rewards}
        />
      </>
    ),
    layout: "/admin",
  },
  {
    path: "/users",
    name: "Users",
    icon: "ni ni-circle-08 text-blue",
    component: (
      <>
        <Header
          events={events.length}
          newsArticles={newsArticles.length}
          rewards={rewards.length}
          bills={bills.length}
        />
        <Users />
      </>
    ),
    layout: "/admin",
  },
  {
    path: "/news-articles",
    name: "News Articles",
    icon: "fas fa-newspaper text-orange",
    component: (
      <>
        <Header
          events={events.length}
          newsArticles={newsArticles.length}
          rewards={rewards.length}
          bills={bills.length}
        />
        <NewsArticles newsArticles={newsArticles} />
      </>
    ),
    layout: "/admin",
  },
  {
    path: "/rewards",
    name: "Rewards",
    icon: "ni ni-trophy text-yellow",
    component: (
      <>
        <Header
          events={events.length}
          newsArticles={newsArticles.length}
          rewards={rewards.length}
          bills={bills.length}
        />
        <Rewards />
      </>
    ),
    layout: "/admin",
  },
  {
    path: "/events",
    name: "Events",
    icon: "ni ni-pin-3 text-red",
    component: (
      <>
        <Header
          events={events.length}
          newsArticles={newsArticles.length}
          rewards={rewards.length}
          bills={bills.length}
        />
        <Events events={events} />
      </>
    ),
    layout: "/admin",
  },
  {
    path: "/requests",
    name: "Requests",
    icon: "ni ni-key-25 text-info",
    component: (
      <>
        <Header
          events={events.length}
          newsArticles={newsArticles.length}
          rewards={rewards.length}
          bills={bills.length}
        />
        <Requests />
      </>
    ),
    layout: "/admin",
  },
  {
    path: "/login",
    component: <Login />,
    layout: "/auth",
  },
  // {
  //   path: "/register",
  //   name: "Register",
  //   icon: "ni ni-badge text-pink",
  //   component: <Register />,
  //   layout: "/auth",
  // },
];
export default routes;
