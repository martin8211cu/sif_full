
<cfif !isDefined('url.progress')>
    <!DOCTYPE html>
    <html>
        <head>
            <style>
                * {
                    box-sizing: border-box;
                }

                input[type=text], select, textarea {
                    width: 100%;
                    padding: 12px;
                    border: 1px solid #ccc;
                    border-radius: 4px;
                    resize: vertical;
                }

                label {
                    padding: 12px 12px 12px 0;
                    display: inline-block;
                }

                input[type=submit] {
                    background-color: #4CAF50;
                    color: white;
                    padding: 12px 20px;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    float: right;
                }

                input[type=submit]:hover {
                    background-color: #45a049;
                }

                .container {
                    border-radius: 5px;
                    background-color: #f2f2f2;
                    padding: 20px;
                }

                .col-25 {
                    float: left;
                    width: 25%;
                    margin-top: 6px;
                }

                .col-75 {
                    float: left;
                    width: 75%;
                    margin-top: 6px;
                }

                /* Clear floats after the columns */
                .row:after {
                    content: "";
                    display: table;
                    clear: both;
                }

                /* Responsive layout - when the screen is less than 600px wide, make the two columns stack on top of each other instead of next to each other */
                @media screen and (max-width: 600px) {
                    .col-25, .col-75, input[type=submit] {
                        width: 100%;
                        margin-top: 0;
                    }
                }
            </style>
        </head>
        <body>
                <h1> Phase 2: Data Processing </h1>
                <div class="container">
                    <form action="#" name="form1" id="form1" method="GET" onsubmit="return confirm('Please confirm: Start Processing');">
                        <div class="row">
                            <div class="col-25">
                                <label for="fname">Ecodigo for registries:</label>
                            </div>
                            <div class="col-75">
                                <cfoutput>
                                    <input type="text" <cfif isDefined('url.e')>value="#url.e#" id="e" readonly</cfif> name="e" placeholder="Enterprise code">
                                </cfoutput>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-25">
                                <label for="tname">Processing Table:</label>
                            </div>
                            <div class="col-75">
                                <cfoutput>
                                    <input type="text" id="t" name="t" value="#url.t#" readonly>
                                </cfoutput>
                            </div>
                        </div>
                        <div class="row">
                            <cfif !isDefined('url.e')>
                                <cfset StructDelete(Session, "progressE",true) />
                                <cfset session.progressB = 0>
                                <cfset session.progressM = "Starting">
                                <input type="Submit" value="Submit">
                            <cfelse>
                                <cfset ProcesarGUI = true>
                                <div class="col-25">
                                    <label for="pname">Processing Progress:</label>
                                </div>
                                <div class="col-75" id="progressBar">
                                    <iframe frameBorder="0" height="40px" width="100%" name="progressFrame" src="importador.cfm?progress=1"> </iframe>
                                </div>
                            </cfif>
                        </div>
                    </form>
                </div>
        </body>
    </html>
<cfelse>
    <div class="col-75" id="progressBar">
        <cfoutput>
            <progress value="#session.progressB#" max="100"> </progress>&emsp;#session.progressB#% - #session.progressM#...
        </cfoutput>
    </div>
</cfif>

<cfif isDefined('url.e') && !isDefined('url.r')>
    <cfthread name="processingTable" action="run" priority="NORMAL">
        <cfif !isDefined('session')><cfset session = structNew()></cfif>
        <cfset StructDelete(Session, "progressE",true) />
        <cfset session.progressB = 0>
        <cfset session.progressM = "Starting">
        <cfset session.dsn     = "minisif">
        <cfset session.ecodigo = url.e>
        <cfset table_name = url.t>
        <cftry>
            <cfif url.t eq 'CRCImpTR_D'><cfinclude  template="/crc/administracion/importadores/ImportarTransacciones.cfm">
            <cfelseif url.t eq 'CRCImpCP_D'><cfinclude  template="/crc/administracion/importadores/ImportarCalendarioPagos.cfm">
            <cfelseif url.t eq 'CRCImpRC_D'><cfinclude  template="/crc/administracion/importadores/ImportarResumenCorte.cfm">
            <cfelse>
                <cfset session.progressM = "<font color='red'>ERROR: Script for table [#url.t#] was not found </font>">
                <cfset session.progressB = 0>
            </cfif>
        <cfcatch>
            <cfset session.progressE = true>
            <cfset session.progressM = cfcatch.message>
        </cfcatch>
        </cftry>
    </cfthread>
</cfif>

<cfif isDefined('url.e') && session.progressB lt 100 && !isDefined('session.progressE')>
    <cfoutput>
        <script>
            setTimeout(function(){window.location.href = "importador.cfm?e=#url.e#&t=#url.t#&r=1";}, 1000);
        </script>
    </cfoutput>
</cfif>
