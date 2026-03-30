<cfquery name="rsGarantias" datasource="#Attributes.Conexion#">
	select b.Gid, b.EFid, b.Miso4217, b.Gtipo, b.Gref, b.Gmonto, b.Ginicio, b.Gvence, b.Gcustodio, b.Gestado, b.Gobs,
		   c.PQcodigo, c.PQnombre, c.PQdescripcion
	from ISBproducto a
		inner join ISBgarantia b
			on b.Contratoid = a.Contratoid
		inner join ISBpaquete c
			on c.PQcodigo = a.PQcodigo
	where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
	<cfif Attributes.vista EQ 1>
	and a.CTcondicion = 'C'
	<cfelseif Attributes.vista EQ 2>
		and a.CTcondicion not in ('C')
		<cfif ExisteContrato>
			and a.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idcontrato#">
		</cfif>
	</cfif>
</cfquery>

<cfoutput>

  <table width="100%" border="0" cellspacing="0" cellpadding="2">
	<cfif rsGarantias.recordCount GT 0 ><tr align="center"><td class="subTitulo" colspan="4">Dep&oacute;sito de Garant&iacute;a</td></tr></cfif>
	<cfloop query="rsGarantias">
		<cfif rsGarantias.currentRow NEQ 1>
		<tr>
		  <td colspan="4">
			<hr />
		  </td>
		</tr>
		</cfif>
		<tr>
		  <td align="#Attributes.alignEtiquetas#"><label>Paquete</label></td>
		  <td>
			 #rsGarantias.PQdescripcion#
		  </td>
		  <td align="#Attributes.alignEtiquetas#"><label>Tipo</label></td>
		  <td>
		  		<cfquery name="rsTipo" datasource="#Attributes.Conexion#">
					select FIDCOD,FIDDES  from SSXFID where FIDCOD=<cfqueryparam cfsqltype="cf_sql_integer"  value="#val(rsGarantias.Gtipo)#">
				</cfquery>
				#rsTipo.FIDDES#
		  </td>
		</tr>
		<tr>
		  <td align="#Attributes.alignEtiquetas#" width="15%"><label>Monto</label></td>
		  <td width="35%">
				<cfset monto = 0>
				<cfif Len(Trim(rsGarantias.Gmonto))>
					<cfset monto = LSNumberFormat(rsGarantias.Gmonto, '9')>
				</cfif>
				#monto#
		  </td>
		  <td align="#Attributes.alignEtiquetas#" width="15%"><label>Moneda</label></td>
		  <td width="35%">
				<cfset idmoneda = "">
				<cfif Len(Trim(rsGarantias.Miso4217))>
					<cfset idmoneda = rsGarantias.Miso4217>
				</cfif>
				<cf_moneda
					id = "#idmoneda#"
					sufijo = "_#rsGarantias.Gid#"
					form = "#Attributes.form#"
					Ecodigo = "#Attributes.Ecodigo#"
					Conexion = "#Attributes.Conexion#"
					readOnly = "true"
				>
		  </td>
		</tr>
		<cfif ListFind('3,9,10', #rsTipo.FIDCOD#)>
		<tr>
		  <td align="#Attributes.alignEtiquetas#"><label>Banco</label></td>
		  <td>
				<cfset identidad = "">
				<cfif Len(Trim(rsGarantias.EFid))>
					<cfset identidad = rsGarantias.EFid>
				</cfif>
				<cf_entidad
					id = "#identidad#"
					sufijo = "_#rsGarantias.Gid#"
					form = "#Attributes.form#"
					Ecodigo = "#Attributes.Ecodigo#"
					Conexion = "#Attributes.Conexion#"
					readOnly="true"
				>
		  </td>
		  <td align="#Attributes.alignEtiquetas#"><label>Referencia</label></td>
		  <td>
				#HTMLEditFormat(rsGarantias.Gref)#
		  </td>
		</tr>
		<tr>
		  <td align="#Attributes.alignEtiquetas#"><label>Fecha</label></td>
		  <td>
			   	#LSDateFormat(rsGarantias.Ginicio, 'dd/mm/yyyy')#
		  </td>
<!---		  <td align="#Attributes.alignEtiquetas#"><label>Custodio</label></td>
		  <td>
		  		#HTMLEditFormat(rsGarantias.Gcustodio)#
		  </td>
--->		</tr>
		<tr>
		  <td align="#Attributes.alignEtiquetas#"><label>Observaci&oacute;n</label></td>
		  <td colspan="3"> 
		  		#HTMLEditFormat(rsGarantias.Gobs)#
		  </td>
		</tr>
		</cfif>
	</cfloop>
  </table>
</cfoutput>
