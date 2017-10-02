/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
    initialize: function() {
        document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    },

    // deviceready Event Handler
    //
    // Bind any cordova events here. Common events are:
    // 'pause', 'resume', etc.
    onDeviceReady: function() {
        window.izettle.init_iZettle("xxx", function(data){
            alert("init iZettle success");
        },
        function errorHandler(err){
            console.log(err);
        });
        
        var charge = document.getElementById('charge');
        var settings = document.getElementById('settings');
        var lastPaymentInfo = document.getElementById('lastPaymentInfo');
        var refundLastPayment = document.getElementById('refundLastPayment');
        var enforceAccount = document.getElementById('enforceAccount');
        
        charge.addEventListener('click', function() {
            window.izettle.charge(10.10, "USD", function(data){
                 document.getElementById("izettle").innerHTML = JSON.stringify(data);
            },
            function errorHandler(err){
                console.log(err);
                alert(JSON.stringify(err));

            });
        });
        
        settings.addEventListener('click', function() {
            window.izettle.settings(function(data){
                document.getElementById("izettle").innerHTML = JSON.stringify(data);
            },
            function errorHandler(err){
                console.log(err);
                alert(JSON.stringify(err));

            });
        });
        
        lastPaymentInfo.addEventListener('click', function() {
            window.izettle.lastPaymentInfo(function(data){
                document.getElementById("izettle").innerHTML = JSON.stringify(data);
            },
            function errorHandler(err){
                console.log(err);
                alert(JSON.stringify(err));

            });
        });

        refundLastPayment.addEventListener('click', function() {
            window.izettle.refundLastPayment(function(data){
                document.getElementById("izettle").innerHTML = JSON.stringify(data);
            },
            function errorHandler(err){
                console.log(err);
                alert(JSON.stringify(err));

            });
        });

        enforceAccount.addEventListener('click', function() {
            window.izettle.enforceAccount("test@test.no", function(data){
                document.getElementById("izettle").innerHTML = JSON.stringify(data);
            },
            function errorHandler(err){
                console.log(err);
                alert(JSON.stringify(err));

            });
        });

    },

    // Update DOM on a Received Event
    receivedEvent: function(id) {
        
    }
};

app.initialize();
