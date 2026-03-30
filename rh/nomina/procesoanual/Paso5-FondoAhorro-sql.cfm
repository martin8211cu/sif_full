<!---<cfdump var="#form#">
<cf_dump var="#url#">--->
 
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
            <cfinvokeargument name="Lvar_Regresar"  value="/cfmx/rh/nomina/procesoanual/FondoAhorro-form.cfm?tab=4">
            <cfinvokeargument name="Mcodigo"  		value="#Form.Mcodigo#">
            <cfinvokeargument name="CBcc"  			value="#Form.CBcc#">
        </cfinvoke>
  	</cfif>
<cfoutput>
</table>
</cfoutput>


<form action="FondoAhorro-form.cfm" method="post">
<input name="RHCFOAid" type="hidden" value="<cfoutput>#form.RHCFOAid#</cfoutput>" />
<input name="tab" type="hidden" value="4" />
</form>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>

