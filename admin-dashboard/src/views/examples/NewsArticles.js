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

  const [newsArticles, setNewsArticles] = useState([]);

  const [newsArticleName, setNewsArticleName] = useState("");
  const [newsArticleDate, setNewsArticleDate] = useState("");
  const [newsArticleLink, setNewsArticleLink] = useState("");
  const [newsArticleId, setNewsArticleId] = useState(null);
  const [newsArticleImage, setNewsArticleImage] = useState("");

  const fetchNews = async () => {
    const newsArticlesRequest = await axios.get(
      `${process.env.REACT_APP_API_URL}/news`
    );
    setNewsArticles(newsArticlesRequest.data);
  };

  const deleteNewsArticle = (id) => {
    axios
      .delete(`${process.env.REACT_APP_API_URL}/news/${id}`)
      .then((res) => console.log(res.data))
      .catch((err) => console.error(err))
      .finally(() => fetchNews());
  };

  const openEditModal = (newsArticle) => {
    setNewsArticleName(newsArticle.title);
    setNewsArticleDate(newsArticle.date);
    setNewsArticleLink(newsArticle.link);
    setNewsArticleId(newsArticle.id);
    setNewsArticleImage(newsArticle.image);
    setShowModal(true);
  };

  const openAddModal = () => {
    setNewsArticleName("");
    setNewsArticleDate("");
    setNewsArticleLink("");
    setNewsArticleId(null);
    setNewsArticleImage("");
    setShowAddModal(true);
  };

  const updateNewsArticle = () => {
    const updatedNewsArticle = {
      author: newsArticleName,
      date: new Date(newsArticleDate),
      link: newsArticleLink,
      id: newsArticleId,
      image: newsArticleImage,
    };

    axios
      .put(
        `${process.env.REACT_APP_API_URL}/news/${newsArticleId}`,
        updatedNewsArticle
      )
      .then((res) => {
        console.log(res.data);
        setShowModal(false);
      })
      .catch((err) => console.error(err))
      .finally(() => fetchNews());
  };

  const addNewsArticle = () => {
    const newNewsArticle = {
      author: newsArticleName,
      date: new Date(newsArticleDate),
      link: newsArticleLink,
      image: newsArticleImage,
    };

    axios
      .post(`${process.env.REACT_APP_API_URL}/news`, newNewsArticle)
      .then((res) => {
        console.log(res.data);
        setShowAddModal(false);
      })
      .catch((err) => console.error(err))
      .finally(() => fetchNews());
  };

  useEffect(() => {
    fetchNews();
  }, []);

  return (
    <>
      <Container className="mt--7" fluid>
        <Row>
          <div className="col">
            <Card className="shadow">
              <CardHeader className="border-0 d-flex justify-content-between">
                <h3 className="mb-0">News Articles Table</h3>
                <Button color="primary" onClick={() => openAddModal()}>
                  Add News Article
                </Button>
              </CardHeader>
              <Table className="align-items-center table-flush" responsive>
                <thead className="thead-light">
                  <tr>
                    <th scope="col">News Article Name</th>
                    <th scope="col">News Article Date</th>
                    <th scope="col">Liked By</th>
                    <th scope="col">News Article Link</th>
                    <th scope="col" />
                  </tr>
                </thead>
                <tbody>
                  {newsArticles
                    .sort((a, b) => new Date(b.date) - new Date(a.date))
                    .map((newsArticle) => (
                      <tr key={newsArticle.id}>
                        <th scope="row" className="">
                          <span className="mb-0 mr-4 text-sm">
                            {newsArticle.author}
                          </span>
                        </th>
                        <td>{newsArticle.date.substring(0, 10)}</td>
                        <td className="text-center">
                          {newsArticle.User.length}
                        </td>

                        <td>
                          <a
                            href={newsArticle.link}
                            target="_blank"
                            rel="noreferrer"
                          >
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
                                onClick={() => openEditModal(newsArticle)}
                              >
                                Edit NewsArticle
                              </DropdownItem>
                              <DropdownItem
                                onClick={() =>
                                  deleteNewsArticle(newsArticle.id)
                                }
                              >
                                Delete NewsArticle
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
          Edit News Article
        </ModalHeader>
        <ModalBody>
          <Form>
            <FormGroup>
              <Label for="title">News Article Name</Label>
              <Input
                type="text"
                name="title"
                id="title"
                placeholder="Enter newsArticle name"
                value={newsArticleName || ""}
                onChange={(e) => setNewsArticleName(e.target.value)}
              />
            </FormGroup>
            <FormGroup>
              <Label for="date">News Article Date</Label>
              <Input
                type="date"
                name="date"
                id="date"
                placeholder="Enter newsArticle date"
                value={newsArticleDate || ""}
                onChange={(e) => setNewsArticleDate(e.target.value)}
              />
            </FormGroup>
            <FormGroup>
              <Label for="link">News Article Link</Label>
              <Input
                type="text"
                name="link"
                id="link"
                placeholder="Enter newsArticle link"
                value={newsArticleLink || ""}
                onChange={(e) => setNewsArticleLink(e.target.value)}
              />
            </FormGroup>
            <FormGroup>
              <Label for="image">News Article Image</Label>
              <Input
                type="text"
                name="image"
                id="image"
                placeholder="Enter newsArticle image URL"
                value={newsArticleImage || ""}
                onChange={(e) => setNewsArticleImage(e.target.value)}
              />
            </FormGroup>
            <Button color="primary" onClick={updateNewsArticle}>
              Update News Article
            </Button>
          </Form>
        </ModalBody>
      </Modal>
      <Modal isOpen={showAddModal} toggle={() => setShowAddModal(false)}>
        <ModalHeader toggle={() => setShowAddModal(false)}>
          Add News Article
        </ModalHeader>
        <ModalBody>
          <Form>
            <FormGroup>
              <Label for="title">News Article Name</Label>
              <Input
                type="text"
                name="title"
                id="title"
                placeholder="Enter newsArticle name"
                value={newsArticleName || ""}
                onChange={(e) => setNewsArticleName(e.target.value)}
              />
            </FormGroup>
            <FormGroup>
              <Label for="date">News Article Date</Label>
              <Input
                type="date"
                name="date"
                id="date"
                placeholder="Enter newsArticle date"
                value={newsArticleDate || ""}
                onChange={(e) => setNewsArticleDate(e.target.value)}
              />
            </FormGroup>
            <FormGroup>
              <Label for="link">News Article Link</Label>
              <Input
                type="text"
                name="link"
                id="link"
                placeholder="Enter newsArticle link"
                value={newsArticleLink || ""}
                onChange={(e) => setNewsArticleLink(e.target.value)}
              />
            </FormGroup>
            <FormGroup>
              <Label for="image">News Article Image</Label>
              <Input
                type="text"
                name="image"
                id="image"
                placeholder="Enter newsArticle image URL"
                value={newsArticleImage || ""}
                onChange={(e) => setNewsArticleImage(e.target.value)}
              />
            </FormGroup>
            <Button color="primary" onClick={addNewsArticle}>
              Add News Article
            </Button>
          </Form>
        </ModalBody>
      </Modal>
    </>
  );
};

export default Tables;
