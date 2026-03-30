<cfif  isdefined("form.butAplicar")>
	<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
	<cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="AplicaNomina">
            <cfinvokeargument name="RCNid" 			value="#Form.RCNid#">
            <cfinvokeargument name="Bid"  			value="#Form.Bid#">
            <cfinvokeargument name="CBid"  			value="#Form.CBid#">
            <cfinvokeargument name="Lvar_Regresar"  value="/cfmx/rh/nomina/operacion/RelacionCalculoEsp-lista.cfm">
            <cfinvokeargument name="tipo_cambio"  	value="1">  
            <cfinvokeargument name="Mcodigo"  		value="#Form.Mcodigo#">
            <cfinvokeargument name="CBcc"  			value="#Form.CBcc#">
        <cfif isdefined('form.btnSeguir')>
            <cfinvokeargument name="btnSeguir"  	value="#Form.btnSeguir#">
        </cfif>
	</cfinvoke>
</cfif>
<html>
	<body>
        <form action="/cfmx/rh/nomina/operacion/RelacionCalculoEsp-lista.cfm" method="post">
          <input name="a" type="hidden" value="0" />
        </form>
        <script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>