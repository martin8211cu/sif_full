<cfsilent>
    <cfif ThisTag.ExecutionMode NEQ "START">
	    <cfreturn>
    </cfif>
    <cfparam name = "Attributes.queryReport" type = "query">
    <cfparam name = "Attributes.isLink" type = "boolean" default = "False">
    <!--- 1 = EXCEL, 2 = SIMPLE PDF, 3 = GROUPER PDF--->
    <cfparam name = "Attributes.typeReport" type = "numeric" default = 1>
    <cfparam name = "Attributes.linkTitle" type = "string" default = "Descargar reporte">
    <!--- Example : cfmx/sif/../.. --->
    <cfparam name = "Attributes.urlToReturn" type = "string" default = "">
    <cfparam name = "Attributes.fileName" type = "string" default = "file">
    <cfparam name = "Attributes.addDateToFile" type = "boolean" default = "False">
    <!--- Example : column1,column2,column3 --->
    <cfparam name = "Attributes.groupColumns" type = "string" default = "">
     <!--- Example : attr1,attr2,attr3 --->
    <cfparam name = "Attributes.headers" type = "string" default = "">
</cfsilent>

<cfquery name="rsUrl" datasource="#Session.DSN#">
	select Pvalor as valParam
	from Parametros
	where Pcodigo = 20000
	and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rsusr" datasource="#Session.DSN#">
	select Pvalor as valParam
	from Parametros
	where Pcodigo = 20001
	and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rspass" datasource="#Session.DSN#">
	select Pvalor as valParam
	from Parametros
	where Pcodigo = 20002
	and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rsidexcel" datasource="#Session.DSN#">
	select Pvalor as valParam
	from Parametros
	where Pcodigo = 20003
	and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rsidpdffactura" datasource="#Session.DSN#">
	select Pvalor as valParam
	from Parametros
	where Pcodigo = 20004
	and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rsidpdfsimple" datasource="#Session.DSN#">
	select Pvalor as valParam
	from Parametros
	where Pcodigo = 20005
	and Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rsidpdfgrouper" datasource="#Session.DSN#">
	select Pvalor as valParam
	from Parametros
	where Pcodigo = 20006
	and Ecodigo = #Session.Ecodigo#
</cfquery>

<cfset currentUrl = '#getPageContext().getRequest().getScheme()#://#cgi.server_name#:#cgi.server_port#/'>
<cfset currentDatetime = DateFormat(Now(),"dd-mm-yyyy") & " " & TimeFormat(Now(), "HH:mm:ss tt")>
<cfset extentionFile = "xlsx">
<cfset recipe = "html-to-xlsx">
<cfset shortid = "#rsidexcel.valParam#">
<cfif Attributes.typeReport EQ 1>
    <cfset extentionFile = "xlsx">
    <cfset recipe = "html-to-xlsx">
    <cfset shortid = "#rsidexcel.valParam#">
<cfelseif Attributes.typeReport EQ 2>
    <cfset extentionFile = "pdf">
    <cfset recipe = "chrome-pdf">
    <cfset shortid = "#rsidpdfsimple.valParam#">
<cfelseif Attributes.typeReport EQ 3>
    <cfset extentionFile = "pdf">
    <cfset recipe = "chrome-pdf">
    <cfset shortid = "#rsidpdfgrouper.valParam#">
</cfif>
<cfset nameForFile = Attributes.fileName & "." &extentionFile>
<cfif Attributes.addDateToFile>
    <cfset nameForFile = Attributes.fileName & "_" & currentDatetime & "." &extentionFile>
</cfif>

<!--- COLUMNS --->
<cfset columnsData = arrayNew(1)>
<cfloop array="#Attributes.queryReport.getColumnList()#" item="repColumn">
	<cfset strCol = structNew()>
	<cfset strCol = {"name"="#repColumn#","label"="#repColumn#"}>
    <cfloop array="#listToArray(Attributes.groupColumns,',',false,true)#" item="gColumn" index="gcidx">
        <cfif UCase(gColumn) EQ UCase(repColumn)>
            <cfset strCol = {"name"="#repColumn#","label"="#repColumn#", "groupByOrder" = "#Int(gcidx)#"}>
            <cfbreak>
        </cfif>
    </cfloop>
	<cfset arrayAppend(columnsData, strCol)>
</cfloop>
<!--- HEADERS --->
<cfset strHeader = structNew()>
<cfloop array="#listToArray(Attributes.headers,',',false,true)#" item="header">
    <cfset itmHA = listToArray(header,':',false,true)>
    <cfset StructAppend(strHeader, {"#itmHA[1]#" : "#itmHA[2]#"}, true)>
</cfloop>

<cfset dataJSReports ='{
	"template" : { 
		"shortid" : "#shortid#" ,
		"recipe" : "#recipe#",
		"engine" : "handlebars"
	},
	"data" : {
		"data" : #serializeJSON(Attributes.queryReport, 'struct')#,
		"columns" : #serializeJSON(columnsData)#,
        "header" : #serializeJSON(strHeader)#
	}
}'>

<style type = "text/css">
    .linkStyle {
        cursor: pointer;
        background-image: url(/cfmx/plantillas/erp/img/botones/guardar_bg.png);
        min-width: 28px;
        background-color: #fff;
        border: thin;
        border-style: solid;
        background-repeat: no-repeat;
        background-position: left;
        border-radius: 4px;
        color: #656565;
        font-family: Arial,Verdana,Helvetica,sans-serif;
        cursor: pointer;
        text-align: center;
        -webkit-transition-duration: .2s;
        -moz-transition-duration: .2s;
        transition-duration: .2s;
        margin: 4px;
        padding: 5px 7px 5px 33px!important;
        text-align: left!important;
    }

    .linkStyle:hover {
        background-image: url(/cfmx/plantillas/erp/img/botones/guardar_bg_over.png);
        background-color: #3087a3;
        color: #FFF;
        border-color: #3087A3!important;
        border: thin;
        border-style: solid;
    }

    .linkStyle:disabled {
        background-color: #d3d3d3;
    }
</style>

<cfoutput>
    <cfif Attributes.isLink>
        <button id = "jsr_buttonToDownloadReport" onclick = "GetReport()" 
            class = "linkStyle">#Attributes.linkTitle#</button>
    </cfif>

    <script type="text/javascript">
        function GetReport() {
            <cfif Attributes.isLink>
                var btnDownload = document.getElementById("jsr_buttonToDownloadReport");
                btnDownload.disabled = true;
            </cfif>
            var req = new XMLHttpRequest();
		    req.open("POST", "#rsUrl.valParam#", true);
		    req.responseType = "blob";
			req.setRequestHeader("Content-Type", "application/json");
			req.setRequestHeader('Authorization', 'Basic ' + btoa('#rsusr.valParam#:#rspass.valParam#'));
			req.onload = function (event) {
				var blob = req.response;
				if (navigator.msSaveOrOpenBlob) { //IE
					navigator.msSaveOrOpenBlob(blob, "#nameForFile#");
                    <cfif Attributes.urlToReturn NEQ "" && !Attributes.isLink>
					    window.location.href = "#currentURL##Attributes.urlToReturn#";
                    <cfelseif Attributes.urlToReturn EQ "" && !Attributes.isLink>
                        window.history.go(-1);
                    </cfif>
				}
				else {
					var downloadUrl = URL.createObjectURL(blob);
					var a = document.createElement("a");
					a.href = downloadUrl;
					a.download = "#nameForFile#";
					a.click();
                    <cfif Attributes.urlToReturn NEQ "" && !Attributes.isLink>
					    window.location.href = "#currentURL##Attributes.urlToReturn#";
                    <cfelseif Attributes.urlToReturn EQ "" && !Attributes.isLink>
                         window.history.go(-1);
                    </cfif>
				}
                <cfif Attributes.isLink>
                    btnDownload.disabled = false;
                </cfif>
			};	
			//SEND DATA			
			req.send(JSON.stringify(#dataJSReports#));
        }
        <cfif not Attributes.isLink>
            GetReport();
        </cfif>
    </script>
</cfoutput>