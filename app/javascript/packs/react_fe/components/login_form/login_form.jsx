import React, { Component } from 'react';
// Components
import { Form, Control, Group, Label, Button } from 'react-bootstrap';
import AuthService from './auth_service';
import axios from 'axios';
import url_parse from 'url-parse';

import MyLoader from '../loader_modal/loader_modal';
import Jwt from 'jwt-simple';
/* global $ */  /* uso jquery  */

class LoginForm extends Component {
  
  constructor(props){
    super(props);
   
    this.state = {
      username: "",
      password: "",
      ricordami: false,
      nomeEnte: props.nomeEnte,
      redirectUri: props.redirectUri,
      loading: false
    };
    this.aggiornaStato = this.aggiornaStato.bind(this);
    this.validateForm = this.validateForm.bind(this);
  }
  
  validateForm(){
    return this.state.username !== null && this.state.username.length > 0 && this.state.password !== null && this.state.password.length > 0;
  };
  
  aggiornaStato = event => {
    this.setState({
      [event.target.id]: event.target.value
    })
  }
  
  pulisciCampi(){
    $("#username").val(null);
    $("#password").val(null);
    $("#ricordami").val(false);
    this.state.username = null;
    this.state.password = null;
    this.state.ricordami = false;
  }
  
  renderLoader(){
    console.log("chiamo renderloader");
    this.setState({loading: true});   
    console.log("stato loading corrente", this.state.loading);
    
  }

  handleSubmit = event => {
    event.preventDefault();
    console.log("Entro handlesubmit");
    this.renderLoader();
    
    $("#msg_errore").addClass('d-none');
    let axiosConfig = {
      headers: {
          //'Content-Type': 'application/json',
          'Content-Type': 'application/json',
          'Accept': 'application/json', //fa vedere a rails che e' una richiesta json!
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Headers": "*"
          //"Access-Control-Allow-Headers": "Origin, X-Requested-With, Content-Type, Accept"
      },
      responseType: 'json'
    };
    /* ricavo il dominio dal redirectUri con psl  */
    var url_parsed = url_parse(this.state.redirectUri);
    var dominio = url_parsed.protocol+"//"+url_parsed.host;
    this.Auth = new AuthService(dominio);
    this.Auth.login(this.state.username,this.state.password,this.state.ricordami)
            .then(res =>{
               console.log("Fatto login al submit su Portale:",res)
               if(res.data.stato == 'ok'){
                  console.log("Stato:", "ok");
                  //this.props.history.replace('/');
                  var data = res;
                  //passo il csrf al controller rails che lo vuole in POST
                  var csrf_key = $("meta[name='csrf-param']").attr('content');
                  var csrf_val = $("meta[name='csrf-token']").attr('content');
                  data[csrf_key] = csrf_val;
                  
                  axios.post('/authentication/create',data,axiosConfig).then(create_res => {
                    //console.log("Authentication Create:", create_res);
                    //return Promise.resolve(res);
                    if(create_res.data.stato == 'ok'){
                      console.log("RES DATA");
                      console.log(res.data);
                      //ritorno su portale con sid e id utente e riprendo giro di oauth2
                      var payload = { sid: res.data.sid_sessione, id_utente: res.data.dati_utente.id, ricordami: res.data.ricordami };
                      
                      //Secret fissa, usata quella di authhub..da env node dava problemi, e poi viene sempre messa in chiaro.
                      //sarebbe da usare un servizio esterno che 
                      var secret = '6rg1e8r6t1bv8rt1r7y7b86d8fsw8fe6bg1t61v8vsdfs8erer6c18168'; 
                      
                      var encryptedString = Jwt.encode(payload, secret);
                      //let url = this.state.redirectUri+"?sid="+res.data.sid_sessione+"&id_utente="+res.data.dati_utente.id;
                      let url = this.state.redirectUri+"?j="+encryptedString;
                      //console.log("url portale: ", url);
                      window.location.replace(url);
                      return false;
                    }else{ //ko
                      console.log("Autenticazione su portale ko ");
                      $("#msg_errore").text(res.data.messaggio);
                      $("#msg_errore").removeClass('d-none');
                      this.pulisciCampi();
                      $("#submit_login").attr('disabled','disabled');
                    }
                  })
               }else{
                  //mostro un messaggio di alert
                  $("#msg_errore").text("Username o Password errati!");
                  $("#msg_errore").removeClass('d-none');
                  this.pulisciCampi();
                  $("#submit_login").attr('disabled','disabled');
                  //fermo il loader
                  this.setState({loading: false});
               }
               
            })
            .catch(err =>{
                alert(err);
            })
  };
  
  render() {
    return(
      <div className="login">
        <form onSubmit={this.handleSubmit} className="rounded">
          <h3>Accedi a</h3>
          <h3>{this.state.nomeEnte}</h3>
          <Form.Group controlId="username" size="lg">
              <Form.Label>Username</Form.Label>
              <Form.Control
                autoFocus
                type="text"
                value={this.state.username}
                onChange={this.aggiornaStato}
                />
            </Form.Group>
          <Form.Group controlId="password" size="lg">
            <Form.Label>Password</Form.Label>
            <Form.Control
              value={this.state.password}
              onChange={this.aggiornaStato}
              type="password"
            />
          </Form.Group>
          <Form.Group controlId="ricordami" size="lg">
            <Form.Check type="checkbox" label="Rimani Connesso" onChange={this.aggiornaStato} />
          </Form.Group>
          <Button
            id="submit_login"
            variant="primary"
            block
            size="lg"
            disabled={!this.validateForm()}
            type="submit"
          >
            Login
          </Button>
        </form>
        <MyLoader active={this.state.loading} />
      </div>
    )
  }
  
}

export default LoginForm;