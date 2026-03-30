<cfset param = "IDpago=#form.IDpago#">
<cfif isdefined("Form.btnGenerar") and Form.btnGenerar EQ 'Aceptar'>	
		<cfinvoke component="sif.Componentes.CP_Anticipos" method="CP_AltaAnticipo" returnvariable="LineAnticipo">
				<cfinvokeargument name="Conexion" 	    value="#session.dsn#">
				<cfinvokeargument name="IDpago"       	value="#form.IDpago#">
			<cfif isdefined('form.id_direccion') and LEN(TRIM(form.id_direccion))>
				<cfinvokeargument name="id_direccion"   value="#form.id_direccion#">
			 </cfif>
				<cfinvokeargument name="NC_CPTcodigo"   value="#form.NC_CPTcodigo#">
				<cfinvokeargument name="NC_Ddocumento"  value="#form.NC_Ddocumento#">
				<cfinvokeargument name="NC_Ccuenta"     value="#form.Ccuenta#">
				<cfinvokeargument name="NC_total"       value="#form.NC_total#">
				<cfinvokeargument name="NC_RPTCietu"    value="#form.NC_RPTCietu#">
			 <cfif form.NC_RPTCietu EQ 3>
				<cfinvokeargument name="NC_RPTCid"      value="#form.NC_RPTCid#">
			 </cfif>
				<cfinvokeargument name="BMUsucodigo"    value="#session.Usucodigo#">
		</cfinvoke>
	<cfset param &="&NC_linea=#LineAnticipo#&reload='true'">
<cfelseif isdefined('form.btnBorrar')>
		<cfinvoke component="sif.Componentes.CP_Anticipos" method="CP_BajaAnticipo">
				<cfinvokeargument name="Conexion" 	    value="#session.dsn#">
				<cfinvokeargument name="IDpago"       	value="#form.IDpago#">
				<cfinvokeargument name="NC_linea"       value="#form.LineAnticipo#">
		</cfinvoke>
		<cfset param &="&reload='true'">
<cfelseif isdefined('form.btnModificar')>
		<cfinvoke component="sif.Componentes.CP_Anticipos" method="CP_CambioAnticipo">
				<cfinvokeargument name="Conexion" 	    value="#session.dsn#">
				<cfinvokeargument name="IDpago"       	value="#form.IDpago#">
				<cfinvokeargument name="NC_linea"       value="#form.LineAnticipo#">
			<cfif isdefined('form.id_direccion') and LEN(TRIM(form.id_direccion))>
				<cfinvokeargument name="id_direccion"   value="#form.id_direccion#">
			 </cfif>
				<cfinvokeargument name="NC_CPTcodigo"   value="#form.NC_CPTcodigo#">
				<cfinvokeargument name="NC_Ddocumento"  value="#form.NC_Ddocumento#">
				<cfinvokeargument name="NC_Ccuenta"     value="#form.Ccuenta#">
				<cfinvokeargument name="NC_total"       value="#form.NC_total#">
				<cfinvokeargument name="NC_RPTCietu"    value="#form.NC_RPTCietu#">
			 <cfif form.NC_RPTCietu EQ 3>
				<cfinvokeargument name="NC_RPTCid"      value="#form.NC_RPTCid#">
			 </cfif>
				<cfinvokeargument name="BMUsucodigo"    value="#session.Usucodigo#">
		</cfinvoke>
		<cfset param &="&NC_linea=#form.LineAnticipo#&reload='true'">
</cfif>
<cflocation url="Anticipo.cfm?#param#">