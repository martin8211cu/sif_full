<cfquery datasource="#session.dsn#" name="direcciones">
	select 
		b.id_direccion, 
		SNDcodigo as texto_direccion
	from SNegocios a
		inner join SNDirecciones b
			on a.SNid = b.SNid
	where a.Ecodigo = #Session.Ecodigo#
	  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#"> 
</cfquery>
<cfif isdefined('form.id_direccion')>
	<cfquery name="rsSaldo" datasource="#session.DSN#">
		select	coalesce(sum(round(d.Dsaldo  * d.Dtcultrev * case when t.CCTtipo = 'D' then $1.00 else -$1.00 end, 2)),0.00) as Saldo
		from Documentos d
		inner join CCTransacciones t
			on t.CCTcodigo = d.CCTcodigo
			and t.Ecodigo = d.Ecodigo
		left outer join Oficinas ofi
			on ofi.Ecodigo = d.Ecodigo
			and ofi.Ocodigo = d.Ocodigo
		left outer join DireccionesSIF di
			on  di.id_direccion = d.id_direccionFact
			where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and d.Dsaldo <> 0.00
			  and d.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
			  and d.id_direccionFact = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">	
			  <cfif isdefined("form.Ocodigo_F") and form.Ocodigo_F gt -1>
				  and d.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo_F#">
			  </cfif>
	</cfquery>
	<cf_dbfunction name="spart" args="snd.SNnombre,1,32" returnvariable="LvarSubstring">
	<cfquery name="rsDatosDir" datasource="#session.DSN#">
		select SNDcodigo,
		case when <cf_dbfunction name="length" args="snd.SNnombre"> > 32
			then <cf_dbfunction name="concat" args="#LvarSubstring# + '...'" delimiters="+"> else snd.SNnombre end as SNnombre,
		
		SNDactivo,SNDlimiteFactura,SNLadicional, fdesde, fhasta
		from SNDirecciones snd
		left outer join SNLimiteCredito lc
		   on snd.id_direccion = lc.id_direccion
		  and snd.Ecodigo = lc.Ecodigo
		  and snd.SNcodigo = lc.SNcodigo
		  and lc.Vigente = 1		  
		where snd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and snd.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
		  and snd.id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">
	</cfquery>
	
	<cfquery datasource="#session.dsn#" name="clasesDir">
		select sn.id_direccion,e.SNCEid, e.SNCEcorporativo, 
				e.SNCEcodigo, e.SNCEdescripcion, e.PCCEobligatorio,
				d.SNCDid , d.SNCDvalor, d.SNCDdescripcion, 
				case when e.Ecodigo is null then 0 else 1 end as local
		from SNClasificacionE e
		inner join SNClasificacionD d
		   on d.SNCEid = e.SNCEid
		inner join SNClasificacionSND sn
		   on sn.SNCDid = d.SNCDid
		  and sn.SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.SNid#">
		  and sn.id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">
		where e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and ( e.Ecodigo is null or e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
		  and e.PCCEactivo = 1
		order by local, e.SNCEcodigo, e.SNCEdescripcion, e.SNCEid, d.SNCDdescripcion 
	</cfquery>
</cfif>

<cf_templatecss>

<body>


<form name="formDetalle" method="post">
	<cfoutput>
	<input name="SNcodigo" type="hidden" value="#form.SNcodigo#">
	<input name="Ocodigo_F" type="hidden" value="#form.Ocodigo_F#">
	<input name="tabs" type="hidden" value="3">
	</cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0" border="0"><cfoutput>
		<tr><td class="tituloListas" colspan="2">&nbsp;</td></tr>
		<tr  class="tituloListas">
			<td  align="right"><strong>Direcci&oacute;n:</strong>&nbsp;</td>
			<td>
				<select style="width:170px" name="id_direccion" id="id_direccion" tabindex="1" onChange="javascript: document.formDetalle.submit();">
					<option value="-1">-- Seleccione una --</option>
					<cfloop query="direcciones">
						<option value="#id_direccion#" <cfif isdefined('form.id_direccion') and id_direccion EQ form.id_direccion>selected</cfif>>
							#HTMLEditFormat(texto_direccion)#
						</option>
					</cfloop>
				</select>
			</td>
		</tr>
		<tr><td class="tituloListas" colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<cfif isdefined('rsDatosDir') and rsDatosDir.RecordCount>
		<tr>
			<td colspan="2" align="center">
				<table width="90%" cellpadding="2" cellspacing="1" border="0">
					<tr class="tituloListas">
						<td><strong>C&oacute;digo</strong></td>
						<td><strong>Descripci&oacute;n</strong></td>
						<td><strong>Activa</strong></td>
						<td nowrap><strong>L&iacute;mite de Compra</strong></td>
						<td nowrap><strong>L&iacute;mite de Adicional de Direcci&oacute;n</strong></td>
						<td><strong>Desde</strong></td>
						<td><strong>Hasta</strong></td>
						<td nowrap><strong>Saldo Actual</strong></td>
					</tr>
					<tr>
						<td align="center" nowrap>#HTMLEditFormat(rsDatosDir.SNDcodigo)#</td>
						<td nowrap><cfif LEN(TRIM(rsDatosDir.SNnombre))>#HTMLEditFormat(rsDatosDir.SNnombre)#<cfelse>#HTMLEditFormat('Sin descripción')#</cfif></td>
						<td align="center"><cfif rsDatosDir.SNDactivo><img border='0' src='../../imagenes/checked.gif'><cfelse><img border='0' src='../../imagenes/unchecked.gif'></cfif></td>
						<td align="right"><cfif LEN(TRIM(rsDatosDir.SNDlimiteFactura))>#HTMLEditFormat(LSCurrencyFormat(rsDatosDir.SNDlimiteFactura,'none'))#<cfelse>#HTMLEditFormat('Sin asignar')#</cfif></td>
						<td >
							<cfif LEN(TRIM(rsDatosDir.SNLadicional))>
						  		<div align="right">#HTMLEditFormat(LSCurrencyFormat(rsDatosDir.SNLadicional,'none'))#</div>
							<cfelse>
							  <div align="left">#HTMLEditFormat('Sin asignar')#</div>
							</cfif>
						</td>
						<td nowrap><cfif LEN(TRIM(rsDatosDir.fdesde))>#HTMLEditFormat(LSDateFormat(rsDatosDir.fdesde,'dd/mm/yyyy'))#<cfelse>#HTMLEditFormat('Sin asignar')#</cfif></td>
						<td nowrap><cfif LEN(TRIM(rsDatosDir.fhasta))>#HTMLEditFormat(LSDateFormat(rsDatosDir.fhasta,'dd/mm/yyyy'))#<cfelse>#HTMLEditFormat('Sin asignar')#</cfif></td>
						<td align="right">#HTMLEditFormat(LSCurrencyFormat(rsSaldo.Saldo,'none'))#</td>
					</tr>
				</table>
			</td>
		</tr>
		</cfif>
		<tr><td colspan="2">&nbsp;</td></tr>
		</cfoutput>
		<cfif isdefined('clasesDir') and clasesDir.RecordCount>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td colspan="2">
				<table align="center" border="0" width="91%" cellpadding="3" cellspacing="0">
					<tr><td colspan="2" class="tituloAlterno">Clasificaciones</td></tr>
					<cfoutput query="clasesDir" group="local">
						<tr>
							<td colspan="2" class="tituloListas">
								<cfif local>Clasificaciones locales<cfelse>Clasificaciones corporativas</cfif>
							</td>
						</tr>
						<cfset linea = 0>
						<cfoutput group="SNCEid">
							<tr <cfif linea EQ 0>class="listaNon"<cfelse>class="listaPar"</cfif>>
								<td>#HTMLEditFormat(SNCEdescripcion)#</td>
								<td>#HTMLEditFormat(SNCDdescripcion)#</td>
							</tr>
							<cfif linea EQ 0><cfset linea = 1><cfelse><cfset linea=0></cfif>
						</cfoutput>
					</cfoutput>
					<cfif clasesDir.RecordCount EQ 0>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2" align="center" style="font-size:18px;">No hay clasificaciones definidas.<br>Haga clic aqu&iacute; para definirlas.</td></tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					</cfif>
				</table>
			</td>
		</tr>
		</cfif>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr> 
			<td colspan="2" align="center" valign="top" nowrap> 
				<cf_botones Regresar="#Regresa#" exclude="Alta,Baja,Cambio,Limpiar">
			</td>
		</tr>
	</table>
</form>