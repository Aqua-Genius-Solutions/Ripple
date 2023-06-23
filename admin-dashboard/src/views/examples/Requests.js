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
const Requests = () => {
  const [requests, setRequests] = useState([]);
  const [selectedRequest, setSelectedRequest] = useState(null);

  const fetchRequests = async () => {
    const requestsRequest = await axios.get(
      `${process.env.REACT_APP_API_URL}/auth/requests`
    );
    setRequests(requestsRequest.data);
  };

  const getUser = async (request) => {
    const user = await axios.get(
      `${process.env.REACT_APP_API_URL}/auth/getOne/${request.userId}`
    );
    return user;
  };

  const openModal = (request) => {
    setSelectedRequest(request);
  };

  const toggleAdminStatus = async (status, requestId, name) => {
    const response = await axios.put(
      `${process.env.REACT_APP_API_URL}/requests/${requestId}/admin`,
      { isAdmin: status }
    );
    console.log(response);
    setSelectedRequest(null);
    await fetchRequests();
    toast.success(`${name}'s Admin status updated successfully!`, {
      position: toast.POSITION.TOP_RIGHT,
      autoClose: 3000,
      hideProgressBar: false,
    });
  };

  const toggleProStatus = async (status, requestId, name) => {
    const response = await axios.put(
      `${process.env.REACT_APP_API_URL}/requests/${requestId}/pro`,
      { isPro: status }
    );
    console.log(response);
    setSelectedRequest(null);
    await fetchRequests();
    toast.success(`${name}'s Pro status updated successfully!`, {
      position: toast.POSITION.TOP_RIGHT,
      autoClose: 3000,
      hideProgressBar: false,
    });
  };

  useEffect(() => {
    fetchRequests();
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
                <h3 className="mb-0">Icons</h3>
              </CardHeader>
              <CardBody>
                <Row className="icon-examples">
                  {requests?.map((request) => {
                    return (
                      <Col
                        lg="3"
                        md="6"
                        key={request.id}
                        onClick={() => openModal(getUser(request))}
                      >
                        <button
                          className="btn-icon-clipboard"
                          id={`tooltip-${request.id}`}
                          type="button"
                        >
                          <div>
                            <img
                              src={request.Image}
                              alt="Profile"
                              style={{
                                borderRadius: "50%",
                                width: 30,
                                height: 30,
                              }}
                            />
                            <span>{`${request.name} ${request.surname}`}</span>
                          </div>
                        </button>
                        <UncontrolledTooltip
                          delay={0}
                          trigger="hover focus"
                          target={`tooltip-${request.id}`}
                        >
                          {request.uid}
                        </UncontrolledTooltip>
                      </Col>
                    );
                  })}

                  <Modal
                    isOpen={selectedRequest !== null}
                    toggle={() => openModal(null)}
                  >
                    <ModalHeader toggle={() => openModal(null)}>
                      <span style={{ fontSize: 14 }}>Request Settings</span>
                    </ModalHeader>
                    <ModalBody>
                      {selectedRequest && (
                        <div style={{ fontSize: 12 }}>
                          <p>Name: {selectedRequest.name}</p>
                          <p>Admin: {selectedRequest.isAdmin ? "Yes" : "No"}</p>
                          <p>Pro: {selectedRequest.isPro ? "Yes" : "No"}</p>
                          <div
                            style={{
                              display: "flex",
                              justifyContent: "space-between",
                              marginTop: "20px",
                            }}
                          >
                            <Button
                              color={
                                selectedRequest.isAdmin ? "danger" : "success"
                              }
                              onClick={() =>
                                toggleAdminStatus(
                                  !selectedRequest.isAdmin,
                                  selectedRequest.uid,
                                  selectedRequest.name
                                )
                              }
                              style={{
                                borderRadius: "5px",
                                padding: "10px 20px",
                              }}
                            >
                              {selectedRequest.isAdmin
                                ? "Unmake Admin"
                                : "Make Admin"}
                            </Button>
                            <Button
                              color={
                                selectedRequest.isPro ? "danger" : "success"
                              }
                              onClick={() =>
                                toggleProStatus(
                                  !selectedRequest.isPro,
                                  selectedRequest.uid,
                                  selectedRequest.name
                                )
                              }
                              style={{
                                borderRadius: "5px",
                                padding: "10px 20px",
                              }}
                            >
                              {selectedRequest.isPro
                                ? "Unmake Pro"
                                : "Make Pro"}
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

export default Requests;
