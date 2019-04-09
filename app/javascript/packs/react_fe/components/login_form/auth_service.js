import axios from 'axios';

var jose = require('node-jose');
//var jose = require('jose-simple')

/* gestione chiavi con jwe DA FINIRE
const webkey = {
    "keys": [
        {
            "kty": "RSA", 
            "e": "AQAB",
            "kid": "a024254d-0321-459f-9530-93020ce9d54a",
            "key_ops": [
                "encrypt"
            ],
            "n": "jkHgYN98dlR2w7NX-gekCWaCdbxs7X4XXh52DVQrK--krwUYqRbBIUEw1bV8KX0ox6TLt-e6wpYsYYFUItSd5ySqohHRMq1IhyE2zpEC95BA9V7VrFUYnczf1bd5c-aR079aoz5JPXfqx01TzNfxWBb04SlRjsmJeY1v6JrDUI5U0FSOmnJTb3tSS6Szrvi_qOyViYp4v9V2_OVYy45kF_LQQy-pr-kP4gapXL235cieeTW6UvkhzaPT2D-JKyzVjjjgnfRXr8Ox9I9c4wpef2-5nPPeafB5EnOMpJE11KzO_8xxiTGUywPPLQagBvY35gkhQbYS2dv3NGIVSLZHFw"
        }
    ]
};
console.log("webkey", webkey);


        //generate key store from public JWK
jose.JWK.asKeyStore(webkey).
    then((result) => {
        console.log("Key Store File", JSON.stringify(result.toJSON()));
        let keyStore = result;

        //get the key to encrypt
        const encryptionKey = keyStore.get(webkey.keys[0].kid);
        console.log("Encryption Key", JSON.stringify(encryptionKey));
        const output = jose.util.base64url.encode("Hello World");
        const input = jose.util.asBuffer(output);

        //encrypting content
        let options = {};
        jose.JWE.createEncrypt(encryptionKey).
            update(input).
            final().
            then((jweInGeneralSerialization) => {
                console.log("Encryption result", JSON.stringify(jweInGeneralSerialization));
            }, (error) => {
                console.log("Error2", error.message)
            });

    }, (error) => {
        console.log("error1", error.message);
    })

*/

export default class AuthService {
    // Initializing important variables
    constructor(domain) {
        console.log("Costruisco auth service con dominio",domain);
        this.domain = domain; //|| 'http://localhost:8080' // API server domain
        //this.fetch = this.fetch.bind(this) // React binding stuff
        this.login = this.login.bind(this);
        this.getProfile = this.getProfile.bind(this);
    }

    // fetch(url, options) {
    //     axios.post(url,options, {
    //         headers: {
    //             'authorization': 'mytoken',
    //             'Accept' : 'application/json',
    //             'Content-Type': 'application/json'
    //         }
    //     })
    //     .then(response => {
    //         // return  response;
    //     })
    //     .catch((error) => {
    //         //return  error;
    //     });
    // }


    login(username, password) {
        const data = {
            username: username,
            password: password
        }
        /*
        const { encrypt, decrypt } = jose(privateKey, publicKey)
        const someData = {
          some: 'amazing data',
          you: 'want to keep hidden',
          from: 'prying eyes'
        }
        encrypt(someData).then((encrypted) => {
          console.log('encrypted', encrypted)
          decrypt(encrypted).then((decrypted) => {
            console.log('decrypted', decrypted)
            // decrypted will be the same as someData
          })
        })
        */
        let axiosConfig = {
          headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json', //fa vedere a rails che e' una richiesta json!
              "Access-Control-Allow-Origin": "*",
              "Access-Control-Allow-Headers": "*"
          },
          responseType: 'json'
        };
        //axios.defaults.headers.post['Access-Control-Allow-Origin'] = '*';
        //axios.defaults.headers.post['Access-Control-Allow-Headers'] = '*';
        //axios.defaults.headers.post['Content-Type'] ='application/x-www-form-urlencoded';
        return axios.post(`${this.domain}/portal/autenticazione/login_jwe`,data,axiosConfig).then(res => {
            console.log("Fatto login", res);
            //this.setToken(res.token) // Setting the token in localStorage
            return Promise.resolve(res);
        })
    }

    loggedIn() {
        // Checks if there is a saved token and it's still valid
        const token = this.getToken() // GEtting token from localstorage
        return !!token && !this.isTokenExpired(token) // handwaiving here
    }

    isTokenExpired(token) {
        try {
            const decoded = decode(token);
            if (decoded.exp < Date.now() / 1000) { // Checking if token is expired. N
                return true;
            }
            else
                return false;
        }
        catch (err) {
            return false;
        }
    }

    setToken(idToken) {
        // Saves user token to localStorage
        localStorage.setItem('id_token', idToken)
    }

    getToken() {
        // Retrieves the user token from localStorage
        return localStorage.getItem('id_token')
    }

    logout() {
        // Clear user token and profile data from localStorage
        localStorage.removeItem('id_token');
    }

    getProfile() {
        // Using jwt-decode npm package to decode the token
        return "dati da portale"; //decode(this.getToken());
    }
    
    

    // fetch(url, options) {
    //     // performs api calls sending the required authentication headers
    //     const headers = {
    //         'Accept': 'application/json',
    //         'Content-Type': 'application/json'
    //     }

    //     // Setting Authorization header
    //     // Authorization: Bearer xxxxxxx.xxxxxxxx.xxxxxx
    //     if (this.loggedIn()) {
    //         headers['Authorization'] = 'Bearer ' + this.getToken()
    //     }

    //     return fetch(url, {
    //         headers,
    //         ...options
    //     })
    //         .then(this._checkStatus)
    //         .then(response => response.json())
    // }

    _checkStatus(response) {
        // raises an error in case response status is not a success
        if (response.status >= 200 && response.status < 300) { // Success status lies between 200 to 300
            return response
        } else {
            var error = new Error(response.statusText)
            error.response = response
            throw error
        }
    }
}