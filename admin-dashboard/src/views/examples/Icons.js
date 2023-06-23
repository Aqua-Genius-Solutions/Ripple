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
import { ToastContainer, toast } from "react-toastify";

import { useEffect, useState } from "react";
// react component that copies the given text inside your clipboard
import { CopyToClipboard } from "react-copy-to-clipboard";
// reactstrap components
import {
  Card,
  CardHeader,
  CardBody,
  Container,
  Row,
  Col,
  UncontrolledTooltip,
  Modal,
  ModalHeader,
  ModalBody,
  Button,
} from "reactstrap";
// core components

const Icons = () => {
  const [copiedText, setCopiedText] = useState();
  const [users, setUsers] = useState([]);
  const [selectedUser, setSelectedUser] = useState(null);

  const fetchUsers = async () => {
    const usersRequest = await axios.get(
      `${process.env.REACT_APP_API_URL}/users`
    );
    console.log(usersRequest.data);
    setUsers(usersRequest.data);
  };

  const openModal = (user) => {
    setSelectedUser(user);
  };

  const toggleAdminStatus = async (status, userId, name) => {
    const response = await axios.put(
      `${process.env.REACT_APP_API_URL}/users/${userId}/admin`,
      { isAdmin: status }
    );
    console.log(response);
    setSelectedUser(null);
    await fetchUsers();
    toast.success(`${name}'s Admin status updated successfully!`, {
      position: toast.POSITION.TOP_RIGHT,
      autoClose: 3000,
      hideProgressBar: false,
    });
  };

  const toggleProStatus = async (status, userId, name) => {
    const response = await axios.put(
      `${process.env.REACT_APP_API_URL}/users/${userId}/pro`,
      { isPro: status }
    );
    console.log(response);
    setSelectedUser(null);
    await fetchUsers();
    toast.success(`${name}'s Pro status updated successfully!`, {
      position: toast.POSITION.TOP_RIGHT,
      autoClose: 3000,
      hideProgressBar: false,
    });
  };

  useEffect(() => {
    fetchUsers();
  }, []);
  return (
    <>
      {/* Page content */}
      <Container className="mt--7" fluid>
        {/* Table */}
        <Row>
          <div className="col">
            <Card className="shadow">
              <CardHeader className="bg-transparent">
                <h3 className="mb-0">Users</h3>
              </CardHeader>
              <CardBody>
                <Row className="icon-examples">
                  {users?.map((user) => {
                    const sanitizedUid = user.uid.replace(
                      /[^a-zA-Z0-9_-]/g,
                      ""
                    ); // Sanitize user.uid

                    return (
                      <Col
                        lg="3"
                        md="6"
                        key={user.uid}
                        onClick={() => openModal(user)}
                      >
                        <button
                          className="btn-icon-clipboard"
                          id={`tooltip-${sanitizedUid}`}
                          type="button"
                        >
                          <div>
                            <img
                              src={user.Image}
                              alt="Profile"
                              style={{
                                borderRadius: "50%",
                                width: 30,
                                height: 30,
                              }}
                            />
                            <span>{`${user.name} ${user.surname}`}</span>
                          </div>
                        </button>
                        <UncontrolledTooltip
                          delay={0}
                          trigger="hover focus"
                          target={`tooltip-${sanitizedUid}`}
                        >
                          {user.uid}
                        </UncontrolledTooltip>
                      </Col>
                    );
                  })}

                  <Modal
                    isOpen={selectedUser !== null}
                    toggle={() => openModal(null)}
                  >
                    <ModalHeader toggle={() => openModal(null)}>
                      <span style={{ fontSize: 14 }}>User Settings</span>
                    </ModalHeader>
                    <ModalBody>
                      {selectedUser && (
                        <div style={{ fontSize: 12 }}>
                          <p>Name: {selectedUser.name}</p>
                          <p>Admin: {selectedUser.isAdmin ? "Yes" : "No"}</p>
                          <p>Pro: {selectedUser.isPro ? "Yes" : "No"}</p>
                          <div
                            style={{
                              display: "flex",
                              justifyContent: "space-between",
                              marginTop: "20px",
                            }}
                          >
                            <Button
                              color={
                                selectedUser.isAdmin ? "danger" : "success"
                              }
                              onClick={() =>
                                toggleAdminStatus(
                                  !selectedUser.isAdmin,
                                  selectedUser.uid,
                                  selectedUser.name
                                )
                              }
                              style={{
                                borderRadius: "5px",
                                padding: "10px 20px",
                              }}
                            >
                              {selectedUser.isAdmin
                                ? "Unmake Admin"
                                : "Make Admin"}
                            </Button>
                            <Button
                              color={selectedUser.isPro ? "danger" : "success"}
                              onClick={() =>
                                toggleProStatus(
                                  !selectedUser.isPro,
                                  selectedUser.uid,
                                  selectedUser.name
                                )
                              }
                              style={{
                                borderRadius: "5px",
                                padding: "10px 20px",
                              }}
                            >
                              {selectedUser.isPro ? "Unmake Pro" : "Make Pro"}
                            </Button>
                          </div>
                        </div>
                      )}
                    </ModalBody>
                  </Modal>
                  <ToastContainer />
                </Row>
              </CardBody>
            </Card>
          </div>
        </Row>
      </Container>
    </>
  );
};

export default Icons;
