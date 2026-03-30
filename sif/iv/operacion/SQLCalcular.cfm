<cfsetting requesttimeout="#3600*24#">

<cfif isdefined("form.btnCalcular")>
		 <cfinvoke 
		 Component="sif.Componentes.IN_TransformacionProducto" 
		 method="IN_TransformacionProducto"
		 returnvariable="rsRango">
		 <cfinvokeargument name="ETid" value="#Form.ETid#"/>
		</cfinvoke> 
		
		<!--- <cfinvoke 
		Component="sif.Componentes.IN_TransformacionProducto" 
		method="IN_TransformacionProducto"
		ETid="#Form.ETid#"
		Debug = "False"
		RollBack = "False"
		returnvariable="rsRango"/> --->
		
</cfif>
<cfoutput>
	<form action="Transforma-form6.cfm" method="post" name="sql">
		<input name="ETid" type="hidden" value="<cfif isdefined("Form.ETid")>#Form.ETid#</cfif>">
		<cfif isdefined("Form.btnCalcular")>
			<input name="Calcular" type="hidden" value="#Form.btnCalcular#">
		</cfif>
	</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>