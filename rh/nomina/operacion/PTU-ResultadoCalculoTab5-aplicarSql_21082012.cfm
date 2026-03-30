<!--- <cfdump var="#form#">
<cf_dump var="#url#">
 --->
<cfflush interval=20>
<cfoutput>
Aplicando... Por favor espere.<br>
<table>
	<tr>
		<td>Procesando</td>
		<td>Cuentas Tipo</td>
	</tr>
</cfoutput>
	<cfif isdefined("form.butAplicar")>
    	<cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="AplicaNomina" returnvariable="NewERNid">
            <cfinvokeargument name="RCNid" 			value="#Form.RCNid#">
            <cfinvokeargument name="Bid"  			value="#Form.Bid#">
            <cfinvokeargument name="CBid"  			value="#Form.CBid#">
            <cfinvokeargument name="Lvar_Regresar"  value="/cfmx/rh/nomina/operacion/PTU.cfm">
            <cfinvokeargument name="Mcodigo"  		value="#Form.Mcodigo#">
            <cfinvokeargument name="CBcc"  			value="#Form.CBcc#">
        </cfinvoke>
  	</cfif>
<cfoutput>
</table>
</cfoutput>

<!--- <cflocation url="RelacionCalculo-lista.cfm" addtoken="no">
<cflocation url="RelacionCalculo-lista.cfm" addtoken="yes"> --->


<form action="PTU.cfm" method="post">
<input name="RHPTUEid" type="hidden" value="<cfoutput>#form.RHPTUEid#</cfoutput>" />
<input name="a" type="hidden" value="0" />
<input name="Tab" type="hidden" value="5" />
</form>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
