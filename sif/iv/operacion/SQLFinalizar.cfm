<cfsetting requesttimeout="#3600*24#">

<cfset action = "Transforma-form7.cfm">

<cfif isdefined("Form.btnGuardar") or isdefined("Form.btnFinalizar")>
	<cfloop collection="#Form#" item="i">
		<cfif FindNoCase("costou_", i) NEQ 0>
			<!--- Codigo de linea de Transformacion --->
			<cfset TPid = Mid(i, 8, Len(i))> 

			<!--- Actualizar los costos unitarios de los artículos --->
			<cfquery name="updTransformacionProducto" datasource="#Session.DSN#">
				update TransformacionProducto set
					costou = <cfqueryparam cfsqltype="cf_sql_money" value="#Form[i]#">,
					costototal = round(<cfqueryparam cfsqltype="cf_sql_float" value="#Form[i]#"> * cant,2),
					costolin = round(<cfqueryparam cfsqltype="cf_sql_float" value="#Form[i]#"> * cant,2)
				where TPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#TPid#">
			</cfquery>
			
		</cfif>
		
	</cfloop>
</cfif>

<cfif isdefined("form.btnFinalizar")>
	<cfinvoke 
		Component="sif.Componentes.IN_TransformacionProducto2" 
		method="IN_TransformacionProducto2"
		ETid="#Form.ETid#"
		Debug = "false"
		RollBack = "false"
		returnvariable="resultados"
	/>
	<cfset action = "Transforma.cfm">
</cfif>

<cfoutput>
	<form action="#action#" method="post" name="sql">
		<input name="ETid" type="hidden" value="<cfif isdefined("Form.ETid")>#Form.ETid#</cfif>">
		<cfif isdefined("Form.btnFinalizar")>
			<input name="btnFinalizar" type="hidden" value="<cfif isdefined("Form.btnFinalizar")>#Form.btnFinalizar#</cfif>">
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
