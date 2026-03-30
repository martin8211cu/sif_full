<cfsetting requestTimeout = "360000">
<cf_templatecss>
<cfflush interval="20">
<cfset action = "RelacionCalculoEsp-lista.cfm">

<cfif isdefined("Form.btnAplicar")>
	<cfset action = "ResultadoCalculoEsp-lista.cfm">
    	<HTML><head></head><body>
		<cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="AltaNominaEspecial">
            	<cfinvokeargument name="RCNid" 	  		 value="#Form.RCNid#">
            	<cfinvokeargument name="RCDescripcion" 	 value="#Form.RCDescripcion#">
            <cfif isdefined('form.RCporcentaje') and LEN(TRIM(form.RCporcentaje))>
             	<cfinvokeargument name="RCporcentaje" 	 value="#replace(form.RCporcentaje, ',', '')#">
            </cfif>
            <cfif isdefined('form.CIid') and LEN(TRIM(form.CIid))>
            	<cfinvokeargument name="CIid" 			 value="#form.CIid#">
            </cfif>  
            <cfif isdefined('form.RCpagoentractos')>
            	<cfinvokeargument name="RCpagoentractos" value="true">
            </cfif>  
        </cfinvoke>
		</body></HTML>
</cfif>

<cfoutput>
    <form action="#action#" method="post" name="sql">
        <input name="RCNid"   type="hidden" value="#Form.RCNid#">
        <input name="RCDesde" type="hidden" value="#Form.RCDesde#">
        <input name="RCHasta" type="hidden" value="#Form.RCHasta#">
    </form>
</cfoutput>

<HTML>
	<head></head>
    <body>
    	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
    </body>
</HTML>