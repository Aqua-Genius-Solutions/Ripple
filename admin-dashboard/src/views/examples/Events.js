import React, { useEffect, useState } from "react";
import axios from "axios";
import {
  Card,
  CardHeader,
  DropdownMenu,
  DropdownItem,
  UncontrolledDropdown,
  DropdownToggle,
  Table,
  Container,
  Row,
  Modal,
  ModalBody,
  ModalHeader,
  Form,
  FormGroup,
  Label,
  Input,
  Button,
} from "reactstrap";

const Tables = () => {
  const [showAddModal, setShowAddModal] = useState(false);
  const [showModal, setShowModal] = useState(false);

  const [events, setEvents] = useState([]);

  const [eventName, setEventName] = useState("");
  const [eventDate, setEventDate] = useState("");
  const [eventLink, setEventLink] = useState("");
  const [eventId, setEventId] = useState(null);
  const [eventImage, setEventImage] = useState("");

  const fetchEvents = async () => {
    const eventsRequest = await axios.get(
      `${process.env.REACT_APP_API_URL}/events`
    );
    setEvents(eventsRequest.data);
  };

  const deleteEvent = (id) => {
    axios
      .delete(`${process.env.REACT_APP_API_URL}/events/${id}`)
      .then((res) => console.log(res.data))
      .catch((err) => console.error(err))
      .finally(() => fetchEvents());
  };

  const openEditModal = (event) => {
    setEventName(event.title);
    setEventDate(event.date);
    setEventLink(event.link);
    setEventId(event.id);
    setEventImage(event.image);
    setShowModal(true);
  };

  const openAddModal = () => {
    setEventName("");
    setEventDate("");
    setEventLink("");
    setEventId(null);
    setEventImage("");
    setShowAddModal(true);
  };

  const updateEvent = () => {
    const updatedEvent = {
      title: eventName,
      date: eventDate,
      link: eventLink,
      id: eventId,
      image: eventImage,
    };

    axios
      .put(`${process.env.REACT_APP_API_URL}/events/${eventId}`, updatedEvent)
      .then((res) => {
        console.log(res.data);
        setShowModal(false);
      })
      .catch((err) => console.error(err))
      .finally(() => fetchEvents());
  };

  const addEvent = () => {
    const newEvent = {
      title: eventName,
      date: eventDate,
      link: eventLink,
      image: eventImage,
    };

    axios
      .post(`${process.env.REACT_APP_API_URL}/events`, newEvent)
      .then((res) => {
        console.log(res.data);
        setShowAddModal(false);
      })
      .catch((err) => console.error(err))
      .finally(() => fetchEvents());
  };

  useEffect(() => {
    fetchEvents();
  }, []);

  return (
    <>
      <Container className="mt--7" fluid>
        <Row>
          <div className="col">
            <Card className="shadow">
              <CardHeader className="border-0 d-flex justify-content-between">
                <h3 className="mb-0">Events Table</h3>
                <Button color="primary" onClick={() => openAddModal()}>
                  Add Event
                </Button>
              </CardHeader>
              <Table className="align-items-center table-flush" responsive>
                <thead className="thead-light">
                  <tr>
                    <th scope="col">Event Name</th>
                    <th scope="col">Event Date</th>
                    <th scope="col">Liked By</th>
                    <th scope="col">Participants</th>
                    <th scope="col">Event Link</th>
                    <th scope="col" />
                  </tr>
                </thead>
                <tbody>
                  {events
                    .sort((a, b) => new Date(b.date) - new Date(a.date))
                    .map((event) => (
                      <tr key={event.id}>
                        <th scope="row" className="">
                          <span className="mb-0 mr-4 text-sm">
                            {event.title}
                          </span>
                        </th>
                        <td>{event.date.substring(0, 10)}</td>
                        <td className="text-center">{event.LikedBy.length}</td>
                        <td className="text-center">
                          {event.participants.length}
                        </td>
                        <td>
                          <a href={event.link} target="_blank" rel="noreferrer">
                            Check it out
                          </a>
                        </td>
                        <td className="text-right">
                          <UncontrolledDropdown>
                            <DropdownToggle
                              className="btn-icon-only text-light"
                              href="#pablo"
                              role="button"
                              size="sm"
                              color=""
                              onClick={(e) => e.preventDefault()}
                            >
                              <i className="fas fa-ellipsis-v" />
                            </DropdownToggle>
                            <DropdownMenu className="dropdown-menu-arrow" right>
                              <DropdownItem
                                onClick={() => openEditModal(event)}
                              >
                                Edit Event
                              </DropdownItem>
                              <DropdownItem
                                onClick={() => deleteEvent(event.id)}
                              >
                                Delete Event
                              </DropdownItem>
                            </DropdownMenu>
                          </UncontrolledDropdown>
                        </td>
                      </tr>
                    ))}
                </tbody>
              </Table>
            </Card>
          </div>
        </Row>
      </Container>

      <Modal isOpen={showModal} toggle={() => setShowModal(false)}>
        <ModalHeader toggle={() => setShowModal(false)}>Edit Event</ModalHeader>
        <ModalBody>
          <Form>
            <FormGroup>
              <Label for="title">Event Name</Label>
              <Input
                type="text"
                name="title"
                id="title"
                placeholder="Enter event name"
                value={eventName || ""}
                onChange={(e) => setEventName(e.target.value)}
              />
            </FormGroup>
            <FormGroup>
              <Label for="date">Event Date</Label>
              <Input
                type="date"
                name="date"
                id="date"
                placeholder="Enter event date"
                value={eventDate || ""}
                onChange={(e) => setEventDate(e.target.value)}
              />
            </FormGroup>
            <FormGroup>
              <Label for="link">Event Link</Label>
              <Input
                type="text"
                name="link"
                id="link"
                placeholder="Enter event link"
                value={eventLink || ""}
                onChange={(e) => setEventLink(e.target.value)}
              />
            </FormGroup>
            <FormGroup>
              <Label for="image">Event Image</Label>
              <Input
                type="text"
                name="image"
                id="image"
                placeholder="Enter event image URL"
                value={eventImage || ""}
                onChange={(e) => setEventImage(e.target.value)}
              />
            </FormGroup>
            <Button color="primary" onClick={updateEvent}>
              Update Event
            </Button>
          </Form>
        </ModalBody>
      </Modal>
      <Modal isOpen={showAddModal} toggle={() => setShowAddModal(false)}>
        <ModalHeader toggle={() => setShowAddModal(false)}>
          Add Event
        </ModalHeader>
        <ModalBody>
          <Form>
            <FormGroup>
              <Label for="title">Event Name</Label>
              <Input
                type="text"
                name="title"
                id="title"
                placeholder="Enter event name"
                value={eventName || ""}
                onChange={(e) => setEventName(e.target.value)}
              />
            </FormGroup>
            <FormGroup>
              <Label for="date">Event Date</Label>
              <Input
                type="date"
                name="date"
                id="date"
                placeholder="Enter event date"
                value={eventDate || ""}
                onChange={(e) => setEventDate(e.target.value)}
              />
            </FormGroup>
            <FormGroup>
              <Label for="link">Event Link</Label>
              <Input
                type="text"
                name="link"
                id="link"
                placeholder="Enter event link"
                value={eventLink || ""}
                onChange={(e) => setEventLink(e.target.value)}
              />
            </FormGroup>
            <FormGroup>
              <Label for="image">Event Image</Label>
              <Input
                type="text"
                name="image"
                id="image"
                placeholder="Enter event image URL"
                value={eventImage || ""}
                onChange={(e) => setEventImage(e.target.value)}
              />
            </FormGroup>
            <Button color="primary" onClick={addEvent}>
              Add Event
            </Button>
          </Form>
        </ModalBody>
      </Modal>
    </>
  );
};

export default Tables;
