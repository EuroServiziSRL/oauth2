import React from 'react';
import {
  BrowserRouter as Router,
  Route,
} from 'react-router-dom';
import LoginForm from './components/login_form';
const App = (props) => (
  <Router>
    <div>
      <Route exact path='/authentication/new' component={LoginForm} />
    </div>
  </Router>
)
export default App;