<h1 align="center"><b>VERSUS</b></h3>

<p>Versus is a global comparison platform, providing unbiased and user-friendly comparisons across various categories. By providing accurate and objective information, as well as structured, easy-to-visualize data, we aim to ease decision-making. It is Open source web application to make comparisons between whatever you want.</p>

&nbsp;

## Story behind this project

*Jenkinsfile* and *docker-compose.yaml* files once were used to build, test, and run the 'versus' application on-premises by DevOps Engineers. Now it is your turn to configure the CICD pipeline to deploy the application to the AWS EKS cluster.

## How to use docker-compose.yaml

1. To build custom images defined in your docker-compose.yml (E.g., *312-bc/versus-api* and *312-bc/versus-ui* defined in our *docker-compose.yaml* file):

```
docker-compose build
```

2. Start your services defined in docker-compose.yml:

```
docker-compose up
```

or to run services in the background

```
docker-compose up -d
```

3. To stop services running in the background, use:

```
docker-compose down
```

## 📦 Backend Installation instructions

### Ubuntu and Ubuntu-based

1. Install prerequisites for Python build:
  ```bash 
  sudo apt-get update
  sudo apt-get install --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
  ```
1. Install pyenv: https://github.com/pyenv/pyenv#basic-github-checkout
1. Install Python: `pyenv install 3.7.4`
1. Install pyenv-virtualenv: https://github.com/pyenv/pyenv-virtualenv
1. Create virtualenv while in project directory: `pyenv virtualenv 3.7.4 vs-api-venv`
   
   * Virtualenv name `vs-api-venv` is important because `.python-version` also points to it. 
   It is needed for virtualenv to be activated automatically when you enter project directory 
   and deactivated when you leave.

### ⚙️ Running dev server
Install prerequisites if using MySQL:
```
sudo apt-get install python3-dev default-libmysqlclient-dev
```

In activated virtualenv install requirements:
```
pip install -r requirements.txt
```

### In order to use the application, we need to create a new database in MySQL. Follow these steps:

1. Open your MySQL command-line tool

2. Run the following command to create a new database:

```angular2html

> CREATE DATABASE DATABASE_NAME CHARACTER SET utf8

```

Replace *DATABASE_NAME* with the name you want for your database.

3. Set Database Credentials as Environment Variables:

To connect the application to the database, we need to provide the database credentials as environment variables. These are the variables you'll need to set:

- MYSQL_ROOT_PASSWORD: The password for the MySQL root user. This is usually set during MySQL installation.

- MYSQL_DATABASE: The name of the database you created in Step 1 (e.g., *DATABASE_NAME*).

- MYSQL_USER: The username for accessing the database. You can choose a username.

- MYSQL_PASSWORD: The password for the database user. Choose a secure password.

- MYSQL_HOST: The hostname or IP address where the MySQL database is hosted. If it's hosted locally, you can use localhost.

- MYSQL_PORT: The port on which MySQL is running. The default is usually 3306.

Make sure to set these environment variables with the appropriate values before running the application. These credentials allow the application to establish a connection to the MySQL database you created.

Then run migrations:

```
./manage.py migrate
```

Seed fixtures:
```
./manage.py loaddata data.json
```

This will create a super user with username `admin` and password `Password123`

Run the backend dev server:

```
./manage.py runserver
```


### 🔨 Running tests

```
./manage.py test
```
&nbsp;

## 📦 Frontend Installation instructions

This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).

### Available Scripts

In the project directory, you can run:

### ⚙️`yarn start`

Runs the app in the development mode.<br />
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

The page will reload if you make edits.<br />
You will also see any lint errors in the console.

### 🔨 `yarn test`

Launches the test runner in the interactive watch mode.<br />
See the section about [running tests](https://facebook.github.io/create-react-app/docs/running-tests) for more information.

### `yarn build`

Builds the app for production to the `build` folder.<br />
It correctly bundles React in production mode and optimizes the build for the best performance.

The build is minified and the filenames include the hashes.<br />
Your app is ready to be deployed!

See the section about [deployment](https://facebook.github.io/create-react-app/docs/deployment) for more information.

### `yarn eject`

**Note: this is a one-way operation. Once you `eject`, you can’t go back!**

If you aren’t satisfied with the build tool and configuration choices, you can `eject` at any time. This command will remove the single build dependency from your project.

Instead, it will copy all the configuration files and the transitive dependencies (Webpack, Babel, ESLint, etc) right into your project so you have full control over them. All of the commands except `eject` will still work, but they will point to the copied scripts so you can tweak them. At this point you’re on your own.

You don’t have to ever use `eject`. The curated feature set is suitable for small and middle deployments, and you shouldn’t feel obligated to use this feature. However we understand that this tool wouldn’t be useful if you couldn’t customize it when you are ready for it.

## Deploying in Kubernetes
Before building a frontend Docker image you should make appropriate changes in `.env.production` file in `frontend` folder . The `.env.production` file contains a **REACT_APP_API_URL** variable with a domain address. This domain is a production **backend** domain address. To send requests from the frontend service you should replace the **REACT_APP_API_URL** value with your own one. First of all, create an ingress, service, and deployment for the backend service. Then create a Route53 record set with obtained Kubernetes ingress. After the recordset creation in the Route53 service, replace **REACT_APP_API_URL** with the ingress value you have created previously. For example:

```
REACT_APP_API_URL=http://vs-backend.example.com
```