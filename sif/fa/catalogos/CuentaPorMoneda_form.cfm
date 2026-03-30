<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->
<cfif modo NEQ "ALTA">
	<cfquery name="rsCuentaPorMoneda" datasource="#Session.DSN#">
		Select Ecodigo, Bid ,CBid, Mcodigo, BTid, CBPMid, ts_rversion
		from CuentasPorMoneda
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and CBPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBPMid#">
	</cfquery>
</cfif>

<cfquery name="rsBancos" datasource="#Session.DSN#">
	select Bdescripcion, Bid
    from Bancos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>


<cfif modo eq 'Alta'>
	<cfquery name="rsMonedas" datasource="#Session.DSN#">
		select -1 as Mcodigo from dual
	</cfquery>

      <cfquery name="rsBTid" datasource="#Session.DSN#">
		select BTdescripcion , BTid
        from BTransacciones
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
 <cfelse>
 <cfquery name="rsMonedas" datasource="#Session.DSN#">
		select Mcodigo, Mnombre
        from Monedas
        where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
   <cfquery name="rsBTid" datasource="#Session.DSN#">
		select  BTdescripcion, a.BTid
        from CuentasPorMoneda a
        inner join BTransacciones b
        on a.BTid = b.BTid
        and a.Ecodigo = b.Ecodigo
       	where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and CBPMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBPMid#">
	</cfquery>


</cfif>

<form action="<cfoutput>#LvarSQLPagina#</cfoutput>" method="post" name="form1" onSubmit="javascript: return validar(); ">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">

  <tr>
  <td nowrap="nowrap" align="right">
				Tipo de Transacci&oacute;n:
			</td>
			<td>
				<select name="BTid" tabindex="5">
			<option value="">-- Tipo transacciones --</option>
			<cfloop query="rsBTid">
            <cfoutput>
				<option value="#rsBTid.BTid#" <cfif modo neq "ALTA" and rsCuentaPorMoneda.BTid eq rsBTid.BTid>selected</cfif>>#rsBTid.BTdescripcion#</option>
             </cfoutput>
			</cfloop>
		</select>
			</td>
  </tr>

  <tr>
			<td nowrap="nowrap" align="right">Banco:&nbsp;</td>
			<td>

		<select name="Bid" tabindex="5" onchange="javascript:limpiarCuenta();">
			<option value="">-- Seleccione un Banco --</option>
			<cfloop query="rsBancos">
            <cfoutput>
				<option value="#rsBancos.Bid#" <cfif modo neq "ALTA" and rsCuentaPorMoneda.Bid eq rsBancos.Bid>selected</cfif>>#rsBancos.Bdescripcion#</option>
             </cfoutput>
			</cfloop>
		</select>
<!---				<select name="Bid" tabindex="1" >
					<cfoutput query="rsBancoDes">
						<option value="#rsBancoDes.Bdescripcion#"
							<cfif modo NEQ "ALTA">selected</cfif>>
							#rsBancoDes.Bdescripcion#
						</option>
					</cfoutput>
				</select>--->
			</td>
 </tr>
 	<cfoutput>
		<tr>
        <td nowrap="nowrap" align="right">Moneda:&nbsp;</td>
			<td><cf_sifmonedas Conexion="#session.DSN#" form="form1" query="#rsMonedas#" Mcodigo="Mcodigo" tabindex="1"></td>
			<input type="hidden" name="McodigoS" value="">
		</tr>
		</cfoutput>
  		 <tr>
			<td nowrap="nowrap" align="right">Cuenta Bancaria:&nbsp;</td>
			<td>
            <cfif modo eq 'ALTA'>
				<cf_conlis title="Lista de Cuentas Bancarias"
			campos = "CBid, CBcodigo, CBdescripcion, Mcodigo"
			desplegables = "N,S,S,N"
			modificables = "N,S,N,N"
			size = "0,0,40,0"
			tabla="CuentasBancos cb
					inner join Monedas m
					on cb.Mcodigo = m.Mcodigo
					inner join Empresas e
					on e.Ecodigo = cb.Ecodigo"
			columnas="cb.CBid, cb.CBcodigo, cb.CBdescripcion, cb.Mcodigo,
						m.Mnombre"
			filtro="cb.Ecodigo = #Session.Ecodigo# and cb.CBesTCE = 0 and cb.CBestado = 1 and cb.Bid = $Bid,numeric$"
			desplegar="CBcodigo, CBdescripcion"
			etiquetas="Código, Descripción"
			formatos="S,S"
			align="left,left"
			asignar="CBid, CBcodigo, CBdescripcion, Mcodigo, Mnombre"
			asignarformatos="S,S,S,S,S,F"
			showEmptyListMsg="true"
			debug="false"
			tabindex="6">
            <cfelse>
            <cfset valuesArray = ArrayNew(1)>

              <cfquery name = "rsCuentas" datasource="#session.DSN#">
           select a.CBid, b.CBcodigo, b.CBdescripcion, a.Mcodigo from CuentasPorMoneda a
					inner join CuentasBancos b
					on a.CBid = b.CBid
					and a.Ecodigo = b.Ecodigo
			where a.Ecodigo = #Session.Ecodigo# and a.CBid = #rsCuentaPorMoneda.CBid# and a.Bid = #rsCuentaPorMoneda.Bid#
            </cfquery>

			<cfset ArrayAppend(valuesArray, rsCuentas.CBid)>
			<cfset ArrayAppend(valuesArray, rsCuentas.CBcodigo)>
			<cfset ArrayAppend(valuesArray, rsCuentas.CBdescripcion)>
			<cfset ArrayAppend(valuesArray, rsCuentas.Mcodigo)>

            	<cf_conlis title="Lista de Cuentas Bancarias"
			campos = "CBid, CBcodigo, CBdescripcion, Mcodigo"
			desplegables = "N,S,S,N"
			modificables = "N,S,N,N"
			size = "0,0,40,0"
            valuesArray="#valuesArray#"
			tabla="CuentasBancos cb
					inner join Monedas m
					on cb.Mcodigo = m.Mcodigo
					inner join Empresas e
					on e.Ecodigo = cb.Ecodigo"
			columnas="cb.CBid, cb.CBcodigo, cb.CBdescripcion, cb.Mcodigo,
						m.Mnombre"
			filtro="cb.Ecodigo = #Session.Ecodigo# and cb.CBesTCE = 0 and cb.CBestado = 1 and cb.Bid = $Bid,numeric$"
			desplegar="CBcodigo, CBdescripcion"
			etiquetas="Código, Descripción"
			formatos="S,S"
			align="left,left"
			asignar="CBid, CBcodigo, CBdescripcion, Mcodigo, Mnombre"
			asignarformatos="S,S,S,S,S,F"
			showEmptyListMsg="true"
			debug="false"
			tabindex="6">

            </cfif>

   			</td>
   </tr>

  <tr>
  	<td nowrap colspan="2">
		<cfif modo NEQ "ALTA">
			<cfset ts = "">
			<cfinvoke
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsCuentaPorMoneda.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<cfif modo NEQ "ALTA">
			<cfoutput>
				<input type="hidden" name="CBPMid" value="#rsCuentaPorMoneda.CBPMid#">
				<input type="hidden" name="ts_rversion" value="#ts#">
               <!--- <input type="hidden" name="Bid" value="#rsCuentaPorMoneda.Bid#">
				<input type="hidden" name="CBid" value="#rsCuentaPorMoneda.CBid#">
                <input type="hidden" name="Mcodigo" value="#rsCuentaPorMoneda.Mcodigo#">--->


			</cfoutput>
		</cfif>
	</td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
 	<tr>
		<td>&nbsp;</td>
	</tr>
  <tr>
  	<td nowrap align="center">
		<cf_botones modo="#modo#">
	</td>
  </tr>
</table>
</form>
<script language="JavaScript1.2" type="text/javascript">
function validar()
		{
 		 var mensaje = '';
		   if (document.form1.BTid.value == '')
		   {
			   mensaje = 'La transaccion es requerida. \n'
		   }
		   if (document.form1.Bid.value == '')
		   {
			   mensaje += 'El banco es requerido. \n'
		   }
		   if (document.getElementById('Mcodigo').options[document.getElementById('Mcodigo').options.selectedIndex].value == '')
		   {
			    mensaje += 'La moneda es requerida. \n'
		   }
		   if (document.form1.CBid.value == '' || document.form1.CBcodigo.value == '' || document.form1.CBdescripcion.value == ''  )
		   {
			    mensaje += 'La cuenta bancaria es requerida. \n'
		   }

		   if( mensaje != '')
		   {
			 alert("Se han presentado los siguientes errores: \n" + mensaje );
			 return false;
		   }
		   else{
		   	   document.form1.McodigoS.value = document.getElementById('Mcodigo').options[document.getElementById('Mcodigo').options.selectedIndex].value;
  		       return true;
  		    }

		}
function limpiarCuenta()
		{
		   document.form1.CBid.value = '';
		   document.form1.CBcodigo.value = '';
		   document.form1.CBdescripcion.value = '';
		}
</script>
