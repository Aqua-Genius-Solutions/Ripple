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

  const [rewards, setRewards] = useState([]);

  const [rewardName, setRewardName] = useState("");
  const [rewardDesc, setRewardDesc] = useState("");
  const [rewardPrice, setRewardPrice] = useState("");
  const [rewardId, setRewardId] = useState(null);
  const [rewardImage, setRewardImage] = useState("");

  const fetchRewards = async () => {
    const rewardsRequest = await axios.get(
      `${process.env.REACT_APP_API_URL}/rewards`
    );
    setRewards(rewardsRequest.data);
  };

  const deleteReward = (id) => {
    axios
      .delete(`${process.env.REACT_APP_API_URL}/rewards/${id}`)
      .then((res) => console.log(res.data))
      .catch((err) => console.error(err))
      .finally(() => fetchRewards());
  };

  const openEditModal = (reward) => {
    setRewardName(reward.title);
    setRewardDesc(reward.description);
    setRewardPrice(reward.price);
    setRewardId(reward.id);
    setRewardImage(reward.image);
    setShowModal(true);
  };

  const openAddModal = () => {
    setRewardName("");
    setRewardDesc("");
    setRewardPrice("");
    setRewardId(null);
    setRewardImage("");
    setShowAddModal(true);
  };

  const updateReward = () => {
    const updatedReward = {
      title: rewardName,
      desc: rewardDesc,
      price: rewardPrice,
      id: rewardId,
      image: rewardImage,
    };

    axios
      .put(
        `${process.env.REACT_APP_API_URL}/rewards/${rewardId}`,
        updatedReward
      )
      .then((res) => {
        console.log(res.data);
        setShowModal(false);
      })
      .catch((err) => console.error(err))
      .finally(() => fetchRewards());
  };

  const addReward = () => {
    const newReward = {
      name: rewardName,
      description: rewardDesc,
      price: +rewardPrice,
      image: rewardImage,
    };

    axios
      .post(`${process.env.REACT_APP_API_URL}/rewards`, newReward)
      .then((res) => {
        console.log(res.data);
        setShowAddModal(false);
      })
      .catch((err) => console.error(err))
      .finally(() => fetchRewards());
  };

  useEffect(() => {
    fetchRewards();
  }, []);

  return (
    <>
      <Container className="mt--7" fluid>
        <Row>
          <div className="col">
            <Card className="shadow">
              <CardHeader className="border-0 d-flex justify-content-between">
                <h3 className="mb-0">Rewards Table</h3>
                <Button color="primary" onClick={() => openAddModal()}>
                  Add Reward
                </Button>
              </CardHeader>
              <Table className="align-items-center table-flush" responsive>
                <thead className="thead-light">
                  <tr>
                    <th scope="col">Reward Image</th>
                    <th scope="col">Reward Name</th>
                    <th scope="col">Reward Desc</th>
                    <th scope="col">Reward Price</th>
                    <th scope="col" />
                  </tr>
                </thead>
                <tbody>
                  {rewards.map((reward) => (
                    <tr key={reward.id}>
                      <th scope="row" className="">
                        <span className="mb-0 mr-4 text-sm text-center">
                          <img
                            src={reward.image}
                            alt={reward.name}
                            width={80}
                            height={80}
                          />
                        </span>
                      </th>
                      <td>{reward.name}</td>
                      <td className="text-center">{reward.description}</td>
                      <td>{reward.price}</td>
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
                            <DropdownItem onClick={() => openEditModal(reward)}>
                              Edit Reward
                            </DropdownItem>
                            <DropdownItem
                              onClick={() => deleteReward(reward.id)}
                            >
                              Delete Reward
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
        <ModalHeader toggle={() => setShowModal(false)}>
          Edit Reward
        </ModalHeader>
        <ModalBody>
          <Form>
            <FormGroup>
              <Label for="title">Reward Name</Label>
              <Input
                type="text"
                name="title"
                id="title"
                placeholder="Enter reward name"
                value={rewardName || ""}
                onChange={(e) => setRewardName(e.target.value)}
              />
            </FormGroup>
            <FormGroup>
              <Label for="desc">Reward Desc</Label>
              <Input
                type="desc"
                name="desc"
                id="desc"
                placeholder="Enter reward description"
                value={rewardDesc || ""}
                onChange={(e) => setRewardDesc(e.target.value)}
              />
            </FormGroup>
            <FormGroup>
              <Label for="price">Reward Price</Label>
              <Input
                type="number"
                name="price"
                id="price"
                placeholder="Enter reward price"
                value={rewardPrice || ""}
                onChange={(e) => setRewardPrice(e.target.value)}
              />
            </FormGroup>
            <FormGroup>
              <Label for="image">Reward Image</Label>
              <Input
                type="text"
                name="image"
                id="image"
                placeholder="Enter reward image URL"
                value={rewardImage || ""}
                onChange={(e) => setRewardImage(e.target.value)}
              />
            </FormGroup>
            <Button color="primary" onClick={updateReward}>
              Update Reward
            </Button>
          </Form>
        </ModalBody>
      </Modal>
      <Modal isOpen={showAddModal} toggle={() => setShowAddModal(false)}>
        <ModalHeader toggle={() => setShowAddModal(false)}>
          Add Reward
        </ModalHeader>
        <ModalBody>
          <Form>
            <FormGroup>
              <Label for="title">Reward Name</Label>
              <Input
                type="text"
                name="title"
                id="title"
                placeholder="Enter reward name"
                value={rewardName || ""}
                onChange={(e) => setRewardName(e.target.value)}
              />
            </FormGroup>
            <FormGroup>
              <Label for="desc">Reward Desc</Label>
              <Input
                type="desc"
                name="desc"
                id="desc"
                placeholder="Enter reward description"
                value={rewardDesc || ""}
                onChange={(e) => setRewardDesc(e.target.value)}
              />
            </FormGroup>
            <FormGroup>
              <Label for="price">Reward Price</Label>
              <Input
                type="number"
                name="price"
                id="price"
                placeholder="Enter reward price"
                value={rewardPrice || ""}
                onChange={(e) => setRewardPrice(e.target.value)}
              />
            </FormGroup>
            <FormGroup>
              <Label for="image">Reward Image</Label>
              <Input
                type="text"
                name="image"
                id="image"
                placeholder="Enter reward image URL"
                value={rewardImage || ""}
                onChange={(e) => setRewardImage(e.target.value)}
              />
            </FormGroup>
            <Button color="primary" onClick={addReward}>
              Add Reward
            </Button>
          </Form>
        </ModalBody>
      </Modal>
    </>
  );
};

export default Tables;
