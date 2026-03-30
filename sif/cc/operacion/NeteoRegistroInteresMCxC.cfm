<cfif isdefined('url.DocIntMora') and not isdefined('form.DocIntMora')>
	<cfset form.DocIntMora = url.DocIntMora>
</cfif>
<cfif isdefined('url.SNcodigo') and not isdefined('form.SNcodigo')>
	<cfset form.SNcodigo = url.SNcodigo >
</cfif>
<cfif isdefined('url.SNcodigo2') and not isdefined('form.SNcodigo2')>
	<cfset form.SNcodigo2 = url.SNcodigo2 >
</cfif>
<cfif isdefined('url.Corte') and not isdefined('form.Corte')>
	<cfset form.Corte = url.Corte >
</cfif>
<cfif isdefined('url.Cid') and not isdefined('form.Cid')>
	<cfset form.Cid = url.Cid >
</cfif>
<cfif isdefined('url.CCTcodigoE') and not isdefined('form.CCTcodigoE')>
	<cfset form.CCTcodigoE = url.CCTcodigoE >
</cfif>
<cfif isdefined('url.Tasa') and not isdefined('form.Tasa')>
	<cfset form.Tasa = url.Tasa >
</cfif>

<cfquery name="rsImpuestos" datasource="#Session.DSN#">
	select Icodigo, Idescripcion from Impuestos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Idescripcion                                 
</cfquery>


<cfquery name="rsTransacciones" datasource="#session.dsn#">
	select CCTcodigo, CCTdescripcion
	from CCTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and CCTtipo = 'D' 
	order by 1
</cfquery>
	<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>
	<cfoutput>
		<fieldset><legend>Filtro para Selecci&oacute;n de Documentos</legend>
		<table width="85%" align="center"  border="0" cellspacing="2" cellpadding="2">
			<tr><td colspan="2"><strong>Clasificaci&oacute;n</strong></td></tr>
			<tr>
				<td>
					<cfif isdefined('form.SNCEid') and form.SNCEid GT 0>
						<cfquery name="rsClasif" datasource="#session.DSN#">	
							select SNCEid, SNCEcodigo, SNCEdescripcion
							from SNClasificacionE
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCEid#">
						</cfquery>
						<cf_sifSNClasificacion form="form1" tabindex="1" query="#rsClasif#">
					<cfelse>
						<cf_sifSNClasificacion form="form1" tabindex="1">
					</cfif>
				</td>
			</tr>
			<tr>
				<td><strong>Valor&nbsp;Clasificaci&oacute;n&nbsp;Desde</strong></td>
				<td><strong>Valor&nbsp;Clasificaci&oacute;n&nbsp;Hasta</strong></td>
			</tr>
			<tr>
				<td width="10%" nowrap>
					<cfif isdefined('form.SNCDid1') and form.SNCDid1 GT 0>
						<cfquery name="rsValor" datasource="#session.DSN#">	
							select SNCDid as SNCDid1, SNCDvalor as SNCDvalor1, SNCDdescripcion as SNCDdescripcion1
							from SNClasificacionD
							where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCDid1#">
						</cfquery>
						<cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid1" name="SNCDvalor1" 
							desc="SNCDdescripcion1" tabindex="1" query="#rsValor#">
					<cfelse>
						<cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid1" name="SNCDvalor1" 
							desc="SNCDdescripcion1" tabindex="1">
					</cfif>	
				</td>
				<td width="10%" nowrap>
					<cfif isdefined('form.SNCDid2') and form.SNCDid2 GT 0>
						<cfquery name="rsValor" datasource="#session.DSN#">	
							select SNCDid as SNCDid2, SNCDvalor as SNCDvalor2, SNCDdescripcion as SNCDdescripcion2
							from SNClasificacionD
							where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCDid2#">
						</cfquery>
						<cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid2" name="SNCDvalor2" desc="SNCDdescripcion2" 
							tabindex="1" query="#rsValor#">
					<cfelse>
						<cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid2" name="SNCDvalor2" desc="SNCDdescripcion2" tabindex="1">
					</cfif>
				</td>	
			</tr>
			<tr>
				<td valign="top" nowrap><strong>Cliente Inicial</strong></td>
				<td nowrap><strong>Cliente Final</strong></td>
			</tr>
			<tr>
				<td>
					<cfset valuesArray = ArrayNew(1)>
					<cfif isdefined("Form.SNcodigo") and LEN(Form.SNcodigo) GT 0>
						<cfquery name="rsCliente" datasource="#session.DSN#">
							select SNcodigo,SNnombre,SNnumero
							from SNegocios
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
							  and SNtiposocio in ('A','C')
							  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
						</cfquery>
						<cfset ArrayAppend(valuesArray, rsCliente.SNcodigo)>
						<cfset ArrayAppend(valuesArray, rsCliente.SNnumero)>
						<cfset ArrayAppend(valuesArray, rsCliente.SNnombre)>
					</cfif>
					<cf_conlis 
						title="Lista de Clientes"
						campos = "SNcodigo,SNnumero,SNnombre"
						desplegables = "N,S,S" 
						modificables = "N,S,N"
						size = "0,15,30"
						valuesarray="#valuesArray#" 
						tabla="SNegocios"
						columnas="SNcodigo, SNnombre, SNnumero, SNidentificacion"
						filtro="Ecodigo = #Session.Ecodigo#
								  and SNtiposocio in ('A','C')
								  order by SNnombre, SNnumero"
						desplegar="SNnumero,SNidentificacion,SNnombre"
						filtrar_por="SNnumero,SNidentificacion,SNnombre"
						etiquetas="C&oacute;digo,Identificaci&oacute;n,Nombre"
						formatos="S,S,S"
						align="left,left,left"
						asignar="SNcodigo,SNnumero,SNnombre"
						asignarformatos="S,S,S"
						left="125"
						top="100"
						width="750"
						tabindex="1"
						ajustar="false">
				</td>
				<td>
					<cfset valuesArray = ArrayNew(1)>
					<cfif isdefined("Form.SNcodigo2") and LEN(Form.SNcodigo2) GT 0>
						<cfquery name="rsCliente" datasource="#session.DSN#">
							select SNcodigo,SNnombre,SNnumero
							from SNegocios
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
							  and SNtiposocio in ('A','C')
							  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo2#">
						</cfquery>
						<cfset ArrayAppend(valuesArray, rsCliente.SNcodigo)>
						<cfset ArrayAppend(valuesArray, rsCliente.SNnumero)>
						<cfset ArrayAppend(valuesArray, rsCliente.SNnombre)>
					</cfif>
					<cf_conlis 
						title="Lista de Clientes"
						campos = "SNcodigo2,SNnumero2,SNnombre2"
						desplegables = "N,S,S" 
						modificables = "N,S,N"
						size = "0,15,30"
						valuesarray="#valuesArray#" 
						tabla="SNegocios"
						columnas="SNcodigo as SNcodigo2, SNnombre as SNnombre2, SNnumero as SNnumero2, SNidentificacion as SNidentificacion2"
						filtro="Ecodigo = #Session.Ecodigo#
								  and SNtiposocio in ('A','C')
								  order by SNnombre, SNnumero "
						desplegar="SNnumero2,SNidentificacion2,SNnombre2"
						filtrar_por="SNnumero,SNidentificacion,SNnombre"
						etiquetas="C&oacute;digo,Identificaci&oacute;n,Nombre"
						formatos="S,S,S"
						align="left,left,left"
						asignar="SNcodigo2,SNnumero2,SNnombre2"
						asignarformatos="S,S,S"
						left="125"
						top="100"
						width="750"
						tabindex="1"
						ajustar="false">
				</td>
			</tr>
			<tr>
				<td nowrap><strong>Transacci&oacute;n</strong></td>
				<td nowrap><strong>Fecha de Corte</strong></td>
			</tr>
			<tr>
				<td>
					<select name="CCTcodigoE" tabindex="1">
						<option value="">Todas</option>
						<cfloop query="rsTransacciones">
							<option value="#rsTransacciones.CCTcodigo#" 
							<cfif isdefined('Form.CCTcodigoE') and #rsTransacciones.CCTcodigo# EQ #Form.CCTcodigoE#>selected</cfif>>
								#rsTransacciones.CCTdescripcion#
							</option>
						</cfloop>
					</select>	
				</td>
				<td>
					<cfif isdefined('Form.Corte') and LEN(Form.Corte) GT 0>
						<cf_sifcalendario form="form1" value="#LSDateFormat(Form.Corte,'dd/mm/yyyy')#" name="Corte" tabindex="1">
					<cfelse>
						<cf_sifcalendario form="form1" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="Corte" tabindex="1">	
					</cfif>
				</td>
			</tr>
			<tr>
				<td colspan="4" align="center">
					<cf_botones exclude="Alta,Limpiar" include="Generar,Limpiar" includevalues="Generar,Limpiar" tabindex="1">
					<input name="marcados" type="hidden" value="" id="marcados"  tabindex="-1">
				</td>
			</tr>
		</table>
		</fieldset>
	
		<cf_qforms>
			<cf_qformsRequiredField name="SNcodigo" description="Cliente Inicial">
			<cf_qformsRequiredField name="SNcodigo2" description="Cliente Final">
			<cf_qformsRequiredField name="SNCEid" description="Clasificación">
			<cf_qformsRequiredField name="SNCDid1" description="Valor de Clasificación Desde">
			<cf_qformsRequiredField name="SNCDid2" description="Valor de Clasificación Hasta">
			<!---<cf_qformsRequiredField name="CCTcodigoE" description="Transacción">--->
		</cf_qforms>
		<script language="javascript" type="text/javascript">
			function valida(tasa){ 
				var nombre;
				if (tasa.name){
					p = tasa.value;
					nombre = tasa.name;
				}
				else 
					p = tasa;
				
				p = qf(p);
				
				if (p > 100) {
					alert('La tasa de inters digitada debe estar entre 0 y 100.');			
					eval("document.form1."+ nombre + ".value = '0.00'");
					eval("document.form1."+ nombre + ".focus();");
					return false;
				}
			} 
			
		</script>
	</cfoutput>