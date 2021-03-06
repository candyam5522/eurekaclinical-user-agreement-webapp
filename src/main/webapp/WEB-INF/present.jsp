<%--
  #%L
  Eureka! Clinical User Agreement Webapp
  %%
  Copyright (C) 2016 Emory University
  %%
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
       http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  #L%
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
    response.setHeader("Pragma", "no-cache"); //HTTP 1.0
    response.setDateHeader(
            "Expires", 0); //prevents caching at the proxy server
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <meta name="keywords"
              content="informatics, i2b2, biomedical, clinical research, research, de-identification, clinical data analysis, analytics, medical research, data analysis tool, clinical database, eureka!, eureka, scientific research, temporal patterns, bioinformatics, ontology, ontologies, ontology editor, data mining, etl, cvrg, CardioVascular Research Grid"/>
        <meta name="Description"
              content="A Clinical Analysis Tool for Biomedical Informatics and Data"/>
        <link rel="SHORTCUT ICON"
              href="${pageContext.request.contextPath}/favicon.ico">
        <link href="//fonts.googleapis.com/css?family=Source+Sans+Pro:400,600,700,400italic,600italic,700italic"
              rel="stylesheet" type="text/css">
        <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"/>
        <link rel="stylesheet" type="text/css" href="//maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
        <script src="https://code.jquery.com/jquery-2.2.4.min.js" type="text/javascript"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" type="text/javascript"></script>
        <script src="https://cdn.rawgit.com/showdownjs/showdown/1.4.2/dist/showdown.min.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/ec.bootbar.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/js/ec.idletimeout.js" type="text/javascript"></script>
        <script type="text/javascript">
            $(document).ready(function () {
                $(document).idleTimeout({
                    idleTimeLimit: ${pageContext.session.maxInactiveInterval - 30}, //Time out with 30 seconds to spare to make sure the server session doesn't expire first
                    redirectUrl: '${pageContext.request.contextPath}/logout',
                    alertDisplayLimit: 60, // Display 60 seconds before send of session.
                    sessionKeepAliveTimer: ${pageContext.session.maxInactiveInterval - 15} //Send a keep alive signal with 15 seconds to spare.
                });
            });
        </script>
        <title>User Agreement</title>
    </head>
    <body>
        <div class="container-fluid">
            <h1>User Agreement</h1>
            <div id="loader">
                <i class="fa fa-refresh fa-spin"></i>
                Loading...
            </div>
            <form id="theform" action="${pageContext.request.contextPath}/protected/agree" method="POST">
                <div id="datauseagreement"></div>
                <c:if test="${not empty param['service']}">
                    <input type="hidden" name="service" value="<c:out value="${param['service']}"/>">
                </c:if>
                <input type="hidden" name="useragreementid" id="useragreementid"/>
                <div class="form-group">
                    <label for="fullname">Full name:</label>
                    <input class="form-control" type="text" name="fullname" id="fullname" oninput="updateSubmitButton()">
                </div>
                <button type="submit" class="btn btn-default" name="submitButton" id="submitButton">I Agree</button>
            </form>
            <div id="getduafailed" class="alert alert-danger" role="alert">Error fetching data use agreement.</div>
        </div>
        <script type="text/javascript">
            $('#theform').hide()
            $('#getduafailed').hide()
            $('#submitButton').prop('disabled', true);

            updateSubmitButton = function () {
                if ($('#fullname').val().length > 0) {
                    $('#submitButton').prop('disabled', false);
                } else {
                    $('#submitButton').prop('disabled', true);
                }
            }

            $.ajax({
                url: "${pageContext.request.contextPath}/proxy-resource/useragreements/current", 
            }).done(function (data) {
                var responseJSON = JSON.parse(data);
                $('#loader').hide();
                var converter = new showdown.Converter();
                $('#datauseagreement').html(converter.makeHtml(responseJSON.text));
                $('#useragreementid').val(responseJSON.id);
                $('#theform').show()
            }).fail(function () {
                $('#loader').hide();
                $('#getduafailed').show()
            });

        </script>
    </body>
</html>
