<cfset consultar_Ecodigo = url.Ecodigo>
<cfset url.ESestado=20>

	<form name="form1">
	<cfinclude template="MisSolicitudes-vistaForm.cfm">
        <div align="center">
            <cfinvoke component="sif.Componentes.Translate"
                    method="Translate"
                    Key="BTN_Regresar"
                    Default="Regresar"
                    XmlFile="/sif/generales.xml"
                    returnvariable="BTN_Regresar"/>
                	
                <input type="button" onClick="location.href = '/cfmx/proyecto7/<cfoutput>#url.from#</cfoutput>.cfm';" value="&lt;&lt; <cfoutput>#BTN_Regresar#</cfoutput>" tabindex="1">
        </div>
</form>