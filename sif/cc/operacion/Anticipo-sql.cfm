<cfparam name="param" default="">
<cfif isdefined("Form.btnGenerar") and Form.btnGenerar EQ 'Aceptar'>
		<cfinvoke component="sif.Componentes.CC_Anticipos" method="CC_AltaAnticipo" returnvariable="LineAnticipo">
				<cfinvokeargument name="Conexion" 	    value="#session.dsn#">
				<cfinvokeargument name="Ecodigo"        value="#session.Ecodigo#">
				<cfinvokeargument name="CCTcodigo"      value="#form.CCTcodigo#">
				<cfinvokeargument name="Pcodigo"       	value="#form.Pcodigo#">
			<cfif isdefined('form.id_direccion') and LEN(TRIM(form.id_direccion))>
				<cfinvokeargument name="id_direccion"   value="#form.id_direccion#">
			 </cfif>
				<cfinvokeargument name="NC_CCTcodigo"   value="#form.NC_CCTcodigo#">
				<cfinvokeargument name="NC_Ddocumento"  value="#form.NC_Ddocumento#">
				<cfinvokeargument name="NC_Ccuenta"     value="#form.Ccuenta#">
				<cfinvokeargument name="NC_total"       value="#form.NC_total#">
				<cfinvokeargument name="NC_RPTCietu"    value="#form.NC_RPTCietu#">
			 <cfif form.NC_RPTCietu EQ 3>
				<cfinvokeargument name="NC_RPTCid"      value="#form.NC_RPTCid#">
			 </cfif>
				<cfinvokeargument name="BMUsucodigo"    value="#session.Usucodigo#">
		</cfinvoke>
	<cfset param &="&CCTcodigo=#form.CCTcodigo#&Pcodigo=#form.Pcodigo#&NC_linea=#LineAnticipo#&reload='true'">
<cfelseif isdefined('form.btnBorrar')>
		<cfinvoke component="sif.Componentes.CC_Anticipos" method="CC_BajaAnticipo">
				<cfinvokeargument name="Conexion" 	    value="#session.dsn#">
				<cfinvokeargument name="CCTcodigo"      value="#form.CCTcodigo#">
				<cfinvokeargument name="Pcodigo"       	value="#form.Pcodigo#">
				<cfinvokeargument name="NC_linea"       value="#form.LineAnticipo#">
		</cfinvoke>
		<cfset param &="&CCTcodigo=#form.CCTcodigo#&Pcodigo=#form.Pcodigo#&reload='true'">
<cfelseif isdefined('form.btnModificar')>
		<cfinvoke component="sif.Componentes.CC_Anticipos" method="CC_CambioAnticipo">
				<cfinvokeargument name="Conexion" 	    value="#session.dsn#">
				<cfinvokeargument name="CCTcodigo"      value="#form.CCTcodigo#">
				<cfinvokeargument name="Pcodigo"       	value="#form.Pcodigo#">
				<cfinvokeargument name="NC_linea"       value="#form.LineAnticipo#">
			<cfif isdefined('form.id_direccion') and LEN(TRIM(form.id_direccion))>
				<cfinvokeargument name="id_direccion"   value="#form.id_direccion#">
			 </cfif>
				<cfinvokeargument name="NC_CCTcodigo"   value="#form.NC_CCTcodigo#">
				<cfinvokeargument name="NC_Ddocumento"  value="#form.NC_Ddocumento#">
				<cfinvokeargument name="NC_Ccuenta"     value="#form.Ccuenta#">
				<cfinvokeargument name="NC_total"       value="#form.NC_total#">
				<cfinvokeargument name="NC_RPTCietu"    value="#form.NC_RPTCietu#">
			 <cfif form.NC_RPTCietu EQ 3>
				<cfinvokeargument name="NC_RPTCid"      value="#form.NC_RPTCid#">
			 </cfif>
				<cfinvokeargument name="BMUsucodigo"    value="#session.Usucodigo#">
		</cfinvoke>
		<cfset param &="&CCTcodigo=#form.CCTcodigo#&Pcodigo=#form.Pcodigo#&NC_linea=#form.LineAnticipo#&reload='true'">
<cfelseif isdefined('form.btnNuevo')>
	<cfset param &="&CCTcodigo=#form.CCTcodigo#&Pcodigo=#form.Pcodigo#">
</cfif>
<cflocation url="Anticipo.cfm?#param#">