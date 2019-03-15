import React from 'react';
import { BrowserRouter as Router, Route } from 'react-router-dom';

import LoginForm from './components/login_form/login_form';

/* In props ci sono i parametri passati alla componente routes  */
const App = (props) => (
  <Router>
    <div>
      <Route exact path='/authentication/new'  render={ () => <LoginForm nomeEnte={props.nomeEnte} redirectUri={props.redirectUri} /> } />
    </div>
  </Router>
)
export default App;