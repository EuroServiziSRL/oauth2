import React from 'react';
import ReactDOM from 'react-dom';
import $ from 'jquery';

window.$ = window.jQuery = require('jquery')

import Routes from './routes'; /* file che abilita le varie component react sui vari path dell'applicazione */


/* foglio di stile generale  */
import './assets/stylesheets/app.scss';

/* global $ */  /* uso jquery  */



// $(document).ready(function(){
  
//   if($("#nome_ente").length > 0){
//     nome_ente = $("#nome_ente").attr('valore');
//   }
  
// })

/* controllo che nella pagina ci sia un tag con id #react_component che serve da container per la componente react  */

if($("#react_component").length > 0 && $("#msg_errore").hasClass('d-none')){
  document.addEventListener('DOMContentLoaded', () => {
    var nome_ente = "";
    var redirect_uri = "";
    
    if($("#errore").length > 0){
      
    }
    else
    {
      if($("#nome_ente").length > 0){
        nome_ente = $("#nome_ente").attr('valore');
      }
      if($("#redirect_uri").length > 0){
        redirect_uri = $("#redirect_uri").attr('valore');
      }
      ReactDOM.render(
        <Routes nomeEnte={nome_ente} redirectUri={redirect_uri} />, document.getElementById("react_component")
      );
    }
  }
  )
};